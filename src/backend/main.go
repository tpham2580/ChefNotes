package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/eaigner/jet"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/lib/pq"
)

var Recipe struct {
	Id             string
	Name           string
	Author         string
	Date_Published time.Time
	Description    string
	Prep_Time      string
	Cook_Time      string
	Cuisine        string
	Course_Type    string
	Servings       int
	Ingredients    []Ingredient
	Instructions   []Instruction
}

type Ingredient struct {
	Name   string
	Amount string
	Unit   string
}

type Instruction struct {
	Step        int
	Instruction string
}

var courseType []*struct {
	Id   int
	Name string
}

var recipes []Recipe

func logFatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func getRecipes(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(recipes)
}

func getRecipe(w http.ResponseWriter, r *http.Request) {

}

func addRecipe(w http.ResponseWriter, r *http.Request) {

}

func updateRecipe(w http.ResponseWriter, r *http.Request) {

}

func deleteRecipe(w http.ResponseWriter, r *http.Request) {

}

func main() {
	// starting connection with elephantsql
	err := godotenv.Load()
	logFatal(err)
	pgUrl, err := pq.ParseURL(os.Getenv("URL"))
	fmt.Println(pgUrl)
	logFatal(err)
	db, err := jet.Open("postgres", pgUrl)
	logFatal(err)

	// use db.Query to prevent SQL injection attacks
	// db.Query("SELECT name FROM users WHERE age=?", req.FormValue("age")) as an example.
	// include the ? symbol
	err = db.Query(`SELECT * FROM "public"."courseType"`).Rows(&courseType)
	logFatal(err)
	for _, course := range courseType {
		log.Printf("Name: %s", course.Name)
	}

	// routing
	r := mux.NewRouter()

	// READ (GET)
	r.HandleFunc("/recipe", getRecipes).Methods("GET")
	r.HandleFunc("/recipe/{id}", getRecipe).Methods("GET")

	// CREATE (POST)
	r.HandleFunc("/recipe", addRecipe).Methods("POST")

	// UPDATE (PUT)
	r.HandleFunc("/recipe/{id}", updateRecipe).Methods("PUT")

	// DELETE
	r.HandleFunc("/recipe/{id}", deleteRecipe).Methods("GET")
}
