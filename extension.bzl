load("//:lua.bzl", "lua_repo")

def _glua_impl(_mctx):
    lua_repo(
        name = "lua_mainline",  # TODO: consider not hardcoding
    )

glua = module_extension(
    implementation = _glua_impl,
)
