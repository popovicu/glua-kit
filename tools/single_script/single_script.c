#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int main(int argc, char *argv[]) {
    // Check if a file path is provided as a command-line argument
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <lua_script_file>\n", argv[0]);
        return 1;
    }

    const char *lua_file_path = argv[1];

    // 1. Create a Lua state
    lua_State *L = luaL_newstate();
    if (L == NULL) {
        fprintf(stderr, "Failed to create Lua state.\n");
        return 1;
    }

    // 2. Load standard libraries (for 'print')
    luaL_openlibs(L);

    // 3. Execute the Lua code from the file
    // luaL_dofile loads and runs the given file.
    // It returns 0 (LUA_OK) on success, or an error code on failure.
    int result = luaL_dofile(L, lua_file_path);

    if (result != LUA_OK) {
        // Get the error message from the top of the stack
        const char *error_message = lua_tostring(L, -1);
        fprintf(stderr, "Error executing Lua file '%s': %s\n", lua_file_path, error_message);
        lua_pop(L, 1); // Pop the error message
    } else {
        printf("C: Lua file '%s' executed successfully.\n", lua_file_path);
    }

    // 4. Close the Lua state
    lua_close(L);

    return 0;
}
