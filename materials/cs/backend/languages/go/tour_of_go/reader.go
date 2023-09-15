package main

import (
	"fmt"

	"golang.org/x/tour/reader"
)

type (
	MyReader      struct{}
	MyReaderError int
)

func (e MyReaderError) Error() string {
	return fmt.Sprintf("capacity max error, cap: %d", e)
}

func (r MyReader) Read(b []byte) (int, error) {
	if cap(b) < 1 {
		return 0, MyReaderError(cap(b))
	}

	b[0] = 'A'

	return 1, nil
}

func main() {
	reader.Validate(MyReader{})
}
