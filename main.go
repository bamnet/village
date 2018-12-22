package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"time"
)

const (
	MaxBrightness = 0.50 * 4096 // 4095 is the max step for a TLC5940.
)

var (
	host = flag.String("host", "", "IP / hostname of the village controller")
)

func init() {
	rand.Seed(time.Now().UTC().UnixNano())
}

func main() {
	flag.Parse()

	for {
		id := rand.Intn(9) + 1
		b := rand.Intn(100)
		if err := setLight(id, b); err != nil {
			log.Fatalf("HTTP error: %v", err)
		}
		time.Sleep(time.Duration(rand.Int63n(150)) * time.Millisecond)
	}
}

// setLight immediately changes the brightness of a light.
// brightness should be [0, 100].
func setLight(id, brightness int) error {
	b := MaxBrightness * brightness / 100.0
	url := fmt.Sprintf("http://%s/console/send?text=%d%%2C%d%%0A", *host, id, b)
	_, err := http.Get(url)
	return err
}
