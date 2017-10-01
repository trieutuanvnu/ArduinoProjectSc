/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/20/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16L
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>

#include <delay.h>

// Standard Input/Output functions
#include <stdio.h>
#include <string.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here
unsigned char send_tel_number[] = "+841665634176";
unsigned char send_msg[30];
unsigned char rcvdCheck = 0;
unsigned char rcvdConf = 0;
unsigned char rcvdEnd = 0;
unsigned char rcvd_tel_number[15];
unsigned char rcvd_msg[50];

unsigned int  max_mq2_adc = 0;
unsigned int  mq2_adc;
unsigned char ir_status;
unsigned char mq2_detected = 0;
unsigned char start_measure = 0;
unsigned char mq2_count = 0;
unsigned char timer1_count = 0;

unsigned char rl1_status = 0;
unsigned char rl2_status = 0;
unsigned char rl3_status = 0;
unsigned char buzz_status = 0;
unsigned char rl3_enable = 1;
unsigned char buzz_enable = 1;

unsigned char rl1_str[] = "quat";
unsigned char rl2_str[] = "den";
unsigned char rl3_str[] = "gio";
unsigned char buzz_str[] = "coi";

unsigned char on_str[] = "on";
unsigned char off_str[] = "off";
unsigned char en_str[] = "en";
unsigned char dis_str[] = "dis";
flash unsigned char comma[] = ",";

unsigned int mq2_sms_sent_count = 0;
unsigned int ir_sms_sent_count = 0;

#define RL1_PIN     PORTD.6
#define RL2_PIN     PORTD.5
#define RL3_PIN     PORTD.7
#define BUZZ_PIN    PORTC.0

#define IR_PIN      PINB.0

#define BUT1_PIN    PIND.2
#define BUT2_PIN    PIND.3

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 100
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;


void SIM800A_SMSsetup()
{
    printf("AT\r\n");
    delay_ms(1000);
    printf("AT+CMGF=1\r\n");
    delay_ms(1000);
    printf("AT+CNMI=1,2,0,0,0\r\n");
    delay_ms(1000);
}


void SIM800A_sendSMS(unsigned char* tel_number, unsigned char* msg)
{
    printf("AT+CMGS=\"%s\"\r\n", tel_number);
    delay_ms(200);
    printf("%s", msg);
    putchar(26);
}


unsigned char hasString(char *str, char *sub)
{
   char *p;
   p = strstr(str, sub);
   if (p)
      return 1;
   else
      return 0;
}


void clearBuffer()
{
    unsigned char i; 

    for (i = 0; i < RX_BUFFER_SIZE; i++)
    {
        rx_buffer[i] = '\0';
    }                       
    rx_wr_index = 0;
    for (i = 0; i < 15; i++)
    {
        rcvd_tel_number[i] = '\0';
    }                          
    for (i = 0; i < 30; i++)
    {
        rcvd_msg[i] = '\0';
    }
}


void bufferExecute()
{
    unsigned int i;
    unsigned char index = 0;
    
    unsigned char* token;
    
    for (i = 4; i < 17; i++)
    {
        rcvd_tel_number[index++] = rx_buffer[i]; 
    }
    index = 0;
    for (i = 46; i < rx_wr_index - 2; i++)
    {
        rcvd_msg[index++] = rx_buffer[i];
    }
    
    //Doi tu chu hoa sang chu thuong
    for (i = 0; i < index; i++)
    {
        if ((rcvd_msg[i] >= 'A') && (rcvd_msg[i] <= 'Z'))
            rcvd_msg[i] += 32;
    }

    token = strtok(rcvd_msg, comma);
    while (token != NULL)
    {
        if (hasString(token, rl1_str) && hasString(token, on_str))
        {
            rl1_status = 1;
        }
        else if (hasString(token, rl1_str) && hasString(token, off_str))
        {
            rl1_status = 0;
        }
        else if (hasString(token, rl2_str) && hasString(token, on_str))
        {
            rl2_status = 1;
        }
        else if (hasString(token, rl2_str) && hasString(token, off_str))
        {
            rl2_status = 0;
        }
        else if (hasString(token, rl3_str) && hasString(token, on_str))
        {
            rl3_status = 1;
        }
        else if (hasString(token, rl3_str) && hasString(token, off_str))
        {
            rl3_status = 0;
        } 
        else if (hasString(token, rl3_str) && hasString(token, dis_str))
        {
            rl3_enable = 0;
            rl3_status = 0;
        }
        else if (hasString(token, rl3_str) && hasString(token, en_str))
        {
            rl3_enable = 1;
        }
        else if (hasString(token, buzz_str) && hasString(token, on_str))
        {
            buzz_status = 1;
        }
        else if (hasString(token, buzz_str) && hasString(token, off_str))
        {
            buzz_status = 0;
        } 
        else if (hasString(token, buzz_str) && hasString(token, dis_str))
        {
            buzz_enable = 0;
            buzz_status = 0;
        }
        else if (hasString(token, buzz_str) && hasString(token, en_str))
        {
            buzz_enable = 1;
        }
        
        token = strtok(NULL, comma);        
    }
        
    clearBuffer();
}


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
    char status,data;
    status=UCSRA;
    data=UDR;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
    {                     
        if ((data == '+') && (rcvdCheck == 0))   
            rcvdCheck = 1;
        else if ((data == 'C') && (rcvdCheck == 1))
            rcvdCheck = 2;  
        else if ((data == 'M') && (rcvdCheck == 2))
            rcvdCheck = 3; 
        else if ((data == 'T') && (rcvdCheck == 3))
            rcvdCheck = 4;
        else
            rcvdCheck = 0; 
            
        if (rcvdCheck == 4)
        {
            rx_wr_index = 0;
            rcvdConf = 1;
            rcvdCheck = 0;
        }
        
        if (rcvdConf == 1)
        {          
            rx_buffer[rx_wr_index++] = data;
            
            if (data == '\n')
                rcvdEnd++;
                
            if (rcvdEnd == 2)
            {
                rcvdConf = 0;
                rcvdEnd = 0; 
                bufferExecute();                
            }
        }
    
        
        #if RX_BUFFER_SIZE == 256
        // special case for receiver buffer size=256
        if (++rx_counter == 0) rx_buffer_overflow=1;
        #else
        if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
        if (++rx_counter == RX_BUFFER_SIZE)
        {
            rx_counter=0;
            rx_buffer_overflow=1;
        }
    #endif
    }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
    char data;
    while (rx_counter==0);
    data=rx_buffer[rx_rd_index++];
    #if RX_BUFFER_SIZE != 256
    if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
    #endif
    #asm("cli")
    --rx_counter;
    #asm("sei")
    return data;
}
#pragma used-
#endif

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    TCNT1H=0xCA00 >> 8;
    TCNT1L=0xCA00 & 0xff;
    // Place your code here
    timer1_count++;
    if (timer1_count >= 7)
    {
        timer1_count = 0;
        start_measure = 1;
    }
    if (mq2_sms_sent_count != 0)
    {
        mq2_sms_sent_count++;
        if (mq2_sms_sent_count >= 6000)
            mq2_sms_sent_count = 0;
    }
    if (ir_sms_sent_count != 0)
    {
        ir_sms_sent_count++;
        if (ir_sms_sent_count >= 6000)
            ir_sms_sent_count = 0;
    }
}

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | ADC_VREF_TYPE;
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=(1<<ADSC);
    // Wait for the AD conversion to complete
    while ((ADCSRA & (1<<ADIF))==0);
    ADCSRA|=(1<<ADIF);
    return ADCW;
}


void main(void)
{
    // Declare your local variables here

    // Input/Output Ports initialization
    // Port A initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

    // Port B initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
    DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
    PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    // Port D initialization
    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 1382.400 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 10 ms
    // Timer1 Overflow Interrupt: On
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
    TCNT1H=0xCA;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    ASSR=0<<AS2;
    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
    TCNT2=0x00;
    OCR2=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
    MCUCSR=(0<<ISC2);

    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 9600
    UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
    UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
    UBRRH=0x00;
    UBRRL=0x47;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // The Analog Comparator's positive input is
    // connected to the AIN0 pin
    // The Analog Comparator's negative input is
    // connected to the AIN1 pin
    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

    // ADC initialization
    // ADC Clock frequency: 691.200 kHz
    // ADC Voltage Reference: AREF pin
    // ADC Auto Trigger Source: ADC Stopped
    ADMUX=ADC_VREF_TYPE;
    ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
    SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

    // SPI initialization
    // SPI disabled
    SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

    // TWI initialization
    // TWI disabled
    TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

    // Alphanumeric LCD initialization
    // Connections are specified in the
    // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
    // RS - PORTC Bit 7
    // RD - PORTC Bit 6
    // EN - PORTC Bit 5
    // D4 - PORTC Bit 4
    // D5 - PORTC Bit 3
    // D6 - PORTC Bit 2
    // D7 - PORTC Bit 1
    // Characters/line: 16
    lcd_init(16);

    // Global enable interrupts
    #asm("sei")   
    
    lcd_gotoxy(0,0);
    lcd_puts("D.KHIEN THIET BI");
    lcd_gotoxy(0,1);
    lcd_puts("    SIM800A     ");
    delay_ms(2000);
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Initializing...");
    delay_ms(15000);
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Configuring");
    lcd_gotoxy(0,1);
    lcd_puts("SIM800A...");
    SIM800A_SMSsetup();
    clearBuffer();
    lcd_gotoxy(11,1);
    lcd_puts("Done");
    delay_ms(1000);
    lcd_clear();
    
    while (1)
    {
        // Place your code here
        
        if (BUT1_PIN == 0)
        {
            while (BUT1_PIN == 0) {}
            if (rl1_status == 1)
                rl1_status = 0;
            else if (rl1_status == 0)
                rl1_status = 1;
        }
        else if (BUT2_PIN == 0)
        {
            while (BUT2_PIN == 0) {}
            if (rl2_status == 1)
                rl2_status = 0;
            else if (rl2_status == 0)
                rl2_status = 1;
        }  
        
        if (start_measure)
        {      
            //Binh thuong: <150, khoi: 150-300, khi gas: >300
            mq2_count++;
             
            mq2_adc = read_adc(0);
            
            if (max_mq2_adc < mq2_adc)
                max_mq2_adc = mq2_adc;
                
            if (mq2_count >= 30)
            {
                mq2_count = 0;
                if (max_mq2_adc < 150)
                {
                    mq2_detected = 0;
                    lcd_gotoxy(12,0);
                    lcd_puts("Norm");
                }
                else if (((max_mq2_adc >= 150) && (max_mq2_adc < 300)) && (mq2_detected == 0))
                { 
                    mq2_detected = 1;
                    lcd_gotoxy(12,0);
                    lcd_puts("Khoi");
                    if ((rl3_enable) && (mq2_sms_sent_count == 0))
                    {            
                        rl3_status = 1;
                        sprintf(send_msg, "Canh bao khoi");
                        SIM800A_sendSMS(send_tel_number, send_msg);
                        mq2_sms_sent_count++;
                    }
                }
                else if ((max_mq2_adc >= 300) && (mq2_detected == 0))
                { 
                    mq2_detected = 2;
                    lcd_gotoxy(12,0);
                    lcd_puts("Gas ");
                    if ((rl3_enable) && (mq2_sms_sent_count == 0))
                    {      
                        rl3_status = 1;
                        sprintf(send_msg, "Canh bao gas");
                        SIM800A_sendSMS(send_tel_number, send_msg);
                        mq2_sms_sent_count++;
                    }    
                }
                max_mq2_adc = 0;         
            }         
            
            //Khong co vat can - 1, co vat can - 0
            if (IR_PIN == 1)
            {
                ir_status = 0;
            }
            else 
            {
                ir_status = 1;
            }
            
            start_measure = 0;
        }
                  
        lcd_gotoxy(0,0);
        lcd_puts("Qt  Den Gio");
                
        if (rl1_status == 0)
        {
            lcd_gotoxy(0,1);
            lcd_puts("OFF");
            RL1_PIN = 0;
        }
        else if (rl1_status == 1)
        {
            lcd_gotoxy(0,1);
            lcd_puts("ON ");
            RL1_PIN = 1;
        }
        
        if (rl2_status == 0)
        {
            lcd_gotoxy(4,1);
            lcd_puts("OFF");
            RL2_PIN = 0;
        }
        else if (rl2_status == 1)
        {
            lcd_gotoxy(4,1);
            lcd_puts("ON ");
            RL2_PIN = 1;
        }
        
        if (rl3_status == 0)
        {
            lcd_gotoxy(8,1);
            lcd_puts("OFF");
            RL3_PIN = 0;
        }
        else if (rl3_status == 1)
        {
            lcd_gotoxy(8,1);
            lcd_puts("ON ");
            RL3_PIN = 1;
        }
        
        if ((ir_status == 1) && (ir_sms_sent_count == 0) && buzz_enable)
        {
            buzz_status = 1;
            sprintf(send_msg, "Co trom!");
            SIM800A_sendSMS(send_tel_number, send_msg);
            ir_sms_sent_count++; 
        }
        
        if (buzz_status == 0)
        {
            BUZZ_PIN = 0;
            lcd_gotoxy(12,1);
            lcd_puts("    ");
        }
        else if (buzz_status == 1)
        {
            BUZZ_PIN = 1;
            lcd_gotoxy(12,1);
            lcd_puts("Buzz");
        }        
    }
}
