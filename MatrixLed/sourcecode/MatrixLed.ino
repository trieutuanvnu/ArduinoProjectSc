#include "LedControl.h"// Led Control library
LedControl matrix = LedControl(4,3,2,1);
// Set pin 4 to DataIn
// Pin 3 to CLK
// Pin 2 to LOAD
// And use 1 IC MAX7219
void setup() {
    matrix.shutdown(0, false); // Open Display
    matrix.setIntensity(0, 15); // Set max brighness
    matrix.clearDisplay(0); // Turnoff all led
}
    // Set character array
byte A[56] = {
    0x00,0x3F,0x7F,0xA4,0xA4,0x7F,0x3F,0x00, // A
    0x00,0xFF,0xFF,0x98,0x94,0x92,0x61,0x00, // R
    0x00,0xFF,0xFF,0x81,0x81,0x7E,0x3C,0x00, // D
    0x00,0xFE,0xFF,0x01,0x01,0xFF,0xFE,0x00, // U
    0x00,0x81,0x81,0xFF,0xFF,0x81,0x81,0x00, // I
    0x00,0xFF,0xC0,0x30,0x0C,0x03,0xFF,0x00, // N
    0x00,0x7E,0xFF,0x81,0x81,0xFF,0x7E,0x00 // O          
};
// Movement show
void showScroll() {
        matrix.clearDisplay(0);
        int pos = 8;
        for (int j = pos; j > -56; j--) { // Change position
            for (int i = 0; i < 56; i++) { // Show charater
                matrix.setRow(0, i + j, A[i]);
            }
            delay(200);
        }
    }
    
// Single show
void showSingle() {
    matrix.clearDisplay(0);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i]); //Show A
    delay(2000);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i + 8]); // Show B
    delay(2000);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i + 16]); // Show C
    delay(2000);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i + 24]);
    delay(2000);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i + 32]);
    delay(2000);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i + 40]);
    delay(2000);
    for (int i = 0; i < 8; i++) matrix.setRow(0, i, A[i + 48]);
    delay(2000);
}

void loop() {
    showScroll();
    //showSingle();
}
