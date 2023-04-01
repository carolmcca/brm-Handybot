// Define the LED pin
int ledPin = 3;

// Setup function runs once when Arduino is powered on or reset
void setup() {
  // Initialize serial communication at a baud rate of 9600
  Serial.begin(9600);
  Serial.println("Ligado");
  // Set LED pin as an output
  pinMode(ledPin, OUTPUT);
}

// Loop function runs repeatedly as long as Arduino is on
void loop() {
  // Check if there is data available on the serial port
  if (Serial.available() > 0) {
    // Read the incoming character
    char incomingChar = Serial.read();

    // Check if the incoming character is 'U'
    if (incomingChar == 'U') {
      // Turn on the LED
      digitalWrite(ledPin, HIGH);
    }
    
    // Check if the incoming character is 'S'
    if (incomingChar == 'S') {
      // Turn off the LED
      digitalWrite(ledPin, LOW);
    }
  }
}
