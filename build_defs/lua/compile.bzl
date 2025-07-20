def _lua_compile_impl(ctx):
    compiler = ctx.executable.compiler
    output = ctx.outputs.out

    ctx.actions.run(
        inputs = [ctx.file.lua],
        outputs = [output],
        arguments = ["-o", output.path, ctx.file.lua.path],
        executable = compiler,
        progress_message = "Running the luac compiler",
    )

    return [
        DefaultInfo(files = depset([output])),
    ]

lua_compile = rule(
    implementation = _lua_compile_impl,
    attrs = {
        "lua": attr.label(
            allow_single_file = True,
        ),
        "out": attr.output(
            mandatory = True,
            doc = "The output compiled file",
        ),
        "compiler": attr.label(
            default = Label("@lua_mainline//src:luac"),
            allow_files = True,
            executable = True,
            cfg = "exec",
        ),
    },
    provides = [
        DefaultInfo,
    ],
    # TODO: consider using a toolchain
)
