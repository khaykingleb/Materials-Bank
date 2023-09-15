// https://medium.com/@basakabhijoy/solving-the-equivalent-binary-trees-exercise-in-go-92254cacfb76

package main

import (
	"fmt"

	"golang.org/x/tour/tree"
)

// Walks the tree sending all values
// from the tree to the channel.
func Walk(tree *tree.Tree, channel chan int) {
	if tree != nil {
		Walk(tree.Left, channel)
		channel <- tree.Value
		Walk(tree.Right, channel)
	}
}

// Launches the Walk function in a new goroutine.
func Walker(tree *tree.Tree, channel chan int) {
	Walk(tree, channel)
	defer close(channel) // close channel after Walk() finishes
}

// Determines whether the trees
// t1 and t2 contain the same values.
func Same(tree1, tree2 *tree.Tree) bool {
	// define separate channels for both trees
	channel1 := make(chan int)
	channel2 := make(chan int)

	// call the Walking func for both trees
	go Walker(tree1, channel1)
	go Walker(tree2, channel2)

	// receive from channel x and y
	for {
		valueTree1, ok1 := <-channel1 // the ok param tells us if channel is closed
		valueTree2, ok2 := <-channel2

		if ok1 != ok2 || valueTree1 != valueTree2 {
			return false
		}

		if !ok1 {
			break
		}
	}

	return true
}

func main() {
	tree1 := tree.New(1)
	tree2 := tree.New(1)
	fmt.Println(tree1, tree2)

	if Same(tree1, tree2) {
		fmt.Print("Yes!")
	} else {
		fmt.Print("No!")
	}
}
