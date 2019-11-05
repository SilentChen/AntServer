local skynet = require "skynet"

local lualib_path = "behavior_tree."
local data_path = "behavior_tree.data."

local behavior_ret = require(lualib_path .. "behavior_ret")
local behavior_node = require(lualib_path .. "behavior_node")

local meta = {
    __newindex = function(_, k)
        error(string.format("readonly:%s", k), 2)
    end
}

local function const(t)
    setmetatable(t, meta)
    for _, v  in pairs(t) do
        if type(v) == "table" then
            const(v)
        end
    end
    return t
end

local trees = {}


local mt = {}
mt.__index = mt

function mt:init(name)
    self.name = name

    local data = const(require(data_path .. name))
    self._root = behavior_node.new(data)
end

function mt:run(env)
    skynet.error("====="..self.name.." tick=====")
    local r = self._root:run(env)
    if r ~= behavior_ret.RUNNING then
        env.close_nodes = {}
    end
end

local function new_tree(name)
    local tree = setmetatable({}, mt)
    tree:init(name)
    trees[name] = tree
    return tree
end

local M = {}
function M.new(name, env)
    env.close_nodes = {}
    env.open_nodes = {}
    env.vars = {}

    local tree = trees[name] or new_tree(name)
    return {
        tree = tree,
        run = function()
            tree:run(env)
        end,
        set_var = function(_, k, v)
            env.vars[k] = v
        end,
        get_var = function(_, k)
            return env.vars[k]
        end
    }
end
return M