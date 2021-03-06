local skynet = require "skynet"
require "skynet.manager"
local socket = require "skynet.socket"
local crypt = require "skynet.crypt"


local settings = require "settings"
local skynet_node_name = ...


local U
local S = {}
local SESSION = 0
local timeout = 10 * 60 * 100	-- 10 mins
local _conf = {}


local CMD = {}


-- local function timesync(session, localtime, from)
-- 	-- return globaltime .. localtime .. eventtime .. session , eventtime = 0xffffffff
-- 	local now = skynet.now()
-- 	socket.sendto(U, from, string.pack(">IIII", now, localtime, 0xffffffff, session))
-- end

--[[
	4 bytes session
	16 bytes hmac   crypt.hmac_hash(secret, session .. data)
	padding data
]]

local function udpdispatch(msg, from)
	-- DEBUG("from:", socket.udp_address(from), " str:", crypt.hexencode(msg:sub(1, 4)))
	if string.len(msg) < 20 then
		DEBUG("Invalid msg data:", string.len(msg), " from:", socket.udp_address(from))
		return
	end

	local session = string.unpack("<i4", msg)
    local s = S[session]
	if s then
		if s.ip ~= from then
			local secret = msg:sub(5, 20)
			if s.secret ~= secret then
				DEBUG(string.format("Invalid signature of session %d from %s", session, socket.udp_address(from)) )
				return
			end

			s.time = skynet.now()
            -- if eventtime == 0xffffffff then
            --     return timesync(session, localtime, from)
            -- end
            -- -- NOTICE: after 497 days, the time will rewind
            -- if s.time > eventtime + timeout then
            --     DEBUG("The package is delay %f sec", (s.time - eventtime)/100)
            --     return
            -- elseif eventtime > s.time then
            --     -- drop this package, and force time sync
            --     return timesync(session, localtime, from)
            -- elseif s.lastevent and eventtime < s.lastevent then
            --     -- drop older event
            --     return
            -- end

            -- s.lastevent = eventtime
            skynet_send(s.arena_addr, "dispatch", {fd = U, from = from, }, msg:sub(21))
		end
    else
        DEBUG("Invalid session:", session, " from:", socket.udp_address(from))
    end
end

local function keepalive()
	-- trash session after no package last 10 mins (timeout)
	while true do
		local i = 0
		local ti = skynet.now()
		for session, s in pairs(S) do
			i=i+1
			if i > 100 then
				skynet.sleep(3000)	-- 30s
				ti = skynet.now()
				i = 1
			end
			if ti > s.time + timeout then
				DEBUG("S > timeout:", ti)
				S[session] = nil
			end
		end
		skynet.sleep(6000)	-- 1 min
	end
end

function CMD.register(data)
	local session = data.session
	local arena_addr = nil

	if session == 0 then
		arena_addr = skynet_call(".arena_mgr", "find", U, data) -- arena service addr watch
		SESSION = (SESSION + 1) & 0xffffffff
		S[SESSION] = {
			secret = data.secret,
			ip = data.ip, -- socket addr
			arena_addr = arena_addr,
			time = skynet.now(),
		}
		session = SESSION
	else
		-- 指定 arena
	end

	assert(arena_addr)

	DEBUG("====battle===register====:", inspect(data), inspect(S))

	return {
		session = session, --门牌
		host = _conf.host,
		port = _conf.port,
		secret = data.secret,
	}, {
		battle_node = skynet_node_name,
		arena_addr = arena_addr,
	}
end

function CMD.unregister(session)
	S[session] = nil
end

function CMD.post(session, data)
	local s = S[session]
	if s and s.address then
		socket.sendto(U, s.address, data)
	else
		DEBUG("Session is invalid %d", session)
	end
end

function CMD.open(conf)
	_conf = conf
	U = socket.udp(udpdispatch, "0.0.0.0", conf.port)
    INFO("Udp Server Listen fd:", U, " port:", conf.port)
    skynet.fork(keepalive)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(CMD[cmd], cmd .. "not found")
        skynet.retpack(f(...))
    end)
end)