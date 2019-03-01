//this program will sweep a servo back and forth

//Scott Thomas
//48985

#include <Servo.h> 
 
#define ServoPin 9  //used to drive the PWM to the servo


Servo myservo;  // create servo object to control a servo 
 
int PWMVal = 1500;      // 1.5mS variable to read the value from the analog pin 
int UpperLimit = 2100;  //2.1mS
int LowerLimit = 900;   //900uS
int x = 0;
int StepSize = 10;     //move pwm by 10uS increments

void setup() 
{ 
  Serial.begin(9600);
  Serial.println("We are going to Sweep a servo");
  myservo.attach(ServoPin);  // attaches the servo on pin 9 to the servo object 
  myservo.write(PWMVal);  //send the Default Center Value to the Servo on startup. 
  Serial.print("Commanded Center Servo Postition: ");  
  Serial.println(PWMVal);    //prints to the screen the commanded servo position.
  delay(2000); //wait 2sec after we center the servo
} 
 
void loop() 
{ 

  
    for(PWMVal = LowerLimit; PWMVal <= UpperLimit;PWMVal += StepSize)  //move servo on direction
    {
        myservo.write(PWMVal); // sets the servo position according to the scaled value 
        Serial.print("Commanded incrementing Servo Postition: ");  
        Serial.println(PWMVal);    //prints to the screen the commanded servo position.
        delay(15);           // waits for the servo to get there 
    }                
    for(PWMVal = UpperLimit; PWMVal >= LowerLimit;PWMVal -= StepSize) //move servo other direction
    {
        myservo.write(PWMVal); // sets the servo position according to the scaled value 
        Serial.print("Commanded decrementing Servo Postition: ");
        Serial.println(PWMVal);    //prints to the screen the commanded servo position.
        delay(15);           // waits for the servo to get there 
    }        

    delay(500);
  
} 
