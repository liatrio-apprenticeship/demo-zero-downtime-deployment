package main

import (
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"
)

var ready time.Time

func handleRoot(response http.ResponseWriter, request *http.Request) {
	io.WriteString(response, fmt.Sprintf("\nI'm deployed - Version %s", os.Getenv("VERSION")))
}

func handleHealth(response http.ResponseWriter, request *http.Request) {
	if time.Now().After(ready) {
		response.WriteHeader(http.StatusOK)
		io.WriteString(response, "Ready")
	} else {
		response.WriteHeader(http.StatusServiceUnavailable)
		io.WriteString(response, "Warming Up")
	}
}

func main() {
	http.HandleFunc("/", handleRoot)
	http.HandleFunc("/healthz", handleHealth)

	fmt.Println("Starting server on port 8080")
	ready = time.Now().Add(15 * time.Second)
	err := http.ListenAndServe(":8080", nil)
	if errors.Is(err, http.ErrServerClosed) {
		fmt.Println("Server stopped normally")
	} else {
		fmt.Printf("Server error %s\n", err)
	}
}
