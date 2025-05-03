package main

import (
  "fmt"
  "net/http"
)

func main() {
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "OK")
  })

  fmt.Println("Health check running on :8080")
  err := http.ListenAndServe(":8080", nil)
    if err != nil {
        fmt.Println("Failed to start health server:", err)
    }
}
