package main

//"encoding/json"
//"net/http"

type Post struct {
	Id    int    `json:"id"`
	Title string `json:"title"`
	Text  string `json:"text"`
}

var (
	posts []Post
)

func init() {
	posts = []Post{{Id: 1, Title: "Title 1", Text: "Text 1"}}
}

func getPosts() {

}
