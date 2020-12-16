package main

import (
	"flag"
	"log"
	"math/rand"
	"sync"
	"time"

	"github.com/bamnet/village/srv/village"

	cpb "github.com/bamnet/village/proto"
)

var (
	projectID  = flag.String("project_id", "village", "Cloud Project ID")
	iotRegion  = flag.String("region", "us-central1", "Cloud IOT region")
	registryID = flag.String("registry_id", "registry", "Cloud IOT registry ID")
	deviceID   = flag.String("device_id", "esp32-1", "Cloud IOT device ID")
	startHour  = flag.Int("start", 18, "Hour the show should start")
	length     = flag.Int("hours", 9, "Duration of the show, in hours")
)

// Event represents a scheduled state change for a light.
type Event struct {
	House      cpb.House
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

	client, _ := village.New(*projectID, *iotRegion, *registryID, *deviceID)

	/*
		if err := client.UpdateConfig(&cpb.Config{
			HousePins: map[uint32]cpb.House{
				0: cpb.House_VICTORIA_STATION,
				/*2:  cpb.House_MARIONETTES,
				4:  cpb.House_BAKERY,
				6:  cpb.House_FEZZIWIG_WAREHOUSE,
				8:  cpb.House_FEZZIWIG_WAREHOUSE_2,
				10: cpb.House_TEA_SHOPPE,
				12: cpb.House_BUTCHER,
				14: cpb.House_CUROSITY_SHOP,
				16: cpb.House_SPICE_MARKET,
				18: cpb.House_FELLOWSHIP_PORTERS,
				20: cpb.House_CROOKED_FENCE_COTTAGE,
			},
		}); err != nil {
			log.Fatalf("Error updating config: %v", err)
		}
	*/
	// client.ChangeAllLights(0, 0)
	//client.ChangeLight(cpb.House_VICTORIA_STATION, 100, 100)

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
	for n := range cpb.House_name {
		h := cpb.House(n)
		if h == cpb.House_UNKNOWN_HOUSE {
			continue
		}
		schedule = append(schedule, planSchedule(h, start, end)...)
	}

	wg := sync.WaitGroup{}

	// Add 1 noop event that runs until the end of the show
	wg.Add(1)
	endTimer := time.NewTimer(end.Sub(time.Now()))
	go func() {
		defer wg.Done()
		<-endTimer.C
		log.Printf("Fin.")
	}()

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
		go func(house cpb.House, b int) {
			defer wg.Done()
			<-t.C
			log.Printf("%s - %d", house, b)
			if err := client.ChangeLight(house, b, b); err != nil {
				log.Printf("ChangeLight error: %v", err)
			}
		}(e.House, e.Brightness)
	}
	wg.Wait()
}

// planSchedule determines what events a light should have during the show.
func planSchedule(house cpb.House, start, end time.Time) []Event {
	changes := 2 + rand.Intn(4) // Between 2 and 5 events.
	events := make([]Event, changes)

	// Everything turns on within 15 minutes of show open.
	on := start.Add(time.Duration(rand.Intn(15)) * time.Minute)
	events[0] = Event{house, 100, on}

	// Everything turns off in the last 2 hours.
	off := end.Add(-1 * time.Duration(rand.Intn(120)) * time.Minute)
	events[len(events)-1] = Event{house, 1, off}

	// Generate random events to fill in the rest of the gaps.
	for i := 1; i < len(events)-1; i++ {
		gap := int(off.Sub(on).Minutes())
		t := start.Add(time.Duration(rand.Intn(gap)) * time.Minute)
		b := 5 + rand.Intn(70)
		events[i] = Event{house, b, t}
	}

	return events
}
