package main

import (
	"io"
	"os"
	"strings"
)

type rot13Reader struct {
	r io.Reader
}

func (r rot13Reader) Read(b []byte) (int, error) {
	n, e := r.r.Read(b)
	if e != nil {
		return 0, e
	}

	for i := range b {
		switch {
		case b[i] >= 'A' && b[i] <= 'Z':
			b[i] = ((b[i] - 'A' + 13) % 26) + 'A'
		case b[i] >= 'a' && b[i] <= 'z':
			b[i] = ((b[i] - 'a' + 13) % 26) + 'a'
		default:
		}
	}

	return n, nil
}

func main() {
	s := strings.NewReader("Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}
