package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"sync"
	"time"
)

const (
	MaxBrightness = 0.50 * 4096 // 4095 is the max step for a TLC5940.
)

var (
	host      = flag.String("host", "", "IP / hostname of the village controller")
	startHour = flag.Int("start", 18, "Hour the show should start")
	length    = flag.Int("hours", 9, "Duration of the show, in hours")
)

// Event represents a scheduled state change for a light.
type Event struct {
	ID         int
	Brightness int
	Time       time.Time
}

func init() {
	rand.Seed(time.Now().UTC().UnixNano())
}

func main() {
	flag.Parse()

	nyc, err := time.LoadLocation("America/New_York")
	if err != nil {
		log.Fatalf("Error loading timezone data: %v", err)
	}

	now := time.Now().In(nyc)
	start := time.Date(now.Year(), now.Month(), now.Day(), *startHour, 0, 0, 0, nyc)
	end := start.Add(time.Duration(*length) * time.Hour)

	// If we are currently in a showtime, rewind time so we can restart.
	then := now.Add(24 * time.Hour)
	if then.After(start) && end.After(then) {
		start = start.Add(-24 * time.Hour)
		end = end.Add(-24 * time.Hour)
	}

	log.Printf("Start time: %v", start)
	log.Printf("End time: %v", end)

	schedule := []Event{}
	for i := 1; i <= 9; i++ {
		schedule = append(schedule, planSchedule(i, start, end)...)
	}

	wg := sync.WaitGroup{}
	wg.Add(len(schedule))
	for i, e := range schedule {
		wait := e.Time.Sub(time.Now())
		if wait < 0 {
			// If the event was already suppose to occur, the program
			// must be starting mid-schedule, To accomodate that we
			// schedule the events immediately and try to preserve order.
			wait = time.Duration(i) * time.Second
		}
		t := time.NewTimer(wait)
		go func(id, b int) {
			defer wg.Done()
			<-t.C
			setLight(id, b)
		}(e.ID, e.Brightness)
	}
	wg.Wait()
}

// setLight immediately changes the brightness of a light.
// brightness should be [0, 100].
func setLight(id, brightness int) error {
	log.Printf("Setting %d to %d", id, brightness)
	b := MaxBrightness * brightness / 100.0
	url := fmt.Sprintf("http://%s/console/send?text=%d%%2C%d%%0A", *host, id, b)
	_, err := http.Get(url)
	return err
}

// planSchedule determines what events a light should have during the show.
func planSchedule(id int, start, end time.Time) []Event {
	changes := 2 + rand.Intn(4) // Between 2 and 5 events.
	events := make([]Event, changes)

	// Everything turns on within 15 minutes of show open.
	on := start.Add(time.Duration(rand.Intn(15)) * time.Minute)
	events[0] = Event{id, 100, on}

	// Everything turns off in the last 2 hours.
	off := end.Add(-1 * time.Duration(rand.Intn(120)) * time.Minute)
	events[len(events)-1] = Event{id, 5, off}

	// Generate random events to fill in the rest of the gaps.
	for i := 1; i < len(events)-1; i++ {
		gap := int(off.Sub(on).Minutes())
		t := start.Add(time.Duration(rand.Intn(gap)) * time.Minute)
		b := 5 + rand.Intn(70)
		events[i] = Event{id, b, t}
	}

	return events
}
