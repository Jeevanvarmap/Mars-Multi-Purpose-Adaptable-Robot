#include <SoftwareSerial.h>
#include <Wire.h>

//Left Motors

int ln = 2;
int lp = 3;
int rn = 4;
int rp = 5;
int ls = 6;
int rs = 7;

char temp[32];
String data="";
volatile boolean receiveFlag = false;

void setup() {
  // Join I2C bus as slave with address 8
  Wire.begin(0x04);
  
  // Call receiveEvent when data received                
  Wire.onReceive(receiveEvent);
  
  pinMode(ln, OUTPUT);
  pinMode(lp, OUTPUT);
  pinMode(rn, OUTPUT);
  pinMode(rp, OUTPUT);
  pinMode(ls, OUTPUT);
  pinMode(rs, OUTPUT);
  analogWrite(ls, 128);
  analogWrite(rs, 128);
  Serial.begin(9600);
}

void moveforward(){
  Serial.println("Robot moving forward");
  //left
  digitalWrite(lp, LOW);
  digitalWrite(ln, HIGH);
  //right  
  digitalWrite(rp, LOW);
  digitalWrite(rn, HIGH);
}

void moveright(){
  Serial.println("Robot moving right");
  //left
  digitalWrite(lp, HIGH);
  digitalWrite(ln, LOW);
  //right  
  digitalWrite(rp, LOW);
  digitalWrite(rn, HIGH);
}

void moveleft(){
  Serial.println("Robot moving left");
  //left
  digitalWrite(lp, LOW);
  digitalWrite(ln, HIGH);
  //right  
  digitalWrite(rp, HIGH);
  digitalWrite(rn, LOW);
}

void movebackward(){
  Serial.println("Robot moving backward");
    //left
  digitalWrite(lp, HIGH);
  digitalWrite(ln, LOW);
  //right  
  digitalWrite(rp, HIGH);
  digitalWrite(rn, LOW);  
}

void movestop(){
  Serial.println("Robot Stopped");
  //left
  digitalWrite(lp, LOW);
  digitalWrite(ln, LOW);
  //right  
  digitalWrite(rp, LOW);
  digitalWrite(rn, LOW); 
}

// Function that executes whenever data is received from master
void receiveEvent(int howMany) {
//    Serial.print(howMany);
    for (int i = 0; i < howMany; i++) {
        temp[i] = Wire.read();
        temp[i + 1] = '\0'; //add null after ea. char
    }

    //RPi first byte is cmd byte so shift everything to the left 1 pos so temp contains our string
    for (int i = 0; i < howMany; ++i){
        temp[i] = temp[i + 1];
    }
    data=temp;
    receiveFlag = true;
}

void loop() {
  if (receiveFlag == true) {
//    Serial.print(temp);
    if(data.startsWith("mf")){
      moveforward();
    }
    else if(data.startsWith("mr")){
      moveright();
    }
    else if(data.startsWith("ml")){
      moveleft();
    }
    else if(data.startsWith("mb")){
      movebackward();
    }
    else if(data.startsWith("ms")){
      movestop();
    }
    else{
      Serial.println("None");
    }
    receiveFlag = false;
  }
  delay(100);
}
