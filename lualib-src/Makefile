THIRD_LIB_ROOT ?= ../3rd/
SKYNET_ROOT ?= ../skynet/
include $(SKYNET_ROOT)platform.mk

PLAT ?= linux

#####################################################

SKYNET_LUA_INC ?= $(SKYNET_ROOT)/3rd/lua/
SKYNET_LUA_LIB ?= $(SKYNET_ROOT)/3rd/lua/
SKYNET_SRC ?= $(SKYNET_ROOT)/skynet-src

LFLAGS = $(SHARED) -I$(SKYNET_LUA_INC) -llua -L$(SKYNET_LUA_LIB) 

TLS_LIB ?=/usr/local/ssl/lib
TLS_INC ?=/usr/local/include

#####################################################
LUA_CLIB_PATH ?= ../luaclib

CRAB_INC ?= crab/
CJSON_INC ?= lua-cjson/
LFS_INC ?= luafilesystem/src/
CAOI_INC ?= skynet_aoi/
FFI_INC ?= luaffifb/
NAVIGATOR_INC ?= lua-recastnavigation/

#####################################################

CAOI_SO_NAME = caoi.so
WEBSOCKETNETPACK_SO_NAME = websocketnetpack.so

HASH_SO_NAME = hash.so
LFS_SO_NAME = lfs.so
WEBCLIENT_SO_NAME = webclient.so
UTF8_SO_NAME = utf8.so
CRAB_SO_NAME = crab.so
CJSON_SO_NAME = cjson.so

AES_SO_NAME = aes.so
CODEC_SO_NAME = codec.so
CRYPTO_SO_NAME = crypto.so

TBPACK_SO_NAME = libluabpack.so

FFI_SO_NAME = ffi.so

RUDP_SO_NAME = rudp.so
NAVIGATOR_SO_NAME = navigator.so

#####################################################

HASH_SO      			= $(LUA_CLIB_PATH)/$(HASH_SO_NAME)
LFS_SO 		 			= $(LUA_CLIB_PATH)/$(LFS_SO_NAME)
WEBCLIENT_SO 			= $(LUA_CLIB_PATH)/$(WEBCLIENT_SO_NAME)
UTF8_SO 	 			= $(LUA_CLIB_PATH)/$(UTF8_SO_NAME)
CRAB_SO 	 			= $(LUA_CLIB_PATH)/$(CRAB_SO_NAME)
WEBSOCKETNETPACK_SO		= $(LUA_CLIB_PATH)/$(WEBSOCKETNETPACK_SO_NAME)
CJSON_SO				= $(LUA_CLIB_PATH)/$(CJSON_SO_NAME)
CAOI_SO					= $(LUA_CLIB_PATH)/$(CAOI_SO_NAME)
AES_SO                  = $(LUA_CLIB_PATH)/$(AES_SO_NAME)
CODEC_SO                = $(LUA_CLIB_PATH)/$(CODEC_SO_NAME)
CRYPTO_SO               = $(LUA_CLIB_PATH)/$(CRYPTO_SO_NAME)

TBPACK_SO               = $(LUA_CLIB_PATH)/$(TBPACK_SO_NAME)

FFI_SO               	= $(LUA_CLIB_PATH)/$(FFI_SO_NAME)
NAVIGATOR_SO            = $(LUA_CLIB_PATH)/$(NAVIGATOR_SO_NAME)


#####################################################
all: $(HASH_SO) $(LFS_SO)  $(UTF8_SO) $(CRAB_SO) \
	$(WEBSOCKETNETPACK_SO) $(CJSON_SO)  \
	$(AES_SO) $(CODEC_SO) $(CRYPTO_SO)   \
	$(CAOI_SO) $(TBPACK_SO) $(RUDP_SO) $(NAVIGATOR_SO) \
	# $(FFI_SO)  \
#####################################################

# C Lib
$(HASH_SO): hash/lua-hash.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $<

$(LFS_SO): $(LFS_INC)lfs.c $<
	$(CC) $(CFLAGS) $(SHARED) -I$(SKYNET_LUA_INC) -I$(LFS_INC) $^ -o $@ $(LDFLAGS)

$(UTF8_SO): crab/lua-utf8.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $< -I$(CRAB_INC)

$(CRAB_SO): crab/lua-crab.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $< -I$(CRAB_INC)

$(WEBSOCKETNETPACK_SO): websocketnetpack/lua-websocketnetpack.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $< -I$(SKYNET_SRC)

$(AES_SO): luacrypto/lua-aes.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $< -L$(TLS_LIB) -I$(TLS_INC) -lcrypto

$(CODEC_SO): luacrypto/lua-codec.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $< -L$(TLS_LIB) -I$(TLS_INC) -lcrypto

$(CRYPTO_SO): luacrypto/lcrypto.c $<
	$(CC) $(LFLAGS) -o $@ $(CFLAGS) $< -L$(TLS_LIB) -I$(TLS_INC) -lcrypto

$(TBPACK_SO): thrift/lua-bpack.c $<
	$(CC) $(LFLAGS) -o $@ $< -I$(SKYNET_SRC)

$(RUDP_SO): rudp/rudp.c rudp/lua-rudp.c  $<
	$(CC) $(LFLAGS) $(CFLAGS) $^ -o $@

$syslog.so:lua-syslog/lua-syslog.c $<
	${CC} ${LFLAGS} ${SHARED} $< -o $@

#####################################################

$(CJSON_SO) : | $(LUA_CLIB_PATH)
	cd $(CJSON_INC) && $(MAKE) LUA_INCLUDE_DIR=../$(SKYNET_ROOT)/3rd/lua CC=$(CC) CJSON_LDFLAGS="$(SHARED)" && cp -f $(CJSON_SO_NAME) ../$(LUA_CLIB_PATH)

$(FFI_SO) : | $(LUA_CLIB_PATH)
	cd $(FFI_INC) && $(MAKE) LUA_INCLUDE_DIR=../$(SKYNET_ROOT)/3rd/lua CC=$(CC) && cp -f $(FFI_SO_NAME) ../$(LUA_CLIB_PATH)

$(NAVIGATOR_SO) : | $(LUA_CLIB_PATH)
	cd $(NAVIGATOR_INC) && $(MAKE) PLAT=$(PLAT) LUA_INC=../$(SKYNET_ROOT)/3rd/lua  && cp -f $(NAVIGATOR_SO_NAME) ../$(LUA_CLIB_PATH)

#####################################################
# C Service
$(CAOI_SO):
	cd $(CAOI_INC) && $(MAKE)

#####################################################

clean:
	rm -f $(LUA_CLIB_PATH)/*.so
	cd $(NAVIGATOR_INC) && $(MAKE) clean


.PHONY: all clean
