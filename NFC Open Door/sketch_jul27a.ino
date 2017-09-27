/*
 -------Linh Kien Dien Tu TuHu---------
 
* MOSI: Pin 11 / ICSP-4
* MISO: Pin 12 / ICSP-1
* SCK: Pin 13 / ISCP-3
* SS: Pin 10
* RST: Pin 9
* Data_Servo: Pin 8
-------------------------
* Code By: HuVo
*/
 
#include <Servo.h>
#include <SPI.h>
#include <RFID.h>
 
#define SS_PIN 10
#define RST_PIN 9
Servo myservo;
RFID rfid(SS_PIN, RST_PIN);
 
unsigned char reading_card[5]; // Reading array
unsigned char master[5] = { 41, 212, 96, 123, 230}; // NFC Card code suitable to open door (depend on each card)
unsigned char slave[5] = { 108, 51, 164, 89, 162 }; //  NFC Card code suitable to close the door (depend on each card)
 
unsigned char i, j;
 
void setup()
{
 
    myservo.attach(8);
    Serial.begin(9600);
    SPI.begin();
    rfid.init();
    myservo.write(30);
}
 
void loop()
{
    if (rfid.isCard()) {
        if (rfid.readCardSerial()) // Nếu có thẻ
        {
 
            for (i = 0; i < 5; i++) {
 
                reading_card[i] = rfid.serNum[i]; //save code readed into reading_card array
            }
            Serial.println();
            //verification
            for (i = 0; i < 5; i++) {
                //Compare each element of reading_card with master array
                if (reading_card[i] != master[i]) // if each element no match loop will break
                {
                    break;
                }
            }
            // Same with slave nfc card
            for (j = 0; j < 5; j++) {
                if (reading_card[i] != slave[i]) {
                    break;
                }
            }
            if (i == 5) // if all 5 elelment match, open door
            {
                myservo.write(180); // 
            }
            if (j == 5) {
                myservo.write(30); // 
            }
        }
        rfid.halt();
    }
}
