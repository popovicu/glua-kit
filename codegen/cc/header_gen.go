package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

func main() {
	luaInputFile := flag.String("lua_input_file", "", "Path to the Lua input file")
	headerGuardName := flag.String("header_guard_name", "", "Name for the header guard (e.g., FOO_H_)")
	outputFilePath := flag.String("output_file_path", "", "Path to the output .h file")
	symbolName := flag.String("symbol_name", "", "Symbol name for the Lua content string in the header")

	flag.Parse()

	if *luaInputFile == "" || *headerGuardName == "" || *outputFilePath == "" || *symbolName == "" {
		flag.Usage()
		os.Exit(1)
	}

	luaContent, err := os.ReadFile(*luaInputFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading Lua input file %s: %v\n", *luaInputFile, err)
		os.Exit(1)
	}

	escapedLuaContent := escapeForCString(string(luaContent))

	headerContent := fmt.Sprintf(`#ifndef %s
#define %s

const char* %s =
"%s";

#endif // %s
`, *headerGuardName, *headerGuardName, *symbolName, escapedLuaContent, *headerGuardName)

	err = os.WriteFile(*outputFilePath, []byte(headerContent), 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error writing output file %s: %v\n", *outputFilePath, err)
		os.Exit(1)
	}

	fmt.Printf("Successfully generated header file: %s\n", *outputFilePath)
}

func escapeForCString(s string) string {
	s = strings.ReplaceAll(s, `\`, `\\`)  // Escape backslashes first
	s = strings.ReplaceAll(s, `"`, `\"`)  // Escape double quotes
	s = strings.ReplaceAll(s, "\n", `\n`) // Replace newlines with \n
	s = strings.ReplaceAll(s, "\t", `\t`) // Escape tabs
	s = strings.ReplaceAll(s, "\r", `\r`) // Escape carriage returns
	// Add more escapes as needed for other special characters
	return s
}
