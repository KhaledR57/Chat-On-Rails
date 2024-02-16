package main

import (
	"fmt"
	"log"

	"github.com/benmanns/goworker"
)

func myFunc(queue string, args ...interface{}) error {
	chatID := fmt.Sprintf("%s", args[0])
	body := fmt.Sprintf("%s", args[1])
	messageNumber := fmt.Sprintf("%s", args[2])

	fmt.Printf("From %s, %s, %s, %s\n", queue, chatID, body, messageNumber)

	mID, err := addMessage(Message{
		Body:          body,
		ChatID:        chatID,
		MessageNumber: messageNumber,
	})

	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("ID of added message: %v\n", mID)

	return nil
}

func init() {
	connectToDb()
	settings := goworker.WorkerSettings{
		URI:            "redis://redis:6379/1",
		Connections:    100,
		Queues:         []string{"goqueue", "delimited", "queues"},
		UseNumber:      true,
		ExitOnComplete: false,
		Concurrency:    2,
		Namespace:      "resque:",
		Interval:       5.0,
	}
	goworker.SetSettings(settings)
	goworker.Register("GoMessageCreationJob", myFunc)
}

func main() {
	if err := goworker.Work(); err != nil {
		fmt.Println("Error:", err)
	}
}
