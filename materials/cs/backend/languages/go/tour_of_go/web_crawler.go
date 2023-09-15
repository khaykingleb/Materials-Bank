package main

import (
	"fmt"
	"sync"
)

type Fetcher interface {
	// Fetch returns the body of URL and
	// a slice of URLs found on that page.
	Fetch(url string) (body string, urls []string, err error)
}

type urlChecker struct {
	mutex   sync.Mutex
	visited map[string]bool
}

func (checker *urlChecker) Set(url string) {
	checker.mutex.Lock()
	checker.visited[url] = true
	checker.mutex.Unlock()
}

func (checker *urlChecker) Get(url string) bool {
	checker.mutex.Lock()
	defer checker.mutex.Unlock()

	_, ok := checker.visited[url]

	return ok
}

// Crawl uses fetcher to recursively crawl
// pages starting with url, to a maximum of depth.
func Crawl(url string, depth int, fetcher Fetcher, checker urlChecker, wg *sync.WaitGroup) {
	defer wg.Done()

	if depth <= 0 {
		return
	}

	checker.Set(url)

	body, urls, err := fetcher.Fetch(url)
	if err != nil {
		fmt.Println(err)

		return
	}

	fmt.Printf("found: %s %q\n", url, body)

	for _, url := range urls {
		doesExist := checker.Get(url)
		if !doesExist {
			wg.Add(1)

			go Crawl(url, depth-1, fetcher, checker, wg)
		}
	}
}

func main() {
	var wg sync.WaitGroup

	wg.Add(1)

	checker := urlChecker{visited: make(map[string]bool)}
	Crawl("https://golang.org/", 4, fetcher, checker, &wg)

	wg.Wait()
}

// fakeFetcher is Fetcher that returns canned results.
type fakeFetcher map[string]*fakeResult

type fakeResult struct {
	body string
	urls []string
}

func (f fakeFetcher) Fetch(url string) (string, []string, error) {
	if res, ok := f[url]; ok {
		return res.body, res.urls, nil
	}

	return "", nil, fmt.Errorf("not found: %s", url)
}

// fetcher is a populated fakeFetcher.
var fetcher = fakeFetcher{
	"https://golang.org/": &fakeResult{
		"The Go Programming Language",
		[]string{
			"https://golang.org/pkg/",
			"https://golang.org/cmd/",
		},
	},
	"https://golang.org/pkg/": &fakeResult{
		"Packages",
		[]string{
			"https://golang.org/",
			"https://golang.org/cmd/",
			"https://golang.org/pkg/fmt/",
			"https://golang.org/pkg/os/",
		},
	},
	"https://golang.org/pkg/fmt/": &fakeResult{
		"Package fmt",
		[]string{
			"https://golang.org/",
			"https://golang.org/pkg/",
		},
	},
	"https://golang.org/pkg/os/": &fakeResult{
		"Package os",
		[]string{
			"https://golang.org/",
			"https://golang.org/pkg/",
		},
	},
}
