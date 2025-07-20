load("@rules_go//go:def.bzl", "go_library")

package(
    default_visibility = [
        "//visibility:public",
    ],
)

go_library(
    name = "vm",
    srcs = [
        "vm.go",
    ],
    cdeps = [
        "@lua_mainline//src:includes",
        "@lua_mainline//src:core",
        "@lua_mainline//src:libraries",
    ],
    cgo = True,
    importpath = "github.com/popovicu/glua-kit/vm",
)
