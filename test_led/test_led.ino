// Define the LED pin
int ledPin1 = 2;
int ledPin2 = 4;
char KeyVal[] = {'S', 'U'};
// Setup function runs once when Arduino is powered on or reset
void setup() {
  // Initialize serial communication at a baud rate of 9600
  Serial.begin(9600);
  Serial.println("Ligado");
  // Set LED pin as an output
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
}

void ReadKey() {
//  if (Serial.available()) {
//    // KeyVal = Serial.read();
//    String input = Serial.readStringUntil('#');  // read the string until the '#' character is found
//    input.remove(input.length()-1);
//    int r=0, t=0;
//    for (int i=0; i < input.length(); i++) { 
//      if(input.charAt(i) == ';') { 
//        KeyVal[t] = input.substring(r, i).charAt(0); 
//        r=(i+1); 
//        t++; 
//      }
//    }
//    char discart = Serial.read();
//    // Serial.println(uValue);  print the U value to the serial monitor
//     Serial.println(KeyVal);
//  }
    int i = 0;
    while (Serial.available()) {
      char receivedChar = Serial.read();
      if (receivedChar == '#') {
        Serial.flush();
        break;
      }
      else if (receivedChar == ';' || receivedChar == '\n') {
        continue;
      }
      else {
        KeyVal[i] = receivedChar;
        i++;
      }
      Serial.println(KeyVal);
    }
}


// Loop function runs repeatedly as long as Arduino is on
void loop() {
 ReadKey();
  //The first axis.   
  if (KeyVal[0] == 'U')
  {
    digitalWrite(ledPin1, HIGH);
  }
  else if (KeyVal[0] == 'S')
  {
    digitalWrite(ledPin1, LOW);
  }

  
  //The second axis.   
  if (KeyVal[1] == 'U')
  {
    digitalWrite(ledPin2, HIGH);
  }
  else if (KeyVal[1] == 'S')
  {
    digitalWrite(ledPin2, LOW);
  }
  delay(30);
}
