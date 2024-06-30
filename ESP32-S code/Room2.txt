#include <SPI.h>
#include <Ethernet2.h>
#include <PubSubClient.h>


// Pins for buttons
const int buttonPin1 = 33; // Button for Bed 1 - Red
const int buttonPin2 = 32; // Button for Bed 1 - Yellow
const int buttonPin3 = 25; // Button for Bed 2 - Red
const int buttonPin4 = 26; // Button for Bed 2 - Yellow

// Pins for LEDs
const int greenLedPin1 = 14; // Green LED for Bed 1
const int redLedPin1 = 12;   // Red LED for Bed 1
const int greenLedPin2 = 27; // Green LED for Bed 2
const int redLedPin2 = 13;   // Red LED for Bed 2

// Network Configuration
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xEE }; // Different MAC address to avoid conflicts
IPAddress ip(192, 168, 1, 112); // IP address for Room 2
IPAddress server(192, 168, 1, 110); // MQTT broker IP

EthernetClient ethClient;
PubSubClient client(ethClient);

// State tracking for each button to prevent message flood
bool lastState1 = false, lastState2 = false, lastState3 = false, lastState4 = false;
// State tracking for LED
bool bed1ButtonPressed = false, bed2ButtonPressed = false;

void setup() {
  pinMode(buttonPin1, INPUT_PULLUP);
  pinMode(buttonPin2, INPUT_PULLUP);
  pinMode(buttonPin3, INPUT_PULLUP);
  pinMode(buttonPin4, INPUT_PULLUP);

  // Initialize LED pins
  pinMode(greenLedPin1, OUTPUT);
  pinMode(redLedPin1, OUTPUT);
  pinMode(greenLedPin2, OUTPUT);
  pinMode(redLedPin2, OUTPUT);

  // Set initial LED states
  digitalWrite(greenLedPin1, HIGH);
  digitalWrite(redLedPin1, LOW);
  digitalWrite(greenLedPin2, HIGH);
  digitalWrite(redLedPin2, LOW);
  
  Serial.begin(115200);
  Ethernet.init(5); // Configure the CS pin
  
  Ethernet.begin(mac, ip);
  
  //if (Ethernet.begin(mac) == 0) {
    //Serial.println("Failed to configure Ethernet using DHCP");
    // Try to configure using static IP
    //Ethernet.begin(mac, ip);
  //}
  
  Serial.println("Ethernet connected");
  Serial.print("My IP address: ");
  Serial.println(Ethernet.localIP());

  client.setServer(server, 1883);
  client.setCallback(callback);
  reconnect();
}

// Function to reconnect the client if it is not already connected.
void reconnect() {
  // Loop until the client is connected
  while (!client.connected()) {
    // Attempting connection message
    Serial.print("Attempting MQTT connection...");

    // Attempt to connect to the MQTT server with a specific client ID.
    // The ESP32Client2 ID ensures that each client has a unique ID
    if (client.connect("ESP32Client2")) {
      // Connection successful
      Serial.println("connected");

      // These topics allow the client to receive messages targeted at these topics from the server.
      client.subscribe("esp32/bed1/room2/reset");
      client.subscribe("esp32/bed2/room2/reset");

      // Publish initial states of the devices.
      // Retained messages ensure that the state message is saved on the broker until it is overwritten.
      // This is useful for devices that need to know the last known command or state after they connect or reset.
      client.publish("esp32/bed1/room2", "BLACK", true);
      client.publish("esp32/bed2/room2", "BLACK", true);
    } else {
      // If the connection fails, display the failure message and reason code
      Serial.print("failed, rc=");
      Serial.print(client.state()); // Print the return code from the MQTT connection attempt

      // Inform that a new connection attempt will happen after a delay
      Serial.println(" try again in 5 seconds");

      // Wait for 5 seconds before trying again
      delay(5000);
    }
  }
}

// Callback function that is executed when a message is received on a subscribed topic.
void callback(char* topic, byte* payload, unsigned int length) {
  // Ensure that the payload is null-terminated to prevent overflow when converting to String.
  payload[length] = '\0';
  // Convert the payload into a String for easier comparison and handling.
  String message = String((char*)payload);

  // Check if the message received is a "RESET" command.
  if (message == "RESET") {
    // Compare the topic to see if the message is for room2, bed1
    if (strcmp(topic, "esp32/bed1/room2/reset") == 0) {
      // Set the bed1 button state to false indicating it is not pressed.
      bed1ButtonPressed = false;

      // Turn on the green LED and turn off the red LED for bed1.
      digitalWrite(greenLedPin1, HIGH);
      digitalWrite(redLedPin1, LOW);

      // Publish a message to reset the state to BLACK, with retain flag true to keep it until changed.
      client.publish("esp32/bed1/room2", "BLACK", true);
    } 
    // Check if the topic is for room2, bed2.
    else if (strcmp(topic, "esp32/bed2/room2/reset") == 0) {
      // Set the bed2 button state to false indicating it is not pressed.
      bed2ButtonPressed = false;

      // Turn on the green LED and turn off the red LED for bed2.
      digitalWrite(greenLedPin2, HIGH);
      digitalWrite(redLedPin2, LOW);

      // Publish a message to reset the state to BLACK, with retain flag true to keep it until changed.
      client.publish("esp32/bed2/room2", "BLACK", true);
    }
  }
}


void checkAndPublish(int buttonPin, const char* topic, const char* message, bool& lastState, bool& buttonPressed, int greenLedPin, int redLedPin) {
  bool currentState = digitalRead(buttonPin) == LOW;
  if (currentState && !lastState) {
    // Introduce a delay to handle debouncing
    delay(50); // Adjust or remove delay based on actual testing
    if (digitalRead(buttonPin) == LOW) {  // Check again to confirm button state
      client.publish(topic, message, true);
      digitalWrite(greenLedPin, LOW);
      digitalWrite(redLedPin, HIGH);
      lastState = true;
      buttonPressed = true;
    }
  } else if (!currentState) {
    lastState = false;
    buttonPressed = false; // Reset button pressed state when released
  }

  if (buttonPressed) {
    digitalWrite(greenLedPin, LOW);
    digitalWrite(redLedPin, HIGH);
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  checkAndPublish(buttonPin1, "esp32/bed1/room2", "RED", lastState1, bed1ButtonPressed, greenLedPin1, redLedPin1);
  checkAndPublish(buttonPin2, "esp32/bed1/room2", "YELLOW", lastState2, bed1ButtonPressed, greenLedPin1, redLedPin1);
  checkAndPublish(buttonPin3, "esp32/bed2/room2", "RED", lastState3, bed2ButtonPressed, greenLedPin2, redLedPin2);
  checkAndPublish(buttonPin4, "esp32/bed2/room2", "YELLOW", lastState4, bed2ButtonPressed, greenLedPin2, redLedPin2);
}