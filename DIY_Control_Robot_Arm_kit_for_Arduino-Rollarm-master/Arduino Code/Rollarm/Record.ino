//Read the values ot the potentiometers.
void ReadKey()
{

  if (Serial.available()) {
    KeyVal = Serial.readString();
  }
}
