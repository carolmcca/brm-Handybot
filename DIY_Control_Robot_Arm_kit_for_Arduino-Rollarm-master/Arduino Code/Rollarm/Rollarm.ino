/* -----------------------------------------------------------------------------
  Author             : Allen
  Check              : Amy
  Version            : V2.0
  Date               : 12/09/2019
  Description        : Rollarm control program
  Company website    : http://www.sunfounder.com
   ---------------------------------------------------------------------------*/

/* Include ------------------------------------------------------------------*/
// Create servo object to control a servo. 
#include <Servo.h> 
//int ledPin = 13;
Servo Servo_0;
Servo Servo_1;
Servo Servo_2;
Servo Servo_3;

//#define DataPrint //Uncomment only this to print the data.

int Joint0[50] = {0}; 
int Joint1[50] = {0};
int Joint2[50] = {0};
int Joint3[50] = {0};


static String KeyVal[2];
static char delimeter = ';';
int count = 0;
// 
int Time = 0;
int M0 = 10, M1 = 100, M2 = 0, M3 = 100;

/*
 - setup function
 * ---------------------------------------------------------------------------*/
void setup() 
{
  //Start the serial for debug.
  Serial.begin(9600);
  Serial.println("Ligado");
  //Attach the servos on pins to the servo object
  Servo_0.attach(4);
  Servo_1.attach(5);
  Servo_2.attach(6);
  Servo_3.attach(7);
  //pinMode(ledPin, OUTPUT);
  //Set the pin 3 to input
  pinMode(3, INPUT);

  Servo_0.write(90);
  Servo_1.write(M0);
  Servo_2.write(M1);
  Servo_3.write(M3);
}

/*
 - loop function
 * ---------------------------------------------------------------------------*/
void ReadKey() {
  if (Serial.available()) {
    // KeyVal = Serial.read();
    String input = Serial.readStringUntil('#');  // read the string until the '#' character is found
    input.remove(input.length()-1)
    count =input.split(delimeter, KeyVal,0);
    char discart = Serial.read();
    // Serial.println(uValue);  print the U value to the serial monitor
  }
}

void loop() 
{
  ReadKey();
  //The first axis.   
  if (KeyVal[0] == 'U')
  {
    if (M0 < 160){
      M0 += 1;
    }
    if (M1 < 160){
      M1 += 1;
    }
    Servo_1.write(M0);
    Servo_2.write(M0);
    //digitalWrite(ledPin, HIGH);
  }
  else if (KeyVal[0] == 'S')
  {
    if (M0 > 10){
      M0 -= 1;
    }
    if (M1 > 10){
      M1 -= 1;
    }
    Servo_1.write(M0);
    Servo_2.write(M0);
    //digitalWrite(ledPin, LOW);
  }

  
  //The second axis.   
  if (KeyVal[1] == 'U')
  {
    if (M3 < 160){
      M3 += 1;
    }
    Servo_3.write(M3);
    //digitalWrite(ledPin, HIGH);
  }
  else if (KeyVal[1] == 'S')
  {
    if (M3 > 110){
      M3 -= 1;
    }
    Servo_3.write(M3);
    //digitalWrite(ledPin, LOW);
  }
  
  delay(30);
}
