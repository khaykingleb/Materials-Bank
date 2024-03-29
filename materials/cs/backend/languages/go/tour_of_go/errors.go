package main

import (
	"fmt"
	"math"
)

type NegativeSqrtError float64

func (e NegativeSqrtError) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %.f", float64(e))
}

func Sqrt(x float64) (float64, error) {
	if x < 0 {
		return x, NegativeSqrtError(x)
	}

	return math.Sqrt(x), nil
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(-2))
}
