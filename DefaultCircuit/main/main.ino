/*
Step response of P control RC circuit after
a switched 2.5V step reference input.
The circuit:
* switch connected from pin 2 to GND
* input Vin from pin 9
* output of circuit read at analog pin A0
*/
//PIN SETTINGS
const int yPin = A0; // Analog read pin
const int uPin = 9; // Analog write pin (PWM)
const int switchPin = 2; // input pin for the switch
boolean switchVal = HIGH; // declare initial switch pin state

// State Space Matrices and other stuff
int time = 0; // initialize time
int uVal = 0; // initialize control input
const float Ts = 0.1;
const float A[2][2] = {
    {0.7746, -0.0883},
    {0.0883, 0.9954}
};
const float B[2] = {
    0.0883, 0.0046
};
const float C[2] = {
    0, 1
};
const float D = 0;
const float K[2] = {
    2.3444, 7.8578
};
const float Kr = -8.8578;
const float L[2] = {
    -0.2653, 0.7633
};

// Initial Values for internal signals
float y=0;
float ref=2.5;
float u=0;
float yhat=0;
float x_obs[2] = {-3, -3};
float x_obs_prev[2] = {-5, -5};
float feedback = 0;

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

    // READ CIRCUIT OUTPUT
    int sensorVal = analogRead(yPin);

    // convert to volts
    y=sensorVal*(5.0/1023.0);

    // Calculate xhat
    yhat = C[0]*x_obs_prev[0] + C[1]*x_obs_prev[1] + D*u;
    x_obs[0] = A[0][0]*x_obs_prev[0] + A[0][1]*x_obs_prev[1] + B[0]*u + L[0]*(y - yhat);
    x_obs[1] = A[1][0]*x_obs_prev[0] + A[1][1]*x_obs_prev[1] + B[1]*u + L[1]*(y - yhat);
    
    // Calculate feedback values using +K
    feedback = x_obs[0]*-K[0] + x_obs[1]*-K[1];

    // Use feedback to calculate new input
    u = ref*-Kr + feedback;
    
    // check that control signal is in range
    if (u>5)
    {
        u=5;
    }
    if (u<0)
    {
        u=0;
    }
    // WRITE CIRCUIT INPUT
    uVal=u*(255/5);
    analogWrite(uPin,uVal);

    // print the results to the serial monitor:
    Serial.print(time++);
    Serial.print (" ");
    Serial.print (y);
    Serial.print (" ");
    Serial.println(u);
    
    // WAIT FOR NEXT SAMPLE AND STORE NEW XHAT
    delay(100); //sample frequency 10Hz
    switchVal = digitalRead(switchPin); // read switch state
    
    x_obs_prev[0] = x_obs[0];
    x_obs_prev[1] = x_obs[1];
}
