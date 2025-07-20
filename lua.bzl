def _impl_local(rctx):
    # TODO: hash
    rctx.download_and_extract(
        url = "https://www.lua.org/ftp/lua-5.4.8.tar.gz",
        strip_prefix = "lua-5.4.8",
        output = ".",
    )

    rctx.file(
        "./BUILD",
        content = "",
    )

    # Below comes from: https://www.lua.org/source/5.4/

    rctx.file(
        "./src/BUILD",
        content = """package(
    default_visibility = [
        "//visibility:public",
    ],
)

cc_library(
    name = "includes",
    hdrs = [
        "lua.h",
        "lauxlib.h",
        "lualib.h",
        "luaconf.h",
    ],
    includes = [
        ".",
    ],
)

cc_library(
    name = "core",
    hdrs = [
        "lapi.h",
        "lcode.h",
        "lctype.h",
        "ldebug.h",
        "ldo.h",
        "lfunc.h",
        "lgc.h",
        "ljumptab.h",
        "llex.h",
        "llimits.h",
        "lmem.h",
        "lobject.h",
        "lopcodes.h",
        "lopnames.h",
        "lparser.h",
        "lprefix.h",
        "lstate.h",
        "lstring.h",
        "ltable.h",
        "ltm.h",
        "lundump.h",
        "lvm.h",
        "lzio.h",
    ],
    srcs = [
        "lapi.c",
        "lcode.c",
        "lctype.c",
        "ldebug.c",
        "ldo.c",
        "ldump.c",
        "lfunc.c",
        "lgc.c",
        "llex.c",
        "lmem.c",
        "lobject.c",
        "lopcodes.c",
        "lparser.c",
        "lstate.c",
        "lstring.c",
        "ltable.c",
        "ltm.c",
        "lundump.c",
        "lvm.c",
        "lzio.c",
    ],
    deps = [
        ":includes",
    ],
)

cc_library(
    name = "libraries",
    srcs = [
        "lauxlib.c",
        "lbaselib.c",
        "lcorolib.c",
        "ldblib.c",
        "liolib.c",
        "lmathlib.c",
        "loadlib.c",
        "loslib.c",
        "lstrlib.c",
        "ltablib.c",
        "lutf8lib.c",
        "linit.c",
    ],
    deps = [
        ":core",
    ],
)

cc_binary(
    name = "lua",
    srcs = [
        "lua.c",
    ],
    deps = [
        ":includes",
        ":core",
        ":libraries",
    ],
)

cc_binary(
    name = "luac",
    srcs = [
        "luac.c",
    ],
    deps = [
        ":includes",
        ":core",
        ":libraries",
    ],
)
""",
    )

lua_repo = repository_rule(
    implementation = _impl_local,
    attrs = {},
)
