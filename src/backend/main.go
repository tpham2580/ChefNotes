package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/eaigner/jet"
	"github.com/joho/godotenv"
	"github.com/lib/pq"
	//"github.com/gorilla/mux"
)

var Recipe []*struct {
	Id             string
	Name           string
	Author         string
	Date_Published time.Time
	Description    string
	Cuisine        string
	Course_Type    string
	Instructions   []Instruction
}

type Instruction struct {
	Step int
}

var courseType []*struct {
	Id   int
	Name string
}

func logFatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
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

	err = db.Query(`SELECT * FROM "public"."courseType"`).Rows(&courseType)
	logFatal(err)
	for _, course := range courseType {
		log.Printf("Name: %s", course.Name)
	}
}
