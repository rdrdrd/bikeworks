//The Arduino will use the Analog inputs to read in the x and y of the joystick and display the value
//also using a digital IO we will read the button press.
//Scott Thomas
//48985

#define XAXIS  A0   // defines the input pin for the potentiometer X axis
#define YAXIS  A1   // defines the input pin for the potentiometer Y axis
#define BUTTON 7    // defines the input pin for the center push button
int ButtonVal = 0; //stor the value of the Button 1 or 0 
int Xvalue = 0;    //store the x value of the POT 0 - 1023   10 bit ADC   so (2^10)-1 = 1023
int Yvalue = 0;   //store the Y value of the POT 0 - 1023

void setup() {
  Serial.begin(9600); //set up comport to spit out the values
  Serial.println("We will Read the joystick and return the RAW values");

  pinMode(BUTTON, INPUT_PULLUP);    // sets the pin used for the button as an input with an internal pullup
}

void loop() {
  // read the value from the sensor:
  Xvalue = analogRead(XAXIS); 
  Yvalue = analogRead(YAXIS);  
  ButtonVal = digitalRead(BUTTON);
  
   Serial.print("X axis value: ");
   Serial.print(Xvalue);
   Serial.print("    Y axis value: ");
   Serial.print(Yvalue);
   Serial.print("    Button Value: ");
   Serial.println(ButtonVal);
   
  delay(50);                  
}
