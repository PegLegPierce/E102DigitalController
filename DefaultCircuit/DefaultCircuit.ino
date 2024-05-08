/*
* switch connected from pin 2 to GND
* input Vin from pin 9
* output of circuit read at analog pin A0
*/
//PIN SETTINGS
const int yPin = A0; // Analog read pin
const int uPin = 9; // Analog write pin (PWM)
const int switchPin = 2; // input pin for the switch
boolean switchVal = HIGH; // declare initial switch pin state
// Parameter Settings
int time = 0; // initialize time
const float uin = 2.5; //2.5V input
// Initial Values for internal signals
float y=0;
void setup() {
pinMode(switchPin, INPUT); //set switch pin to input mode
digitalWrite(switchPin,HIGH); //initialize to start with pull up voltage
Serial.begin(9600);
}
void loop() {
//WAIT FOR SWITCH
while(switchVal == HIGH) // repeat this loop until switch is turned on
// (switchVal will go LOW when switch is turned on)
{
analogWrite(uPin,0);
switchVal = digitalRead(switchPin); // read switch state
}
// WRITE CIRCUIT INPUT
int uVal=uin*(255/5);
analogWrite(uPin,uVal);
// READ CIRCUIT OUTPUT
int sensorVal = analogRead(yPin);
// convert to volts
y=sensorVal*(5.0/1023.0);
// print the results to the serial monitor:
Serial.print(time++);
Serial.print (" ");
Serial.println (y);
// WAIT FOR NEXT SAMPLE
delay(100); //sample frequency 10 Hz
switchVal = digitalRead(switchPin); // read switch state
}
