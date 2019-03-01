//this will control the MeArm mini robotic arm.
//manual control of the arm with two joysticks and ability to program movements.

//writen by Scott D. Thomas x48985

#include <Servo.h>

#define XINPUT A0 //analog in 0 for X joystick
#define YINPUT A1 //analog in 1 for Y joystick
#define ZINPUT A3 //analog in 2 for Z joystick
#define GINPUT A4 //analog in 3 for Gripper joystick
#define PBXY A2   //analog in 4 for XY joystick pushbutton (Digital Input)
#define PBZG A5   //analog in 5 for ZG joystick pushbutton (Digital Input)


//Define Servo Channels
#define XSERVOPIN 3
#define YSERVOPIN 5
#define ZSERVOPIN 6
#define GSERVOPIN 9
#define XMANULIM 80
#define YMANULIM 80
#define ZMANULIM 80
#define GMANULIM 80


//define Servo Limits and neutral pos
byte XmanUL = 80;
byte XmanLL = 0;
int XupLim = 2100;
int XlrLim = 900;
int Xnpos = 1500;
int XinputPos = 0;

byte YmanUL = 80;
byte YmanLL = 0;
int YupLim = 2100;
int YlrLim = 900;
int Ynpos = 1500;
int YinputPos = 0;

byte ZmanUL = 80;
byte ZmanLL = 0;
int ZupLim = 2100;
int ZlrLim = 900;
int Znpos = 1500;
int ZinputPos = 0;

byte GmanUL = 80;
byte GmanLL = 0;
int GupLim = 2100;
int GlrLim = 900;
int Gnpos = 1500;
int GinputPos = 0;

byte PBXYinput = 0;
byte PBZGinput = 0;

int PosUpdate = 60;
byte Range = 0;
byte mode = 0;

//position storage arrays
int XposArray[20] = {0};
int YposArray[20] = {0};
int ZposArray[20] = {0};
int GposArray[20] = {0};

byte PosNumber = 0;  //variable for the current pos to use in playback mode
unsigned long Etime = 0;
Servo Xservo;
Servo Yservo;
Servo Zservo;
Servo Gservo;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(19200);   // opens the Serial port to 19200 baud rate for communication to a PC/Laptop


  //set up servos pins
  Xservo.attach(XSERVOPIN);
  Yservo.attach(YSERVOPIN);
  Zservo.attach(ZSERVOPIN);
  Gservo.attach(GSERVOPIN);

  
  //set servos to nutral position
  Xservo.write(XinputPos = Xnpos);
  Yservo.write(YinputPos = Ynpos);
  Zservo.write(ZinputPos = Znpos);
  Gservo.write(GinputPos = Gnpos);
  pinMode(PBXY, INPUT_PULLUP);
  pinMode(2, OUTPUT);
  digitalWrite(2, HIGH);
  pinMode(4, OUTPUT);
  digitalWrite(4, HIGH);
  //XmanUL /= 4;
  Etime = millis();
}

void loop() {
  // put your main code here, to run repeatedly:

   PBXYinput = digitalRead(PBXY);
  // Serial.println(PBXYinput);
   if((millis() - Etime) >= PosUpdate)
   {
     if(PBXYinput == 0)
     {
      if(digitalRead(PBXY) == 0)
      {
        mode++;
        if(mode >3)
          mode = 1;
        //change mode
        switch(mode)
        {
          case 1:
              digitalWrite(2, LOW);
              digitalWrite(4, HIGH);
              XmanUL = XMANULIM;
              YmanUL = YMANULIM;
              ZmanUL = ZMANULIM;
              GmanUL = GMANULIM;
              delay(0.1);
              break;
          case 2:
              digitalWrite(2, HIGH);
              digitalWrite(4, HIGH);
              XmanUL = XMANULIM/ 2;
              YmanUL = YMANULIM/2;
              ZmanUL = ZMANULIM/2;
              GmanUL = GMANULIM/2;
              delay(0.1);
              break;
          case 3:
              digitalWrite(2, HIGH);
              digitalWrite(4, LOW);
              XmanUL = XMANULIM/4;
              YmanUL = YMANULIM/4;
              ZmanUL = ZMANULIM/4;
              GmanUL = GMANULIM/4;
              delay(0.1);
              break;
        }
      }
     }     
     ReadSticksPosHold(XinputPos, YinputPos, ZinputPos, GinputPos);
  
     
     Xservo.write(XinputPos);
     Yservo.write(YinputPos);
     Zservo.write(ZinputPos);
     Gservo.write(GinputPos);
      
      
      if(XinputPos > 1550)
      {
        
      }
      if(XinputPos < 1450)
      {
      }
               
     Etime = millis();
   }

   // delay(PosUpdate);



}

//this function will read in the 4 joystick positions and translate and return a valid PWM value for each servo using the MAP function.
byte ReadSticksAutoCenter(int &Xin, int &Yin, int &Zin, int &Gin)
{
    int X, Y, Z, G;

    X = analogRead(XINPUT);
    Y = analogRead(YINPUT);
    Z = analogRead(ZINPUT);
    G = analogRead(GINPUT);

    Xin = map(X, 0, 1023, XlrLim, XupLim);
    Yin = map(Y, 0, 1023, YlrLim, YupLim);
    Zin = map(Z, 0, 1023, ZlrLim, ZupLim);
    Gin = map(G, 0, 1023, GlrLim, GupLim);
    return 0;
}


byte ReadSticksPosHold(int &Xin, int &Yin, int &Zin, int &Gin)
{
    int X, Y, Z, G;
    byte inc = 0, dec = 0;
    X = analogRead(XINPUT);
    Y = analogRead(YINPUT);
    Z = analogRead(ZINPUT);
    G = analogRead(GINPUT);
    
    
    
    if(X >= 550)
    {
      inc = map(X, 512, 1024, XmanLL, XmanUL);
      Xin = PosLim(Xin+inc, XupLim, XlrLim);
    }
    else if(X <= 500)
    {
      dec = map(X, 512, 0, XmanLL, XmanUL);
      Xin = PosLim(Xin-dec, XupLim, XlrLim);
    }

    if(Y >= 550)
    {
      inc = map(Y, 512, 1024, YmanLL, YmanUL);
      Yin = PosLim(Yin+inc, YupLim, YlrLim);
    }
    else if(Y <= 500)
    {
      dec = map(Y, 512, 0, YmanLL, YmanUL);
      Yin = PosLim(Yin-dec, YupLim, YlrLim);
    }


     if(Z >= 550)
    {
      inc = map(Z, 512, 1024, ZmanLL, ZmanUL);
      Zin = PosLim(Zin+inc, ZupLim, ZlrLim);
    }
    else if(Z <= 500)
    {
      dec = map(Z, 512, 0, ZmanLL, ZmanUL);
      Zin = PosLim(Zin-dec, ZupLim, ZlrLim);
    }
    
   
     if(G >= 550)
    {
      inc = map(G, 512, 1024, GmanLL, GmanUL);
      Gin = PosLim(Gin+inc, GupLim, GlrLim);
    }
    else if(G <= 500)
    {
      dec = map(G, 512, 0, GmanLL, GmanUL);
      Gin = PosLim(Gin-dec, GupLim, GlrLim);
    }
    
    
    
    return 0;
}




int PosLim(int Input, int Upper, int Lower)
{
  if(Input >= Upper)
    return Upper;
  if(Input <= Lower)
    return Lower;
  return Input; 
}



