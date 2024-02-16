package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB
var err error

type Message struct {
	ID            string
	Body          string
	ChatID        string
	MessageNumber string
}

func connectToDb() {
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	dbname := os.Getenv("DB_NAME")

	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", user, password, host, port, dbname)
	// Get a database handle.
	db, err = sql.Open("mysql", connectionString)
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected!")
}

func addMessage(m Message) (int64, error) {
	t := time.Now()
	result, err := db.Exec("INSERT INTO messages (chat_id, body, number, created_at, updated_at) VALUES (?, ?, ?, ?, ?)", m.ChatID, m.Body, m.MessageNumber, t, t)
	if err != nil {
		return 0, fmt.Errorf("addMessage: %v", err)
	}
	id, err := result.LastInsertId()
	if err != nil {
		return 0, fmt.Errorf("addMessage: %v", err)
	}
	return id, nil
}
