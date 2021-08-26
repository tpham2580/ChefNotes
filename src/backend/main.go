package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/eaigner/jet"
	"github.com/joho/godotenv"
	"github.com/lib/pq"
	"gorm.io/gorm"
	//"github.com/gorilla/mux"
)

type Recipe struct {
	gorm.Model

	Name           string
	Author         string
	Date_Published time.Time
	Description    string
	Cuisine        string
	Course_Type    string
	Instructions   []Instruction
}

type Instruction struct {
	gorm.Model

	Step int
}

func logFatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func main() {
	err := godotenv.Load()
	logFatal(err)
	// Make sure you setup the ELEPHANTSQL_URL to be a uri, e.g. 'postgres://user:pass@host/db?options'
	pgUrl, err := pq.ParseURL(os.Getenv("URL"))
	fmt.Println(pgUrl)
	logFatal(err)
	db, err := jet.Open("postgres", pgUrl)
	logFatal(err)
	var courseType []*struct {
		Id   int
		Name string
	}
	err = db.Query(`SELECT * FROM "public"."courseType"`).Rows(&courseType)
	logFatal(err)
	for _, course := range courseType {
		log.Printf("Name: %s", course.Name)
	}
}
