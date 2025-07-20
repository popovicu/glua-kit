# glua-kit

**glua-kit (Glue Lua kit)** is a Bazel-based monorepo for integrating ("gluing") *mainline Lua* into applications and build flows in general.

> :warning: This project is not ready for any sort of production use at this point.
> Use with caution for any non-experimental setting and please file requests for any features you'd like to see for production use.
> At the moment, consider this codebase a proof of concept only.

The main concept here is that the mainline Lua project is the source of truth for how Lua should run, and it gets rapid updates.

## Example API usage

If you would like to declare a remote dependency on `glua-kit` from your Bazel project, take a look at [this example](https://github.com/popovicu/glua-kit-example) to see how.

## Go demo

Simply run:

```
bazel run //testing/go:demo
```

> :warning: If you're facing linker issues, consider using the `linkopt` flag like below, for example.
> If you customize the linking with `linkopt`, you may want to use your flag for all the builds as your Bazel cache otherwise gets discarded.

```
bazel run --linkopt=-fuse-ld=gold //testing/go:demo
```

## C demo

```
bazel run //tools/single_script -- PATH_TO_YOUR_LUA_SCRIPT
```

In my case, I pointed to the script from the monorepo:

```
bazel run //tools/single_script -- /home/uros/work/glua-kit/codegen/cc/testing/test.lua
```

There is also a small proof of concept build definition for Bazel that inlines a Lua script file into a C header file:

```
bazel build //codegen/cc/testing:test.h
```

## Bazel-built Lua binary

```
bazel build //testing/compilation:add.luac
```

This creates the `add.luac` bytecode file.

```
file bazel-bin/testing/compilation/add.luac
bazel-bin/testing/compilation/add.luac: Lua bytecode, version 5.4
```

You can do something like:

```
bazel run @lua_mainline//src:lua -- PATH_TO_THE_BYTECODE_FILE
```

to run the bytecode file from the built Lua interpreter.