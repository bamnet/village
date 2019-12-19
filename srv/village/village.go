package village

import (
	"context"
	"encoding/base64"
	"fmt"

	"github.com/golang/protobuf/proto"
	"golang.org/x/oauth2/google"
	"google.golang.org/api/cloudiot/v1"

	cpb "github.com/bamnet/village/proto"
)

const devicePath = "projects/%s/locations/%s/registries/%s/devices/%s"

// Client manages the Cloud IOT device running the village.
type Client struct {
	path string
	ciot *cloudiot.Service
}

// New creates a new connection Cloud IOT.
func New(projectID, region, registryID, deviceID string) (*Client, error) {
	ctx := context.Background()
	httpClient, err := google.DefaultClient(ctx, cloudiot.CloudPlatformScope)
	if err != nil {
		return nil, err
	}
	ciot, err := cloudiot.New(httpClient)
	if err != nil {
		return nil, err
	}

	return &Client{
		ciot: ciot,
		path: fmt.Sprintf(devicePath, projectID, region, registryID, deviceID),
	}, nil
}

// UpdateConfig updates a config.
func (c *Client) UpdateConfig(config *cpb.Config) error {
	data, err := proto.Marshal(config)
	if err != nil {
		return err
	}
	req := cloudiot.ModifyCloudToDeviceConfigRequest{
		BinaryData: base64.StdEncoding.EncodeToString(data),
	}

	_, err = c.ciot.Projects.Locations.Registries.Devices.ModifyCloudToDeviceConfig(c.path, &req).Do()
	return err
}

// ChangeAllLights sets all lights to the same value.
func (c *Client) ChangeAllLights(red, white int) {
	for i := range cpb.House_name {
		c.ChangeLight(cpb.House(i), red, white)
	}
}

// ChangeLight changes the brightness of a single house's light.
// Set red and white to a value between 0 - 100.
func (c *Client) ChangeLight(house cpb.House, red, white int) error {
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

	_, err = c.ciot.Projects.Locations.Registries.Devices.SendCommandToDevice(c.path, &req).Do()
	return err
}
