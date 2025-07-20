load("@rules_go//go:def.bzl", "go_binary", "go_cross_binary")

go_binary(
    name = "demo",
    srcs = [
        "demo.go",
    ],
    cgo = True,
    deps = [
        "//go/vm",
    ],
)

# TODO: this target is broken at the moment.
go_cross_binary(
    name = "demo_x86_64",
    platform = "//platforms:x86_64_linux",
    target = ":demo",
)
