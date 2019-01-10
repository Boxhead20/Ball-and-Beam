
#include <Servo.h>

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 1650;    // variable to store the servo position
int ad=1650;
int flag=1;

void setup() {
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  Serial.begin(9600);
   myservo.writeMicroseconds(1650);              
}

void loop() {
  if(Serial.available()>1){
   ad=Serial.parseInt();
    myservo.writeMicroseconds(ad);   
    
  }
  
}
void real(){
  
  if(ad>pos){
    while(pos<=ad) {
     myservo.writeMicroseconds(pos);  
     pos=pos+20;
     delay(10); 
     //Serial.println("up");
    }
    pos=ad;
  }
   if(ad<pos){
    while(pos>=ad){ 
      myservo.writeMicroseconds(pos);
     pos=pos-20;
    // Serial.println("Down");
     delay(10);                       
    }
    pos=ad;
  }
}
