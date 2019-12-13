package main

import (
	"context"
	"encoding/base64"
	"fmt"

	"github.com/golang/protobuf/proto"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/cloudiot/v1"

	cpb "github.com/bamnet/village/proto"
)

const (
	projectID  = "village"
	region     = "us-central1"
	registryID = "registry"
	deviceID   = "esp32-1"
)

var ciot *cloudiot.Service
var path string

func init() {
	ctx := context.Background()
	httpClient, err := google.DefaultClient(ctx, cloudiot.CloudPlatformScope)
	if err != nil {
		fmt.Errorf("API Client error: %v", err)
	}
	ciot, err = cloudiot.New(httpClient)
	if err != nil {
		fmt.Errorf("cloudiot init error: %v", err)
	}

	path = fmt.Sprintf("projects/%s/locations/%s/registries/%s/devices/%s", projectID, region, registryID, deviceID)
}

func updateConfig(c *cpb.Config) error {
	data, err := proto.Marshal(c)
	if err != nil {
		return err
	}
	req := cloudiot.ModifyCloudToDeviceConfigRequest{
		BinaryData: base64.StdEncoding.EncodeToString(data),
	}

	_, err = ciot.Projects.Locations.Registries.Devices.ModifyCloudToDeviceConfig(path, &req).Do()
	return err
}

func changeAllLights(red, white int) {
	for i := range cpb.House_name {
		changeLight(cpb.House(i), red, white)
	}
}

func changeLight(house cpb.House, red, white int) error {
	command := &cpb.ChangeLight{
		House: house,
		Red:   uint32(red),
		White: uint32(white),
	}

	data, err := proto.Marshal(command)
	if err != nil {
		return err
	}

	req := cloudiot.SendCommandToDeviceRequest{
		BinaryData: base64.StdEncoding.EncodeToString(data),
		Subfolder:  "changeLight",
	}

	_, err = ciot.Projects.Locations.Registries.Devices.SendCommandToDevice(path, &req).Do()
	return err
}

func main() {
	/*
		config := &cpb.Config{
			HousePins: map[uint32]cpb.House{
				// Using pin 0 causes nanopb decoding problems.
				2:  cpb.House_SPICE_MARKET,
				4:  cpb.House_FELLOWSHIP_PORTERS,
				6:  cpb.House_MARIONETTES,
				8:  cpb.House_VICTORIA_STATION,
				10: cpb.House_BUTCHER,
				12: cpb.House_CUROSITY_SHOP,
				14: cpb.House_FEZZIWIG_WAREHOUSE,
				16: cpb.House_CROOKED_FENCE_COTTAGE,
				18: cpb.House_FEZZIWIG_WAREHOUSE_2,
				20: cpb.House_TEA_SHOPPE,
			},
		}
		updateConfig(config)
	*/

	changeAllLights(40, 40)

	/*
		changeLight(cpb.House_BUTCHER, 10, 10)
		changeLight(cpb.House_SPICE_MARKET, 100, 100)
		changeLight(cpb.House_VICTORIA_STATION, 50, 10)
	*/
}
