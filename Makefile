# project folders
BIN	:= bin
BUILD:= build
SRC := src
LIBS := libs
ASSETS := assets

# variables
SRCS := $(wildcard $(SRC)/*.c)
OBJS := $(SRCS:$(SRC)/%.c=$(BUILD)/%.o)
DEPS := $(OBJS:.o=.d)
WEB_OBJS := $(SRCS:$(SRC)/%.c=$(BUILD)/web/%.o)
WEB_DEPS := $(WEB_OBJS:.o=.d)

# libs
LIB_RAYLIB := $(LIBS)/raylib/libraylib.a
LIB_RAYLIB_WEB := $(LIBS)/raylib/libraylib.web.a
WEB_SHELL := $(LIBS)/raylib/minshell.html
RAYLIB := -I$(LIBS)/raylib

LIB_LUA := $(LIBS)/lua/liblua.a
LIB_LUA_WEB := $(LIBS)/lua/liblua.web.a
LUA := -I$(LIBS)/lua



# preprocessor flags
CPPFLAGS := $(RAYLIB) $(LUA) -MMD -MP
CPPFLAGS += -DLUA_DIR=\"$(CURDIR)/$(SRC)\"

# compiler flags
CFLAGS := -std=c23 -Wall -pedantic
CFLAGS += -g -fsanitize=undefined -fsanitize-trap

# linker flags
LDFLAGS :=
LDLIBS := $(LIB_LUA) $(LIB_RAYLIB) -lopengl32 -lgdi32 -lwinmm

# web flags
WEB_CPPFLAGS := $(RAYLIB) $(LUA) -MMD -MP -DLUA_DIR=\"\"
WEB_CFLAGS := -std=c2x -Wall -pedantic
WEB_LDFLAGS := -sUSE_GLFW=3 -sASYNCIFY --shell-file $(WEB_SHELL)
WEB_LDFLAGS += --preload-file $(SRC)/init.lua@/init.lua

# tools
CLANG_FORMAT ?= clang-format

# targets
all: $(BIN)/main.exe

run: all
	./$(BIN)/main.exe

$(BIN)/main.exe: $(OBJS) $(LIB_RAYLIB) $(LIB_LUA)
	mkdir -p $(BIN)
	gcc $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

$(BUILD)/%.o: $(SRC)/%.c | $(LIB_RAYLIB) $(LIB_LUA)
	mkdir -p $(BUILD)
	gcc $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

web: $(BIN)/index.html

run-web: web
	python -m http.server 8000 -d $(BIN)

$(BIN)/index.html: $(WEB_OBJS) $(LIB_RAYLIB_WEB) $(LIB_LUA_WEB)
	mkdir -p $(BIN)
	emcc -o $@ $(WEB_OBJS) $(LIB_LUA_WEB) $(LIB_RAYLIB_WEB) $(WEB_LDFLAGS)

$(BUILD)/web/%.o: $(SRC)/%.c | $(LIB_RAYLIB_WEB) $(LIB_LUA_WEB)
	mkdir -p $(BUILD)/web
	emcc $(WEB_CPPFLAGS) $(WEB_CFLAGS) -c -o $@ $<

-include $(DEPS) $(WEB_DEPS)

$(LIB_RAYLIB):
	$(MAKE) -C $(LIBS) raylib-desktop

$(LIB_RAYLIB_WEB):
	$(MAKE) -C $(LIBS) raylib-web

$(LIB_LUA):
	$(MAKE) -C $(LIBS) lua-mingw

$(LIB_LUA_WEB):
	$(MAKE) -C $(LIBS) lua-web

clean:
	rm -rf $(BIN) $(BUILD)

format:
	$(CLANG_FORMAT) -i $(SRCS) $(wildcard $(SRC)/*.h)

.PHONY: all run web run-web clean format