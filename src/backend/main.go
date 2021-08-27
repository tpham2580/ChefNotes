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
	Id             string        `json:"id"`
	Name           string        `json:"name"`
	Author         string        `json:"author"`
	Date_Published time.Time     `json:"date_published"`
	Description    string        `json:"description"`
	Prep_Time      string        `json:"prep_time"`
	Cook_Time      string        `json:"cook_time"`
	Cuisine        string        `json:"cuisine"`
	Course_Type    string        `json:"course_type"`
	Servings       int           `json:"servings"`
	Ingredients    []Ingredient  `json:"ingredient_list"`
	Instructions   []Instruction `json:"instruction_list"`
}

type Ingredient struct {
	Name   string `json:"name"`
	Amount string `json:"amount"`
	Unit   string `json:"unit"`
}

type Instruction struct {
	Step        int    `json:"step"`
	Instruction string `json:"instruction"`
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
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(recipes)
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
	err = db.Query(`SELECT "recipe"."recipeID", "recipe"."recipeName", "author"."username", "recipe"."datePublished", "recipe"."description", "recipe"."prepTime", "recipe"."cookTime", "cuisine"."country", "cuisine"."name" as "cuisine_name", "courseType"."name" as "course_name", "recipe"."servings"
	FROM "recipe"
		INNER JOIN "author" ON "recipe"."authorID" = "author"."authorID"
		INNER JOIN "cuisine" ON "recipe"."cuisineID" = "cuisine"."cuisineID"
		INNER JOIN "courseType" ON "recipe"."courseID" = "courseType"."courseID"
	WHERE "author"."username" = 'tp96';`).Rows(&recipes)
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
