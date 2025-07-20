package main

import (
	"fmt"
	"log"

	"github.com/popovicu/glua-kit/vm"
)

func main() {
	fmt.Println("Hello world")

	lua, err := vm.NewVm()

	if err != nil {
		log.Fatalf("unable to instantiate a Lua VM")
	}

	program := "local a = 10\nlocal b = 25\nprint(a + b)\n"

	err = lua.RunCode(program)

	if err != nil {
		log.Fatalf("error running Lua: %w", err)
	}

	lua.Close()

	fmt.Println("Lua done")
}
