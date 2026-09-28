# project folders
BIN	:= bin
BUILD:= build
SRC := src
LIBS := libs

# variables
SRCS := $(wildcard $(SRC)/*.c)
OBJS := $(SRCS:$(SRC)/%.c=$(BUILD)/%.o)
DEPS := $(OBJS:.o=.d)

# libs
LIB_RAYLIB := $(LIBS)/raylib/libraylib.a
RAYLIB := -I$(LIBS)/raylib

LIB_LUA := $(LIBS)/lua/liblua.a
LUA := -I$(LIBS)/lua

# compiler flags
CFLAGS := -std=c23 -Wall
CFLAGS += $(RAYLIB) $(LUA) -MMD -MP -g -fsanitize=undefined -fsanitize-trap
CFLAGS += -DSCRIPT_DIR='"$(CURDIR)/$(SRC)"'

# linker flags
LDFLAGS :=
LDLIBS := $(LIB_LUA) $(LIB_RAYLIB) -lopengl32 -lgdi32 -lwinmm

# targets
all: $(BIN)/main.exe

$(BIN)/main.exe: $(OBJS) $(LIB_RAYLIB) $(LIB_LUA)
	mkdir -p $(BIN)
	gcc $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

$(BUILD)/%.o: $(SRC)/%.c
	mkdir -p $(BUILD)
	gcc $(CFLAGS) -c -o $@ $<

-include $(DEPS)

$(LIB_RAYLIB):
	$(MAKE) -C $(LIBS) raylib-desktop

$(LIB_LUA):
	$(MAKE) -C $(LIBS) lua-mingw

clean:
	rm -rf $(BIN) $(BUILD)