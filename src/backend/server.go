package main

import (
	//"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	//_ "github.com/lib/pq"
)

func main() {
	router := mux.NewRouter()
	const port string = ":8000"
	router.HandleFunc("/", func(response http.ResponseWriter, request *http.Request) {
		fmt.Fprintln(response, "Up and running...")
	})
	log.Println("Server listening on port", port)
	log.Fatalln(http.ListenAndServe(port, router))
}
