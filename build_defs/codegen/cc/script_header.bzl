def _script_carrier_impl(ctx):
    tool = ctx.executable.tool
    output_header = ctx.outputs.out

    ctx.actions.run(
        inputs = [ctx.file.lua],
        outputs = [output_header],
        arguments = ["--lua_input_file", ctx.file.lua.path, "--header_guard_name", ctx.attr.header_guard, "--output_file_path", output_header.path, "--symbol_name", ctx.attr.symbol],
        executable = tool,
        progress_message = "Running the generator",
    )

    return [
        DefaultInfo(files = depset([output_header])),
    ]

script_carrier = rule(
    implementation = _script_carrier_impl,
    attrs = {
        "lua": attr.label(
            allow_single_file = True,
        ),
        "header_guard": attr.string(
            mandatory = True,
        ),
        "symbol": attr.string(
            mandatory = True,
        ),
        "out": attr.output(
            mandatory = True,
            doc = "The output header file",
        ),
        "tool": attr.label(
            default = Label("//codegen/cc:header_gen"),
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
