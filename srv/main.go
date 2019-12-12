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

func main() {
	/*
		c := &cpb.Config{
			HousePins: map[uint32]cpb.House{
				1: cpb.House_BUTCHER,
				2: cpb.House_CROOKED_FENCE_COTTAGE,
				3: cpb.House_FEZZIWIG_WAREHOUSE_2,
			},
		}*/
	c := &cpb.ChangeLight{
		House: cpb.House_CUROSITY_SHOP,
		Red:   5,
		White: 5,
	}
	data, _ := proto.Marshal(c)
	if _, err := sendCommand("village", "us-central1", "registry", "esp32-1", data); err != nil {
		fmt.Printf("Error: %v", err)
	}
	fmt.Printf("%s", data)
}

func sendCommand(projectID string, region string, registryID string, deviceID string, data []byte) (*cloudiot.SendCommandToDeviceResponse, error) {
	// Authorize the client using Application Default Credentials.
	// See https://g.co/dv/identity/protocols/application-default-credentials
	ctx := context.Background()
	httpClient, err := google.DefaultClient(ctx, cloudiot.CloudPlatformScope)
	if err != nil {
		return nil, err
	}
	client, err := cloudiot.New(httpClient)
	if err != nil {
		return nil, err
	}

	/*
		req := cloudiot.ModifyCloudToDeviceConfigRequest{
			BinaryData: base64.StdEncoding.EncodeToString(data),
		}

		name := fmt.Sprintf("projects/%s/locations/%s/registries/%s/devices/%s", projectID, region, registryID, deviceID)

		_, err = client.Projects.Locations.Registries.Devices.ModifyCloudToDeviceConfig(name, &req).Do()
		if err != nil {
			return nil, err
		}

		return nil, nil
	*/

	req := cloudiot.SendCommandToDeviceRequest{
		BinaryData: base64.StdEncoding.EncodeToString(data),
		Subfolder:  "changeLight",
	}

	name := fmt.Sprintf("projects/%s/locations/%s/registries/%s/devices/%s", projectID, region, registryID, deviceID)

	response, err := client.Projects.Locations.Registries.Devices.SendCommandToDevice(name, &req).Do()
	if err != nil {
		return nil, err
	}

	fmt.Println("Sent command to device")

	return response, nil
}
