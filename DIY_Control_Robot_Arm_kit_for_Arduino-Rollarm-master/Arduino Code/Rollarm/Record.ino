//Read the values ot the potentiometers.
void ReadKey2()
{

  if (Serial.available()) {
    KeyVal = Serial.readString();
  }
}
