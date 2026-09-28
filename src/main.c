#include <raylib.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <assert.h>
#include <stdio.h>

int main(void) {
    lua_State *L;
    const char *othervar = "default";

    ChangeDirectory(GetApplicationDirectory());

    L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushstring(L, "hello lua!");
    lua_setglobal(L, "myvar");
    if (luaL_loadfile(L, SCRIPT_DIR "/init.lua") || lua_pcall(L, 0, 0, 0)) {
        printf("Lua error: %s\n", lua_tostring(L, -1));
        assert(0);
    }

    /* Value stays on the stack until lua_close, so the string stays valid. */
    lua_getglobal(L, "othervar");
    if (lua_isstring(L, -1)) {
        othervar = lua_tostring(L, -1);
    }

    InitWindow(800, 450, "Hello Lua");
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText(othervar, 300, 200, 20, DARKGRAY);
        EndDrawing();
    }

    CloseWindow();
    lua_close(L);
    return 0;
}
