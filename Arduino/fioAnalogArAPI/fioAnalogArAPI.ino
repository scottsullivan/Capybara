#include <XBee.h>
#include <stdlib.h>
#include <NewSoftSerial.h>
//Pinouts
// Arduino ->  LV-EZ0-MB1000
// A0 -> AN (MB1000)
// D10
// D12 -> Green LED
// D13 -> Red LED
// 3V3 -> +5 (MB1000)
// GND -> GND (MB1000 and everywhere)
//
//
//
//
//


XBee xbee = XBee();

uint8_t default_payload[] = { 'H', 'i' };
String prefix = "";
// SH + SL Address of receiving XBee
XBeeAddress64 addr64 = XBeeAddress64(0x0013a200, 0x4089D1aa);
ZBTxRequest zbTx = ZBTxRequest(addr64, default_payload, sizeof(default_payload));
ZBTxStatusResponse txStatus = ZBTxStatusResponse();

int statusLed = 13;
int errorLed = 12;

void setup() {
  pinMode(statusLed, OUTPUT);
  pinMode(errorLed, OUTPUT);
  pinMode(A3, INPUT);
  //Serial.begin(9600); //if we're checking output locally
  xbee.begin(9600);
}

void loop() {

  int AN = analogRead(3);
  String output = prefix + AN;
  int outputLength = output.length()+1;
  byte charBuf[outputLength];
  output.getBytes(charBuf,outputLength);

  zbTx.setPayload(charBuf);
  zbTx.setPayloadLength(outputLength);

  xbee.send(zbTx); //We'd add a Serial.print() here if we were doing local stuff.

  delay(100);
}



