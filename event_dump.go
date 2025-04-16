package main

import (
	"fmt"
	"log"
	"os"

	demoinfocs "github.com/markus-wa/demoinfocs-golang/v4/pkg/demoinfocs"
	"github.com/markus-wa/demoinfocs-golang/v4/pkg/demoinfocs/events"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("Usage: event_dump <demo-file>")
	}
	demoPath := os.Args[1]

	f, err := os.Open(demoPath)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	p := demoinfocs.NewParser(f)

	// --- Hook major events ---
	p.RegisterEventHandler(func(e events.RoundStart) {
		fmt.Println("ROUND START: Round", p.GameState().TotalRoundsPlayed()+1)
	})

	p.RegisterEventHandler(func(e events.RoundEnd) {
		fmt.Println("ROUND END: Winner team", e.Winner, " Reason:", e.Reason)
	})

	p.RegisterEventHandler(func(e events.RoundEndOfficial) {
		fmt.Println("ROUND END OFFICIAL")
	})

	p.RegisterEventHandler(func(e events.PlayerDisconnected) {
		fmt.Println("PLAYER DISCONNECTED:", e.Player.Name)
	})

	p.RegisterEventHandler(func(e events.MatchStartedChanged) {
		fmt.Println("MATCH STARTED CHANGED:")
	})

	// Parse to end
	err = p.ParseToEnd()
	if err != nil {
		log.Fatal(err)
	}
}