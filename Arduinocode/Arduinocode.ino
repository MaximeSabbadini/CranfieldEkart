#include <mcp_can.h>
#include <SPI.h>
#include "arduinosend.h"
#include "DFRobot_RGBLCD1602.h"

// https://github.com/coryjfowler/MCP_CAN_lib

// Define the PINS used on the board

#define TVButton 4
#define SteerPotPIN 2
#define ThrottlePotPIN 3

// Define variables used in the code

int Ts = 10; // milliseconds, sampling time
unsigned long timeStart;
bool passed_state_tv = false;
bool tv_state = false;

long MASK[] = {0xFF00, 0x00FF}; // Mask used to isolate first and second byte
byte SHIFT[] = {8, 0}; // Shift that will be used to get the value

byte first, second; // Variable in which we store each byte

unsigned int SteerPotVAL = 512; // Variable to store the value of the steering pot from the ADC (0 - 1023)
unsigned int ThrottlePotVAL = 0; // Variable to store the value of the throttle pot from the ADC (0 - 1023)
uint8_t cnt=0;

uint32_t CAN_ID = 0x123;

// Each Value is on two bytes.
// Steering is b1 b2 (b1 Least significant byte)
// Throttle Position is b3 b4 (b3 Least significant byte)

MCP_CAN CAN0(53);     // Set CS to pin 534h

DFRobot_RGBLCD1602 lcd(/*RGBAddr*/0x60 ,/*lcdCols*/16,/*lcdRows*/2);  //16 characters and 2 lines of show

int val=0;

void setup()
{
  Serial.begin(115200);
  lcd.init();
  // Initialize MCP2515 running at 16MHz with a baudrate of 500kb/s and the masks and filters disabled.
  if(CAN0.begin(MCP_ANY, CAN_500KBPS, MCP_8MHZ) == CAN_OK) Serial.println("MCP2515 Initialized Successfully!");
  else Serial.println("Error Initializing MCP2515...");

  CAN0.setMode(MCP_NORMAL);   // Change to normal mode to allow messages to be transmitted
  pinMode(TVButton, INPUT_PULLUP);
}

byte data[8];// = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};

void loop()
{
  timeStart = micros();
  SteerPotVAL = analogRead(SteerPotPIN); // Get Value from ADC
  first = getByteAt(SteerPotVAL, 0); // Get the first byte (MSByte)
  second = getByteAt(SteerPotVAL, 1); // Get the second byte (LSByte)
  // Serial.println(SteerPotVAL);

  data[0] = first;
  data[1] = second;

  ThrottlePotVAL = analogRead(ThrottlePotPIN); // Get Value from ADC
  first = getByteAt(ThrottlePotVAL, 0); // Get first byte (MSByte)
  second = getByteAt(ThrottlePotVAL, 1); // Get second byte (LSByte)

  // Serial.println(ThrottlePotVAL);


  data[2] = first;
  data[3] = second;

  if(digitalRead(TVButton) != passed_state_tv){
    // Serial.println("Through");
    lcd.clear();
  
  
  if(digitalRead(TVButton)==LOW){
    passed_state_tv = LOW;
    tv_state = true;
    lcd.setCursor(0, 0);
    lcd.print("TV ON");
  }
  else {
    passed_state_tv = HIGH;
    tv_state = false;
    lcd.setCursor(0, 0);
    lcd.print("TV OFF");
  }
  }

  data[4] = tv_state;

  cnt += 1;
  data[5] = cnt;

  // send data:  ID = 0x123, Extended CAN Frame, Data length = 5 bytes, 'data' = array of data bytes to send
  byte sndStat = CAN0.sendMsgBuf(CAN_ID, 1, 6, data);
  if(sndStat == CAN_OK){
    Serial.println("Message Sent Successfully!");
  } else {
    Serial.println("Error Sending Message...");
  }


  while(micros()-timeStart<(Ts*1000)){
  //   // Wait, do other tasks here
  }  
  // Serial.println(micros()-timeStart);
}

byte getByteAt(int value, byte position)
{ // Function to get the desired byte from a 16bit unsigned int
  int result = value & MASK[position];  // binary AND
  result = result >> SHIFT[position];    // Shift right, moving all bits
  byte resultAsByte = (byte) result;     // Convert to an actual byte
  return resultAsByte;  
}

/*********************************************************************************************************
  END FILE
*********************************************************************************************************/
