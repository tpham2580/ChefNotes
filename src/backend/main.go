package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	"github.com/lib/pq"
)

// declaring db as global
var db *sql.DB

type Recipe struct {
	Id             int            `json:"id"`
	Name           string         `json:"name"`
	Author         sql.NullString `json:"author"`
	Date_Published time.Time      `json:"date_published"`
	Description    sql.NullString `json:"description"`
	Prep_Time      sql.NullString `json:"prep_time"`
	Cook_Time      sql.NullString `json:"cook_time"`
	Cuisine        sql.NullString `json:"cuisine"`
	Course_Type    sql.NullString `json:"course_type"`
	Servings       sql.NullInt32  `json:"servings"`
	Ingredients    []Ingredient   `json:"ingredient_list"`
	Instructions   []Instruction  `json:"instruction_list"`
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

type courseType struct {
	Id   int
	Name string
}

//var recipes []Recipe

func logFatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func getRecipes(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	//json.NewEncoder(w).Encode(recipes)
}

func getRecipe(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	//json.NewEncoder(w).Encode(recipes)
}

func addRecipe(w http.ResponseWriter, r *http.Request) {

}

func updateRecipe(w http.ResponseWriter, r *http.Request) {

}

func deleteRecipe(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	//params := mux.Vars(r)
	rows, err := db.Query(`SELECT "recipe"."recipeID", "recipe"."recipeName", "author"."username", "recipe"."datePublished", "recipe"."description", "recipe"."prepTime", "recipe"."cookTime", "cuisine"."name" as "cuisine_name", "courseType"."name" as "course_name", "recipe"."servings"
	FROM "recipe"
		INNER JOIN "author" ON "recipe"."authorID" = "author"."authorID"
		INNER JOIN "cuisine" ON "recipe"."cuisineID" = "cuisine"."cuisineID"
		INNER JOIN "courseType" ON "recipe"."courseID" = "courseType"."courseID"
	WHERE "author"."username" = 'tp96';`)

	logFatal(err)
	defer rows.Close()

	recipes := make([]Recipe, 0)

	for rows.Next() {
		recipe := Recipe{}
		err := rows.Scan(&recipe.Id, &recipe.Name, &recipe.Author, &recipe.Date_Published, &recipe.Description, &recipe.Prep_Time, &recipe.Cook_Time, &recipe.Cuisine, &recipe.Course_Type, &recipe.Servings)
		logFatal(err)
		recipes = append(recipes, recipe)
	}

	for _, recipe := range recipes {
		fmt.Printf("Recipe Name: %s\nAuthor: %s\nDate Published: %s\nDescription: %s\nCuisine: %s\nCourse Type: %s\n", recipe.Name, recipe.Author, recipe.Date_Published.String(), recipe.Description, recipe.Cuisine, recipe.Course_Type)
	}
}

func main() {
	// starting connection with elephantsql
	err := godotenv.Load()
	logFatal(err)
	pgUrl, err := pq.ParseURL(os.Getenv("URL"))
	fmt.Println(pgUrl)
	logFatal(err)
	db, err := sql.Open("postgres", pgUrl)
	logFatal(err)

	// use db.Query to prevent SQL injection attacks
	// db.Query("SELECT name FROM users WHERE age=?", req.FormValue("age")) as an example.
	// include the ? symbol
	rows, err := db.Query(`SELECT "recipe"."recipeID", "recipe"."recipeName", "author"."username", "recipe"."datePublished", "recipe"."description", "recipe"."prepTime", "recipe"."cookTime", "cuisine"."name" as "cuisine_name", "courseType"."name" as "course_name", "recipe"."servings"
	FROM "recipe"
		INNER JOIN "author" ON "recipe"."authorID" = "author"."authorID"
		INNER JOIN "cuisine" ON "recipe"."cuisineID" = "cuisine"."cuisineID"
		INNER JOIN "courseType" ON "recipe"."courseID" = "courseType"."courseID"
	WHERE "author"."username" = 'tp96';`)

	logFatal(err)
	defer rows.Close()

	recipes := make([]Recipe, 0)

	for rows.Next() {
		recipe := Recipe{}
		err := rows.Scan(&recipe.Id, &recipe.Name, &recipe.Author, &recipe.Date_Published, &recipe.Description, &recipe.Prep_Time, &recipe.Cook_Time, &recipe.Cuisine, &recipe.Course_Type, &recipe.Servings)
		logFatal(err)
		recipes = append(recipes, recipe)
	}

	for _, recipe := range recipes {
		fmt.Printf("Recipe Name: %s\nAuthor: %s\nDate Published: %s\nDescription: %s\nCuisine: %s\nCourse Type: %s\n", recipe.Name, recipe.Author, recipe.Date_Published.String(), recipe.Description, recipe.Cuisine, recipe.Course_Type)
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
