//The Arduino will use the Analog inputs to read in the x and y of the joystick and display the value
//also using a digital IO we will read the button press.
//Scott Thomas
//48985

#include <Servo.h> 

#define XAXIS  A0   // defines the input pin for the potentiometer X axis
#define YAXIS  A1   // defines the input pin for the potentiometer Y axis
#define BUTTON 7    // defines the input pin for the center push button

#define ServoPin 9

int ButtonVal = 0; //stor the value of the Button 1 or 0 
int Xvalue = 0;    //store the x value of the POT 0 - 1023   10 bit ADC   so (2^10)-1 = 1023
int Yvalue = 0;   //store the Y value of the POT 0 - 1023

int UpperLim = 2100;
int LowerLim = 900;
int Center = 1500;
int PWMval = 1500;

byte DebounceCntr = 0;
byte BounceLim = 50;

Servo myservo;  // create servo object to control a servo 

void setup() {
  Serial.begin(9600); //set up comport to spit out the values
  Serial.println("We will Read the joystick and move a servo based on that");

  myservo.attach(ServoPin);  // attaches the servo on pin 9 to the servo object 
  myservo.write(Center);  //send the Default Center Value to the Servo on startup. 

  pinMode(BUTTON, INPUT_PULLUP);    // sets the pin used for the button as an input with an internal pullup
  delay(1000);
}

void loop() {
  // read the value from the sensor:
  Xvalue = analogRead(XAXIS); 
  Yvalue = analogRead(YAXIS);  
  ButtonVal = digitalRead(BUTTON);
  
  if(ButtonVal == 0)
  {
      DebounceCntr++;
  }
  else
  {
      DebounceCntr --;
      if(DebounceCntr <= 0) DebounceCntr = 0;
  }

  if(DebounceCntr >= BounceLim)
  {
      myservo.write(Center);  //send the Default Center Value to the Servo on startup. 
      delay(250); //give it a 1/4sec to move
      DebounceCntr = 0;
  }
  else
  {
     PWMval = map(Xvalue, 0, 1023, LowerLim, UpperLim); 
     myservo.write(PWMval);
   
  }

  
   
   
  delay(50);                  
}
