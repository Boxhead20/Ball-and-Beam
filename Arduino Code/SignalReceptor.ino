
#include <Servo.h>

Servo myservo;  // create servo object to control a servo
int pos = 1650;    // variable to store the servo signal
int ad=1650;
int flag=1;

void setup() {
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  Serial.begin(9600);
   myservo.writeMicroseconds(1650);              
}

void loop() {
  if(Serial.available()>1){// get the signal from matlab
   ad=Serial.parseInt();
    myservo.writeMicroseconds(ad);   
    //real();
  }
  
}
void real(){//in case that servo motors movements are agresive use the void
  
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
