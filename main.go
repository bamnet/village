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
	host = flag.String("host", "", "IP / hostname of the village controller")
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

	schedule := []Event{
		{1, 100, time.Now().Add(1 * time.Second)},
		{1, 25, time.Now().Add(2 * time.Second)},
	}

	wg := sync.WaitGroup{}
	wg.Add(len(schedule))
	for _, e := range schedule {
		wait := e.Time.Sub(time.Now())
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
