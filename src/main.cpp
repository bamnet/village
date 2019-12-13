#include <Arduino.h>
#include <Preferences.h>

#include <Adafruit_TLC5947.h>

#include <esp32-mqtt.h>

#include <pb_decode.h>
#include <commands.pb.h>

#define NUM_TLC5974 1
#define DATA_PIN 19
#define CLOCK_PIN 18
#define LATCH_PIN 5

#define UNSET_HOUSE_PIN 65535
#define RED_OFFSET 1
#define WHITE_OFFSET 0

Adafruit_TLC5947 tlc = Adafruit_TLC5947(NUM_TLC5974, CLOCK_PIN, DATA_PIN, LATCH_PIN);

uint16_t housePins[_House_ARRAYSIZE];

Preferences preferences;

void maybeSave(uint16_t pin, uint32_t pct){
  char buffer[10];
  sprintf(buffer, "pin %d", pin);
  preferences.putUInt(buffer, pct);
}

void loadSaved() {
  for (uint16_t i = 0; i <24; i++){
    char buffer[10];
    sprintf(buffer, "pin %d", i);
    uint32_t pct = preferences.getUInt(buffer);

    // Ignore out of range values.
    if(pct >=0 && pct <= 100) {
      tlc.setPWM(i, 4095*pct/100.0);
    }
  }
  tlc.write();
}


void setup() {
  Serial.begin(115200);
  preferences.begin("village", false);
  tlc.begin();
  loadSaved();
  setupCloudIoT();
}

void loop() {
  mqtt->loop();
  delay(10);  // <- fixes some issues with WiFi stability

  if (!mqttClient->connected()) {
    connect();
  }
}

bool string_to_proto(String &payload, const pb_field_t fields[], void *target) {
  const uint8_t *buffer = reinterpret_cast<const uint8_t*>(&payload[0]);
  size_t message_length = strlen(&payload[0]);

  pb_istream_t stream = pb_istream_from_buffer(buffer, message_length);

  bool status = pb_decode(&stream, fields, target);
  if(!status) {
    printf("Decoding failed: %s\n", PB_GET_ERROR(&stream));
  }
  return status;
}

bool Config_decode_house_pins(pb_istream_t *stream, const pb_field_t *field, void **arg){
  Config_HousePinsEntry hpe = Config_HousePinsEntry_init_zero;
  bool status = pb_decode(stream, Config_HousePinsEntry_fields, &hpe);
  if(!status) {
    Serial.printf("Decoding field failed: %s\n", PB_GET_ERROR(stream));
    return status;
  }

  housePins[hpe.value] = hpe.key;
  return true;
}

void messageReceived(String &topic, String &payload) {
  Serial.println("incoming: " + topic);
  
  if (topic.endsWith("/config")) {
    printf("Recieved config message");

    // Since the default array value is 0, and 0 is a valid pin
    // we use a different default and manually inject it.
    for(int i = 1; i<(sizeof(housePins)/sizeof(uint16_t)); i++){
      housePins[i] = UNSET_HOUSE_PIN;
    }

    Config config = Config_init_zero;
    config.house_pins.funcs.decode = Config_decode_house_pins;

    bool status = string_to_proto(payload, Config_fields, &config);
    if (!status) {
      return;
    }

    for(int i = 1; i<(sizeof(housePins)/sizeof(uint16_t)); i++){
      Serial.printf("House %d @ pin %d\n", i, housePins[i]);
    }

    return;
  } else if (topic.endsWith("/changeLight")){
    ChangeLight change = ChangeLight_init_zero;
    bool status = string_to_proto(payload, ChangeLight_fields, &change);
    if(!status) {
      return;
    }

    uint16_t pin = housePins[change.house];
    if (pin == UNSET_HOUSE_PIN) {
      Serial.printf("No pin configured for house %d", change.house);
      return;
    }

    tlc.setPWM(pin + WHITE_OFFSET, 4095*change.white/100.0);
    tlc.setPWM(pin + RED_OFFSET, 4095*change.red/100.0);
    tlc.write();

    maybeSave(pin + WHITE_OFFSET, change.white);
    maybeSave(pin + RED_OFFSET, change.red);
  }
}