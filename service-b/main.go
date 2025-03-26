package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello from Service B!")
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Service B running on port 8080...")
	http.ListenAndServe(":8080", nil)
}
