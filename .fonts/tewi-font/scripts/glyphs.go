package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/mattn/go-runewidth"
)

func errh(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "glyphs: %s\n", err)
		os.Exit(1)
	}
}

func main() {
	flag.Parse()
	for _, p := range flag.Args() {
		f, err := os.Open(p)
		errh(err)
		s := bufio.NewScanner(f)
		i := 0
		for s.Scan() {
			l := s.Text()
			if !strings.HasPrefix(l, "ENCODING ") {
				continue
			}
			u, err := strconv.ParseUint(strings.TrimPrefix(l, "ENCODING "), 10, 64)
			errh(err)
			if i >= 40 {
				fmt.Println()
				i = 0
			}
			for i := 0; i < 2 - runewidth.RuneWidth(rune(u)); i++ {
				fmt.Print(" ")
			}
			fmt.Printf("%c", rune(u))
			i++
		}
		fmt.Println()
		errh(s.Err())
	}
}
