RAYLIB_PATH	?= ../../raylib
LUA_PATH	?= C:/lua/lua-5.5.1


RAYLIB_OUT	:= raylib
LUA_OUT		:= lua


.PHONY: raylib-desktop
raylib-desktop:
	$(MAKE) -C $(RAYLIB_PATH) clean
	$(MAKE) -j 32 -C $(RAYLIB_PATH)/src \
		PLATFORM=PLATFORM_DESKTOP \
		RAYLIB_LIBTYPE=STATIC \
		BUILD_MODE=RELEASE
	mkdir -p $(RAYLIB_OUT)
	cp $(RAYLIB_PATH)/src/libraylib.a \
		$(RAYLIB_PATH)/src/raylib.h \
		$(RAYLIB_PATH)/src/raymath.h \
		$(RAYLIB_PATH)/src/rlgl.h $(RAYLIB_OUT)/


.PHONY: lua-mingw
lua-mingw:
	$(MAKE) -C $(LUA_PATH) clean
	$(MAKE) -j 32 -C $(LUA_PATH) mingw
	$(MAKE) -C $(LUA_PATH) local TO_BIN="lua.exe luac.exe"
	mkdir -p $(LUA_OUT)
	cp $(LUA_PATH)/install/lib/liblua.a \
		$(LUA_PATH)/install/include/*.h \
		$(LUA_PATH)/install/include/*.hpp $(LUA_OUT)/
