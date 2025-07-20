package vm

/*
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Wrapper for luaL_dostring macro
// cgo isn't able to otherwise call macros directly!
// static to force internal linking
static int wrap_luaL_dostring(lua_State *L, const char *s) {
    return luaL_dostring(L, s);
}

// Wrapper for lua_pop macro
// Same as the above
static void wrap_lua_pop(lua_State *L, int n) {
    lua_pop(L, n);
}

static const char* wrap_lua_tostring(lua_State *L, int index) {
    return lua_tostring(L, index);
}
*/
import "C"
import (
	"fmt"
	"unsafe"
)

type LuaVm struct {
	L *C.lua_State
}

func NewVm() (*LuaVm, error) {
	// Create the Lua state.
	L := C.luaL_newstate()
	if L == nil {
		return nil, fmt.Errorf("unable to create a new Lua state")
	}

	// Load the standard libraries.
	C.luaL_openlibs(L)

	return &LuaVm{L: L}, nil
}

func (vm *LuaVm) Close() {
	if vm.L != nil {
		C.lua_close(vm.L)
		vm.L = nil // Avoid double-free
	}
}

func (vm *LuaVm) RunCode(code string) error {
	cCode := C.CString(code)
	defer C.free(unsafe.Pointer(cCode))

	if result := C.wrap_luaL_dostring(vm.L, cCode); result != C.LUA_OK {
		// Get the error message from the Lua stack.
		errStr := C.GoString(C.wrap_lua_tostring(vm.L, -1))
		C.wrap_lua_pop(vm.L, 1) // Pop the error message from the stack.
		return fmt.Errorf("lua error: %s", errStr)
	}
	return nil
}
