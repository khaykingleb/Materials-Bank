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

// Launches the Walk function in a new goroutine
func Walker(tree *tree.Tree, channel chan int) {
	Walk(tree, channel)
	defer close(channel) // close channel after Walk() finishes
}

// Determines whether the trees
// t1 and t2 contain the same values.
func Same(tree_1, tree_2 *tree.Tree) bool {
	// define separate channels for both trees
	channel_1 := make(chan int)
	channel_2 := make(chan int)

	// call the Walking func for both trees
	go Walker(tree_1, channel_1)
	go Walker(tree_2, channel_2)

	// receive from channel x and y
	for {
		value_tree_1, ok_1 := <-channel_1 // the ok param tells us if channel is closed
		value_tree_2, ok_2 := <-channel_2

		if ok_1 != ok_2 || value_tree_1 != value_tree_2 {
			return false
		}
		if !ok_1 {
			break
		}
	}

	return true
}

func main() {
	tree_1 := tree.New(1)
	tree_2 := tree.New(1)
	fmt.Println(tree_1, tree_2)
	if Same(tree_1, tree_2) {
		fmt.Print("Yes!")
	} else {
		fmt.Print("No!")
	}
}
