//The Arduino will ask you your name the say Hello <name>
//Scott Thomas
//48985

byte Name[20]; 
byte NumbAvail = 0; 
int inc = 0; 


void setup() 
{ 
  Serial.begin(57600);
  Serial.println("What is your Name?");
  
} 
 
void loop() 
{ 
 //get number of bytes available in input que
 while(Serial.available() == 0);  //waits till someing is in input que.
    while(Serial.available() > 0)
    {
      Name[NumbAvail] = Serial.read();
      NumbAvail++;
      delay(10);  //small delay 
    }
    
  
  Serial.print("Hello ");
  Serial.write(Name, NumbAvail);
  
  
  Serial.println("Plese press 'c' to continue");
while(go)  //just sits in this loop till we send the correct character
{
  if(Serial.available() >= 1)
    if(Serial.read() == 'c')
      go = 0;
    else go = 1;


}  
  
Serial.println("Great you continued");  
delay(2000);
//restart the loop
  
  
} 
