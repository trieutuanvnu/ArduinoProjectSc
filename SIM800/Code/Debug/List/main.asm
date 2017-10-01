
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16L
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16L
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rcvdCheck=R5
	.DEF _rcvdConf=R4
	.DEF _rcvdEnd=R7
	.DEF _max_mq2_adc=R8
	.DEF _max_mq2_adc_msb=R9
	.DEF _mq2_adc=R10
	.DEF _mq2_adc_msb=R11
	.DEF _ir_status=R6
	.DEF _mq2_detected=R13
	.DEF _start_measure=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_comma:
	.DB  0x2C,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x2B,0x38,0x34,0x31,0x36,0x36,0x35,0x36
	.DB  0x33,0x34,0x31,0x37,0x36
_0x4:
	.DB  0x1
_0x5:
	.DB  0x1
_0x6:
	.DB  0x71,0x75,0x61,0x74
_0x7:
	.DB  0x64,0x65,0x6E
_0x8:
	.DB  0x67,0x69,0x6F
_0x9:
	.DB  0x63,0x6F,0x69
_0xA:
	.DB  0x6F,0x6E
_0xB:
	.DB  0x6F,0x66,0x66
_0xC:
	.DB  0x65,0x6E
_0xD:
	.DB  0x64,0x69,0x73
_0x0:
	.DB  0x41,0x54,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x47,0x46,0x3D,0x31,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x43,0x4E,0x4D,0x49
	.DB  0x3D,0x31,0x2C,0x32,0x2C,0x30,0x2C,0x30
	.DB  0x2C,0x30,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x47,0x53,0x3D,0x22,0x25,0x73
	.DB  0x22,0xD,0xA,0x0,0x25,0x73,0x0,0x44
	.DB  0x2E,0x4B,0x48,0x49,0x45,0x4E,0x20,0x54
	.DB  0x48,0x49,0x45,0x54,0x20,0x42,0x49,0x0
	.DB  0x20,0x20,0x20,0x20,0x53,0x49,0x4D,0x38
	.DB  0x30,0x30,0x41,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x49,0x6E,0x69,0x74,0x69,0x61,0x6C
	.DB  0x69,0x7A,0x69,0x6E,0x67,0x2E,0x2E,0x2E
	.DB  0x0,0x43,0x6F,0x6E,0x66,0x69,0x67,0x75
	.DB  0x72,0x69,0x6E,0x67,0x0,0x53,0x49,0x4D
	.DB  0x38,0x30,0x30,0x41,0x2E,0x2E,0x2E,0x0
	.DB  0x44,0x6F,0x6E,0x65,0x0,0x4E,0x6F,0x72
	.DB  0x6D,0x0,0x4B,0x68,0x6F,0x69,0x0,0x43
	.DB  0x61,0x6E,0x68,0x20,0x62,0x61,0x6F,0x20
	.DB  0x6B,0x68,0x6F,0x69,0x0,0x47,0x61,0x73
	.DB  0x20,0x0,0x43,0x61,0x6E,0x68,0x20,0x62
	.DB  0x61,0x6F,0x20,0x67,0x61,0x73,0x0,0x51
	.DB  0x74,0x20,0x20,0x44,0x65,0x6E,0x20,0x47
	.DB  0x69,0x6F,0x0,0x4F,0x46,0x46,0x0,0x4F
	.DB  0x4E,0x20,0x0,0x43,0x6F,0x20,0x74,0x72
	.DB  0x6F,0x6D,0x21,0x0,0x42,0x75,0x7A,0x7A
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0D
	.DW  _send_tel_number
	.DW  _0x3*2

	.DW  0x01
	.DW  _rl3_enable
	.DW  _0x4*2

	.DW  0x01
	.DW  _buzz_enable
	.DW  _0x5*2

	.DW  0x04
	.DW  _rl1_str
	.DW  _0x6*2

	.DW  0x03
	.DW  _rl2_str
	.DW  _0x7*2

	.DW  0x03
	.DW  _rl3_str
	.DW  _0x8*2

	.DW  0x03
	.DW  _buzz_str
	.DW  _0x9*2

	.DW  0x02
	.DW  _on_str
	.DW  _0xA*2

	.DW  0x03
	.DW  _off_str
	.DW  _0xB*2

	.DW  0x02
	.DW  _en_str
	.DW  _0xC*2

	.DW  0x03
	.DW  _dis_str
	.DW  _0xD*2

	.DW  0x11
	.DW  _0x7A
	.DW  _0x0*2+55

	.DW  0x11
	.DW  _0x7A+17
	.DW  _0x0*2+72

	.DW  0x10
	.DW  _0x7A+34
	.DW  _0x0*2+89

	.DW  0x0C
	.DW  _0x7A+50
	.DW  _0x0*2+105

	.DW  0x0B
	.DW  _0x7A+62
	.DW  _0x0*2+117

	.DW  0x05
	.DW  _0x7A+73
	.DW  _0x0*2+128

	.DW  0x05
	.DW  _0x7A+78
	.DW  _0x0*2+133

	.DW  0x05
	.DW  _0x7A+83
	.DW  _0x0*2+138

	.DW  0x05
	.DW  _0x7A+88
	.DW  _0x0*2+157

	.DW  0x0C
	.DW  _0x7A+93
	.DW  _0x0*2+175

	.DW  0x04
	.DW  _0x7A+105
	.DW  _0x0*2+187

	.DW  0x04
	.DW  _0x7A+109
	.DW  _0x0*2+191

	.DW  0x04
	.DW  _0x7A+113
	.DW  _0x0*2+187

	.DW  0x04
	.DW  _0x7A+117
	.DW  _0x0*2+191

	.DW  0x04
	.DW  _0x7A+121
	.DW  _0x0*2+187

	.DW  0x04
	.DW  _0x7A+125
	.DW  _0x0*2+191

	.DW  0x05
	.DW  _0x7A+129
	.DW  _0x0*2+84

	.DW  0x05
	.DW  _0x7A+134
	.DW  _0x0*2+204

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/20/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16L
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <string.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;unsigned char send_tel_number[] = "+841665634176";

	.DSEG
;unsigned char send_msg[30];
;unsigned char rcvdCheck = 0;
;unsigned char rcvdConf = 0;
;unsigned char rcvdEnd = 0;
;unsigned char rcvd_tel_number[15];
;unsigned char rcvd_msg[50];
;
;unsigned int  max_mq2_adc = 0;
;unsigned int  mq2_adc;
;unsigned char ir_status;
;unsigned char mq2_detected = 0;
;unsigned char start_measure = 0;
;unsigned char mq2_count = 0;
;unsigned char timer1_count = 0;
;
;unsigned char rl1_status = 0;
;unsigned char rl2_status = 0;
;unsigned char rl3_status = 0;
;unsigned char buzz_status = 0;
;unsigned char rl3_enable = 1;
;unsigned char buzz_enable = 1;
;
;unsigned char rl1_str[] = "quat";
;unsigned char rl2_str[] = "den";
;unsigned char rl3_str[] = "gio";
;unsigned char buzz_str[] = "coi";
;
;unsigned char on_str[] = "on";
;unsigned char off_str[] = "off";
;unsigned char en_str[] = "en";
;unsigned char dis_str[] = "dis";
;flash unsigned char comma[] = ",";
;
;unsigned int mq2_sms_sent_count = 0;
;unsigned int ir_sms_sent_count = 0;
;
;#define RL1_PIN     PORTD.6
;#define RL2_PIN     PORTD.5
;#define RL3_PIN     PORTD.7
;#define BUZZ_PIN    PORTC.0
;
;#define IR_PIN      PINB.0
;
;#define BUT1_PIN    PIND.2
;#define BUT2_PIN    PIND.3
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 100
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;
;void SIM800A_SMSsetup()
; 0000 006E {

	.CSEG
_SIM800A_SMSsetup:
; .FSTART _SIM800A_SMSsetup
; 0000 006F     printf("AT\r\n");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x0
; 0000 0070     delay_ms(1000);
; 0000 0071     printf("AT+CMGF=1\r\n");
	__POINTW1FN _0x0,5
	CALL SUBOPT_0x0
; 0000 0072     delay_ms(1000);
; 0000 0073     printf("AT+CNMI=1,2,0,0,0\r\n");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x0
; 0000 0074     delay_ms(1000);
; 0000 0075 }
	RET
; .FEND
;
;
;void SIM800A_sendSMS(unsigned char* tel_number, unsigned char* msg)
; 0000 0079 {
_SIM800A_sendSMS:
; .FSTART _SIM800A_sendSMS
; 0000 007A     printf("AT+CMGS=\"%s\"\r\n", tel_number);
	ST   -Y,R27
	ST   -Y,R26
;	*tel_number -> Y+2
;	*msg -> Y+0
	__POINTW1FN _0x0,37
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x1
; 0000 007B     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 007C     printf("%s", msg);
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x1
; 0000 007D     putchar(26);
	LDI  R26,LOW(26)
	CALL _putchar
; 0000 007E }
	JMP  _0x2080006
; .FEND
;
;
;unsigned char hasString(char *str, char *sub)
; 0000 0082 {
_hasString:
; .FSTART _hasString
; 0000 0083    char *p;
; 0000 0084    p = strstr(str, sub);
	CALL SUBOPT_0x2
;	*str -> Y+4
;	*sub -> Y+2
;	*p -> R16,R17
	CALL SUBOPT_0x3
	CALL _strstr
	MOVW R16,R30
; 0000 0085    if (p)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0xE
; 0000 0086       return 1;
	LDI  R30,LOW(1)
	RJMP _0x2080008
; 0000 0087    else
_0xE:
; 0000 0088       return 0;
	LDI  R30,LOW(0)
; 0000 0089 }
_0x2080008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; .FEND
;
;
;void clearBuffer()
; 0000 008D {
_clearBuffer:
; .FSTART _clearBuffer
; 0000 008E     unsigned char i;
; 0000 008F 
; 0000 0090     for (i = 0; i < RX_BUFFER_SIZE; i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x11:
	CPI  R17,100
	BRSH _0x12
; 0000 0091     {
; 0000 0092         rx_buffer[i] = '\0';
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0093     }
	SUBI R17,-1
	RJMP _0x11
_0x12:
; 0000 0094     rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0095     for (i = 0; i < 15; i++)
	LDI  R17,LOW(0)
_0x14:
	CPI  R17,15
	BRSH _0x15
; 0000 0096     {
; 0000 0097         rcvd_tel_number[i] = '\0';
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rcvd_tel_number)
	SBCI R31,HIGH(-_rcvd_tel_number)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0098     }
	SUBI R17,-1
	RJMP _0x14
_0x15:
; 0000 0099     for (i = 0; i < 30; i++)
	LDI  R17,LOW(0)
_0x17:
	CPI  R17,30
	BRSH _0x18
; 0000 009A     {
; 0000 009B         rcvd_msg[i] = '\0';
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rcvd_msg)
	SBCI R31,HIGH(-_rcvd_msg)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 009C     }
	SUBI R17,-1
	RJMP _0x17
_0x18:
; 0000 009D }
	LD   R17,Y+
	RET
; .FEND
;
;
;void bufferExecute()
; 0000 00A1 {
_bufferExecute:
; .FSTART _bufferExecute
; 0000 00A2     unsigned int i;
; 0000 00A3     unsigned char index = 0;
; 0000 00A4 
; 0000 00A5     unsigned char* token;
; 0000 00A6 
; 0000 00A7     for (i = 4; i < 17; i++)
	CALL __SAVELOCR6
;	i -> R16,R17
;	index -> R19
;	*token -> R20,R21
	LDI  R19,0
	__GETWRN 16,17,4
_0x1A:
	__CPWRN 16,17,17
	BRSH _0x1B
; 0000 00A8     {
; 0000 00A9         rcvd_tel_number[index++] = rx_buffer[i];
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	SUBI R30,LOW(-_rcvd_tel_number)
	SBCI R31,HIGH(-_rcvd_tel_number)
	CALL SUBOPT_0x4
; 0000 00AA     }
	__ADDWRN 16,17,1
	RJMP _0x1A
_0x1B:
; 0000 00AB     index = 0;
	LDI  R19,LOW(0)
; 0000 00AC     for (i = 46; i < rx_wr_index - 2; i++)
	__GETWRN 16,17,46
_0x1D:
	LDS  R30,_rx_wr_index
	LDI  R31,0
	SBIW R30,2
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x1E
; 0000 00AD     {
; 0000 00AE         rcvd_msg[index++] = rx_buffer[i];
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	SUBI R30,LOW(-_rcvd_msg)
	SBCI R31,HIGH(-_rcvd_msg)
	CALL SUBOPT_0x4
; 0000 00AF     }
	__ADDWRN 16,17,1
	RJMP _0x1D
_0x1E:
; 0000 00B0 
; 0000 00B1     //Doi tu chu hoa sang chu thuong
; 0000 00B2     for (i = 0; i < index; i++)
	__GETWRN 16,17,0
_0x20:
	MOV  R30,R19
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x21
; 0000 00B3     {
; 0000 00B4         if ((rcvd_msg[i] >= 'A') && (rcvd_msg[i] <= 'Z'))
	LDI  R26,LOW(_rcvd_msg)
	LDI  R27,HIGH(_rcvd_msg)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x41)
	BRLO _0x23
	LDI  R26,LOW(_rcvd_msg)
	LDI  R27,HIGH(_rcvd_msg)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x5B)
	BRLO _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00B5             rcvd_msg[i] += 32;
	MOVW R26,R16
	SUBI R26,LOW(-_rcvd_msg)
	SBCI R27,HIGH(-_rcvd_msg)
	LD   R30,X
	SUBI R30,-LOW(32)
	ST   X,R30
; 0000 00B6     }
_0x22:
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 00B7 
; 0000 00B8     token = strtok(rcvd_msg, comma);
	LDI  R30,LOW(_rcvd_msg)
	LDI  R31,HIGH(_rcvd_msg)
	CALL SUBOPT_0x5
; 0000 00B9     while (token != NULL)
_0x25:
	MOV  R0,R20
	OR   R0,R21
	BRNE PC+2
	RJMP _0x27
; 0000 00BA     {
; 0000 00BB         if (hasString(token, rl1_str) && hasString(token, on_str))
	CALL SUBOPT_0x6
	BREQ _0x29
	CALL SUBOPT_0x7
	BRNE _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 00BC         {
; 0000 00BD             rl1_status = 1;
	LDI  R30,LOW(1)
	STS  _rl1_status,R30
; 0000 00BE         }
; 0000 00BF         else if (hasString(token, rl1_str) && hasString(token, off_str))
	RJMP _0x2B
_0x28:
	CALL SUBOPT_0x6
	BREQ _0x2D
	CALL SUBOPT_0x8
	BRNE _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
; 0000 00C0         {
; 0000 00C1             rl1_status = 0;
	LDI  R30,LOW(0)
	STS  _rl1_status,R30
; 0000 00C2         }
; 0000 00C3         else if (hasString(token, rl2_str) && hasString(token, on_str))
	RJMP _0x2F
_0x2C:
	CALL SUBOPT_0x9
	BREQ _0x31
	CALL SUBOPT_0x7
	BRNE _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 00C4         {
; 0000 00C5             rl2_status = 1;
	LDI  R30,LOW(1)
	STS  _rl2_status,R30
; 0000 00C6         }
; 0000 00C7         else if (hasString(token, rl2_str) && hasString(token, off_str))
	RJMP _0x33
_0x30:
	CALL SUBOPT_0x9
	BREQ _0x35
	CALL SUBOPT_0x8
	BRNE _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 00C8         {
; 0000 00C9             rl2_status = 0;
	LDI  R30,LOW(0)
	STS  _rl2_status,R30
; 0000 00CA         }
; 0000 00CB         else if (hasString(token, rl3_str) && hasString(token, on_str))
	RJMP _0x37
_0x34:
	CALL SUBOPT_0xA
	BREQ _0x39
	CALL SUBOPT_0x7
	BRNE _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 00CC         {
; 0000 00CD             rl3_status = 1;
	LDI  R30,LOW(1)
	STS  _rl3_status,R30
; 0000 00CE         }
; 0000 00CF         else if (hasString(token, rl3_str) && hasString(token, off_str))
	RJMP _0x3B
_0x38:
	CALL SUBOPT_0xA
	BREQ _0x3D
	CALL SUBOPT_0x8
	BRNE _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 00D0         {
; 0000 00D1             rl3_status = 0;
	LDI  R30,LOW(0)
	STS  _rl3_status,R30
; 0000 00D2         }
; 0000 00D3         else if (hasString(token, rl3_str) && hasString(token, dis_str))
	RJMP _0x3F
_0x3C:
	CALL SUBOPT_0xA
	BREQ _0x41
	CALL SUBOPT_0xB
	BRNE _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 00D4         {
; 0000 00D5             rl3_enable = 0;
	LDI  R30,LOW(0)
	STS  _rl3_enable,R30
; 0000 00D6             rl3_status = 0;
	STS  _rl3_status,R30
; 0000 00D7         }
; 0000 00D8         else if (hasString(token, rl3_str) && hasString(token, en_str))
	RJMP _0x43
_0x40:
	CALL SUBOPT_0xA
	BREQ _0x45
	CALL SUBOPT_0xC
	BRNE _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 00D9         {
; 0000 00DA             rl3_enable = 1;
	LDI  R30,LOW(1)
	STS  _rl3_enable,R30
; 0000 00DB         }
; 0000 00DC         else if (hasString(token, buzz_str) && hasString(token, on_str))
	RJMP _0x47
_0x44:
	CALL SUBOPT_0xD
	BREQ _0x49
	CALL SUBOPT_0x7
	BRNE _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 00DD         {
; 0000 00DE             buzz_status = 1;
	LDI  R30,LOW(1)
	STS  _buzz_status,R30
; 0000 00DF         }
; 0000 00E0         else if (hasString(token, buzz_str) && hasString(token, off_str))
	RJMP _0x4B
_0x48:
	CALL SUBOPT_0xD
	BREQ _0x4D
	CALL SUBOPT_0x8
	BRNE _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00E1         {
; 0000 00E2             buzz_status = 0;
	LDI  R30,LOW(0)
	STS  _buzz_status,R30
; 0000 00E3         }
; 0000 00E4         else if (hasString(token, buzz_str) && hasString(token, dis_str))
	RJMP _0x4F
_0x4C:
	CALL SUBOPT_0xD
	BREQ _0x51
	CALL SUBOPT_0xB
	BRNE _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00E5         {
; 0000 00E6             buzz_enable = 0;
	LDI  R30,LOW(0)
	STS  _buzz_enable,R30
; 0000 00E7             buzz_status = 0;
	STS  _buzz_status,R30
; 0000 00E8         }
; 0000 00E9         else if (hasString(token, buzz_str) && hasString(token, en_str))
	RJMP _0x53
_0x50:
	CALL SUBOPT_0xD
	BREQ _0x55
	CALL SUBOPT_0xC
	BRNE _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 00EA         {
; 0000 00EB             buzz_enable = 1;
	LDI  R30,LOW(1)
	STS  _buzz_enable,R30
; 0000 00EC         }
; 0000 00ED 
; 0000 00EE         token = strtok(NULL, comma);
_0x54:
_0x53:
_0x4F:
_0x4B:
_0x47:
_0x43:
_0x3F:
_0x3B:
_0x37:
_0x33:
_0x2F:
_0x2B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x5
; 0000 00EF     }
	RJMP _0x25
_0x27:
; 0000 00F0 
; 0000 00F1     clearBuffer();
	RCALL _clearBuffer
; 0000 00F2 }
	CALL __LOADLOCR6
	JMP  _0x2080004
; .FEND
;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 00F7 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00F8     char status,data;
; 0000 00F9     status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 00FA     data=UDR;
	IN   R16,12
; 0000 00FB     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x57
; 0000 00FC     {
; 0000 00FD         if ((data == '+') && (rcvdCheck == 0))
	CPI  R16,43
	BRNE _0x59
	TST  R5
	BREQ _0x5A
_0x59:
	RJMP _0x58
_0x5A:
; 0000 00FE             rcvdCheck = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00FF         else if ((data == 'C') && (rcvdCheck == 1))
	RJMP _0x5B
_0x58:
	CPI  R16,67
	BRNE _0x5D
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x5E
_0x5D:
	RJMP _0x5C
_0x5E:
; 0000 0100             rcvdCheck = 2;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0101         else if ((data == 'M') && (rcvdCheck == 2))
	RJMP _0x5F
_0x5C:
	CPI  R16,77
	BRNE _0x61
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0102             rcvdCheck = 3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0103         else if ((data == 'T') && (rcvdCheck == 3))
	RJMP _0x63
_0x60:
	CPI  R16,84
	BRNE _0x65
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x66
_0x65:
	RJMP _0x64
_0x66:
; 0000 0104             rcvdCheck = 4;
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 0105         else
	RJMP _0x67
_0x64:
; 0000 0106             rcvdCheck = 0;
	CLR  R5
; 0000 0107 
; 0000 0108         if (rcvdCheck == 4)
_0x67:
_0x63:
_0x5F:
_0x5B:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x68
; 0000 0109         {
; 0000 010A             rx_wr_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 010B             rcvdConf = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 010C             rcvdCheck = 0;
	CLR  R5
; 0000 010D         }
; 0000 010E 
; 0000 010F         if (rcvdConf == 1)
_0x68:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x69
; 0000 0110         {
; 0000 0111             rx_buffer[rx_wr_index++] = data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0112 
; 0000 0113             if (data == '\n')
	CPI  R16,10
	BRNE _0x6A
; 0000 0114                 rcvdEnd++;
	INC  R7
; 0000 0115 
; 0000 0116             if (rcvdEnd == 2)
_0x6A:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x6B
; 0000 0117             {
; 0000 0118                 rcvdConf = 0;
	CLR  R4
; 0000 0119                 rcvdEnd = 0;
	CLR  R7
; 0000 011A                 bufferExecute();
	RCALL _bufferExecute
; 0000 011B             }
; 0000 011C         }
_0x6B:
; 0000 011D 
; 0000 011E 
; 0000 011F         #if RX_BUFFER_SIZE == 256
; 0000 0120         // special case for receiver buffer size=256
; 0000 0121         if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0122         #else
; 0000 0123         if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
_0x69:
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x64)
	BRNE _0x6C
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0124         if (++rx_counter == RX_BUFFER_SIZE)
_0x6C:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x64)
	BRNE _0x6D
; 0000 0125         {
; 0000 0126             rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 0127             rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0128         }
; 0000 0129     #endif
; 0000 012A     }
_0x6D:
; 0000 012B }
_0x57:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0132 {
; 0000 0133     char data;
; 0000 0134     while (rx_counter==0);
;	data -> R17
; 0000 0135     data=rx_buffer[rx_rd_index++];
; 0000 0136     #if RX_BUFFER_SIZE != 256
; 0000 0137     if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0138     #endif
; 0000 0139     #asm("cli")
; 0000 013A     --rx_counter;
; 0000 013B     #asm("sei")
; 0000 013C     return data;
; 0000 013D }
;#pragma used-
;#endif
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0143 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0144     // Reinitialize Timer1 value
; 0000 0145     TCNT1H=0xCA00 >> 8;
	LDI  R30,LOW(202)
	OUT  0x2D,R30
; 0000 0146     TCNT1L=0xCA00 & 0xff;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 0147     // Place your code here
; 0000 0148     timer1_count++;
	LDS  R30,_timer1_count
	SUBI R30,-LOW(1)
	STS  _timer1_count,R30
; 0000 0149     if (timer1_count >= 7)
	LDS  R26,_timer1_count
	CPI  R26,LOW(0x7)
	BRLO _0x72
; 0000 014A     {
; 0000 014B         timer1_count = 0;
	LDI  R30,LOW(0)
	STS  _timer1_count,R30
; 0000 014C         start_measure = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 014D     }
; 0000 014E     if (mq2_sms_sent_count != 0)
_0x72:
	LDS  R30,_mq2_sms_sent_count
	LDS  R31,_mq2_sms_sent_count+1
	SBIW R30,0
	BREQ _0x73
; 0000 014F     {
; 0000 0150         mq2_sms_sent_count++;
	CALL SUBOPT_0xE
; 0000 0151         if (mq2_sms_sent_count >= 6000)
	CALL SUBOPT_0xF
	CPI  R26,LOW(0x1770)
	LDI  R30,HIGH(0x1770)
	CPC  R27,R30
	BRLO _0x74
; 0000 0152             mq2_sms_sent_count = 0;
	LDI  R30,LOW(0)
	STS  _mq2_sms_sent_count,R30
	STS  _mq2_sms_sent_count+1,R30
; 0000 0153     }
_0x74:
; 0000 0154     if (ir_sms_sent_count != 0)
_0x73:
	LDS  R30,_ir_sms_sent_count
	LDS  R31,_ir_sms_sent_count+1
	SBIW R30,0
	BREQ _0x75
; 0000 0155     {
; 0000 0156         ir_sms_sent_count++;
	CALL SUBOPT_0x10
; 0000 0157         if (ir_sms_sent_count >= 6000)
	LDS  R26,_ir_sms_sent_count
	LDS  R27,_ir_sms_sent_count+1
	CPI  R26,LOW(0x1770)
	LDI  R30,HIGH(0x1770)
	CPC  R27,R30
	BRLO _0x76
; 0000 0158             ir_sms_sent_count = 0;
	LDI  R30,LOW(0)
	STS  _ir_sms_sent_count,R30
	STS  _ir_sms_sent_count+1,R30
; 0000 0159     }
_0x76:
; 0000 015A }
_0x75:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0161 {
_read_adc:
; .FSTART _read_adc
; 0000 0162     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0163     // Delay needed for the stabilization of the ADC input voltage
; 0000 0164     delay_us(10);
	__DELAY_USB 37
; 0000 0165     // Start the AD conversion
; 0000 0166     ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0167     // Wait for the AD conversion to complete
; 0000 0168     while ((ADCSRA & (1<<ADIF))==0);
_0x77:
	SBIS 0x6,4
	RJMP _0x77
; 0000 0169     ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 016A     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2080001
; 0000 016B }
; .FEND
;
;
;void main(void)
; 0000 016F {
_main:
; .FSTART _main
; 0000 0170     // Declare your local variables here
; 0000 0171 
; 0000 0172     // Input/Output Ports initialization
; 0000 0173     // Port A initialization
; 0000 0174     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0175     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0176     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0177     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0178 
; 0000 0179     // Port B initialization
; 0000 017A     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 017B     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 017C     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 017D     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 017E 
; 0000 017F     // Port C initialization
; 0000 0180     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0181     DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0182     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0183     PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0184 
; 0000 0185     // Port D initialization
; 0000 0186     // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0187     DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(224)
	OUT  0x11,R30
; 0000 0188     // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0189     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 018A 
; 0000 018B     // Timer/Counter 0 initialization
; 0000 018C     // Clock source: System Clock
; 0000 018D     // Clock value: Timer 0 Stopped
; 0000 018E     // Mode: Normal top=0xFF
; 0000 018F     // OC0 output: Disconnected
; 0000 0190     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0191     TCNT0=0x00;
	OUT  0x32,R30
; 0000 0192     OCR0=0x00;
	OUT  0x3C,R30
; 0000 0193 
; 0000 0194     // Timer/Counter 1 initialization
; 0000 0195     // Clock source: System Clock
; 0000 0196     // Clock value: 1382.400 kHz
; 0000 0197     // Mode: Normal top=0xFFFF
; 0000 0198     // OC1A output: Disconnected
; 0000 0199     // OC1B output: Disconnected
; 0000 019A     // Noise Canceler: Off
; 0000 019B     // Input Capture on Falling Edge
; 0000 019C     // Timer Period: 10 ms
; 0000 019D     // Timer1 Overflow Interrupt: On
; 0000 019E     // Input Capture Interrupt: Off
; 0000 019F     // Compare A Match Interrupt: Off
; 0000 01A0     // Compare B Match Interrupt: Off
; 0000 01A1     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 01A2     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 01A3     TCNT1H=0xCA;
	LDI  R30,LOW(202)
	OUT  0x2D,R30
; 0000 01A4     TCNT1L=0x00;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 01A5     ICR1H=0x00;
	OUT  0x27,R30
; 0000 01A6     ICR1L=0x00;
	OUT  0x26,R30
; 0000 01A7     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01A8     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01A9     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01AA     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01AB 
; 0000 01AC     // Timer/Counter 2 initialization
; 0000 01AD     // Clock source: System Clock
; 0000 01AE     // Clock value: Timer2 Stopped
; 0000 01AF     // Mode: Normal top=0xFF
; 0000 01B0     // OC2 output: Disconnected
; 0000 01B1     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 01B2     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 01B3     TCNT2=0x00;
	OUT  0x24,R30
; 0000 01B4     OCR2=0x00;
	OUT  0x23,R30
; 0000 01B5 
; 0000 01B6     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01B7     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 01B8 
; 0000 01B9     // External Interrupt(s) initialization
; 0000 01BA     // INT0: Off
; 0000 01BB     // INT1: Off
; 0000 01BC     // INT2: Off
; 0000 01BD     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 01BE     MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 01BF 
; 0000 01C0     // USART initialization
; 0000 01C1     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01C2     // USART Receiver: On
; 0000 01C3     // USART Transmitter: On
; 0000 01C4     // USART Mode: Asynchronous
; 0000 01C5     // USART Baud Rate: 9600
; 0000 01C6     UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 01C7     UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 01C8     UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01C9     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01CA     UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 01CB 
; 0000 01CC     // Analog Comparator initialization
; 0000 01CD     // Analog Comparator: Off
; 0000 01CE     // The Analog Comparator's positive input is
; 0000 01CF     // connected to the AIN0 pin
; 0000 01D0     // The Analog Comparator's negative input is
; 0000 01D1     // connected to the AIN1 pin
; 0000 01D2     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01D3 
; 0000 01D4     // ADC initialization
; 0000 01D5     // ADC Clock frequency: 691.200 kHz
; 0000 01D6     // ADC Voltage Reference: AREF pin
; 0000 01D7     // ADC Auto Trigger Source: ADC Stopped
; 0000 01D8     ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 01D9     ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 01DA     SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01DB 
; 0000 01DC     // SPI initialization
; 0000 01DD     // SPI disabled
; 0000 01DE     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 01DF 
; 0000 01E0     // TWI initialization
; 0000 01E1     // TWI disabled
; 0000 01E2     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 01E3 
; 0000 01E4     // Alphanumeric LCD initialization
; 0000 01E5     // Connections are specified in the
; 0000 01E6     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 01E7     // RS - PORTC Bit 7
; 0000 01E8     // RD - PORTC Bit 6
; 0000 01E9     // EN - PORTC Bit 5
; 0000 01EA     // D4 - PORTC Bit 4
; 0000 01EB     // D5 - PORTC Bit 3
; 0000 01EC     // D6 - PORTC Bit 2
; 0000 01ED     // D7 - PORTC Bit 1
; 0000 01EE     // Characters/line: 16
; 0000 01EF     lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 01F0 
; 0000 01F1     // Global enable interrupts
; 0000 01F2     #asm("sei")
	sei
; 0000 01F3 
; 0000 01F4     lcd_gotoxy(0,0);
	CALL SUBOPT_0x11
; 0000 01F5     lcd_puts("D.KHIEN THIET BI");
	__POINTW2MN _0x7A,0
	CALL SUBOPT_0x12
; 0000 01F6     lcd_gotoxy(0,1);
; 0000 01F7     lcd_puts("    SIM800A     ");
	__POINTW2MN _0x7A,17
	CALL _lcd_puts
; 0000 01F8     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL SUBOPT_0x13
; 0000 01F9     lcd_clear();
; 0000 01FA     lcd_gotoxy(0,0);
; 0000 01FB     lcd_puts("Initializing...");
	__POINTW2MN _0x7A,34
	CALL _lcd_puts
; 0000 01FC     delay_ms(15000);
	LDI  R26,LOW(15000)
	LDI  R27,HIGH(15000)
	CALL SUBOPT_0x13
; 0000 01FD     lcd_clear();
; 0000 01FE     lcd_gotoxy(0,0);
; 0000 01FF     lcd_puts("Configuring");
	__POINTW2MN _0x7A,50
	CALL SUBOPT_0x12
; 0000 0200     lcd_gotoxy(0,1);
; 0000 0201     lcd_puts("SIM800A...");
	__POINTW2MN _0x7A,62
	CALL _lcd_puts
; 0000 0202     SIM800A_SMSsetup();
	RCALL _SIM800A_SMSsetup
; 0000 0203     clearBuffer();
	RCALL _clearBuffer
; 0000 0204     lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x14
; 0000 0205     lcd_puts("Done");
	__POINTW2MN _0x7A,73
	CALL _lcd_puts
; 0000 0206     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0207     lcd_clear();
	CALL _lcd_clear
; 0000 0208 
; 0000 0209     while (1)
_0x7B:
; 0000 020A     {
; 0000 020B         // Place your code here
; 0000 020C 
; 0000 020D         if (BUT1_PIN == 0)
	SBIC 0x10,2
	RJMP _0x7E
; 0000 020E         {
; 0000 020F             while (BUT1_PIN == 0) {}
_0x7F:
	SBIS 0x10,2
	RJMP _0x7F
; 0000 0210             if (rl1_status == 1)
	LDS  R26,_rl1_status
	CPI  R26,LOW(0x1)
	BRNE _0x82
; 0000 0211                 rl1_status = 0;
	LDI  R30,LOW(0)
	RJMP _0xC3
; 0000 0212             else if (rl1_status == 0)
_0x82:
	LDS  R30,_rl1_status
	CPI  R30,0
	BRNE _0x84
; 0000 0213                 rl1_status = 1;
	LDI  R30,LOW(1)
_0xC3:
	STS  _rl1_status,R30
; 0000 0214         }
_0x84:
; 0000 0215         else if (BUT2_PIN == 0)
	RJMP _0x85
_0x7E:
	SBIC 0x10,3
	RJMP _0x86
; 0000 0216         {
; 0000 0217             while (BUT2_PIN == 0) {}
_0x87:
	SBIS 0x10,3
	RJMP _0x87
; 0000 0218             if (rl2_status == 1)
	LDS  R26,_rl2_status
	CPI  R26,LOW(0x1)
	BRNE _0x8A
; 0000 0219                 rl2_status = 0;
	LDI  R30,LOW(0)
	RJMP _0xC4
; 0000 021A             else if (rl2_status == 0)
_0x8A:
	LDS  R30,_rl2_status
	CPI  R30,0
	BRNE _0x8C
; 0000 021B                 rl2_status = 1;
	LDI  R30,LOW(1)
_0xC4:
	STS  _rl2_status,R30
; 0000 021C         }
_0x8C:
; 0000 021D 
; 0000 021E         if (start_measure)
_0x86:
_0x85:
	TST  R12
	BRNE PC+2
	RJMP _0x8D
; 0000 021F         {
; 0000 0220             //Binh thuong: <150, khoi: 150-300, khi gas: >300
; 0000 0221             mq2_count++;
	LDS  R30,_mq2_count
	SUBI R30,-LOW(1)
	STS  _mq2_count,R30
; 0000 0222 
; 0000 0223             mq2_adc = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R10,R30
; 0000 0224 
; 0000 0225             if (max_mq2_adc < mq2_adc)
	__CPWRR 8,9,10,11
	BRSH _0x8E
; 0000 0226                 max_mq2_adc = mq2_adc;
	MOVW R8,R10
; 0000 0227 
; 0000 0228             if (mq2_count >= 30)
_0x8E:
	LDS  R26,_mq2_count
	CPI  R26,LOW(0x1E)
	BRSH PC+2
	RJMP _0x8F
; 0000 0229             {
; 0000 022A                 mq2_count = 0;
	LDI  R30,LOW(0)
	STS  _mq2_count,R30
; 0000 022B                 if (max_mq2_adc < 150)
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R8,R30
	CPC  R9,R31
	BRSH _0x90
; 0000 022C                 {
; 0000 022D                     mq2_detected = 0;
	CLR  R13
; 0000 022E                     lcd_gotoxy(12,0);
	CALL SUBOPT_0x15
; 0000 022F                     lcd_puts("Norm");
	__POINTW2MN _0x7A,78
	CALL _lcd_puts
; 0000 0230                 }
; 0000 0231                 else if (((max_mq2_adc >= 150) && (max_mq2_adc < 300)) && (mq2_detected == 0))
	RJMP _0x91
_0x90:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x93
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x94
_0x93:
	RJMP _0x95
_0x94:
	TST  R13
	BREQ _0x96
_0x95:
	RJMP _0x92
_0x96:
; 0000 0232                 {
; 0000 0233                     mq2_detected = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0234                     lcd_gotoxy(12,0);
	CALL SUBOPT_0x15
; 0000 0235                     lcd_puts("Khoi");
	__POINTW2MN _0x7A,83
	CALL _lcd_puts
; 0000 0236                     if ((rl3_enable) && (mq2_sms_sent_count == 0))
	LDS  R30,_rl3_enable
	CPI  R30,0
	BREQ _0x98
	CALL SUBOPT_0xF
	SBIW R26,0
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
; 0000 0237                     {
; 0000 0238                         rl3_status = 1;
	CALL SUBOPT_0x16
; 0000 0239                         sprintf(send_msg, "Canh bao khoi");
	__POINTW1FN _0x0,143
	CALL SUBOPT_0x17
; 0000 023A                         SIM800A_sendSMS(send_tel_number, send_msg);
; 0000 023B                         mq2_sms_sent_count++;
; 0000 023C                     }
; 0000 023D                 }
_0x97:
; 0000 023E                 else if ((max_mq2_adc >= 300) && (mq2_detected == 0))
	RJMP _0x9A
_0x92:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x9C
	TST  R13
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 023F                 {
; 0000 0240                     mq2_detected = 2;
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 0241                     lcd_gotoxy(12,0);
	CALL SUBOPT_0x15
; 0000 0242                     lcd_puts("Gas ");
	__POINTW2MN _0x7A,88
	CALL _lcd_puts
; 0000 0243                     if ((rl3_enable) && (mq2_sms_sent_count == 0))
	LDS  R30,_rl3_enable
	CPI  R30,0
	BREQ _0x9F
	CALL SUBOPT_0xF
	SBIW R26,0
	BREQ _0xA0
_0x9F:
	RJMP _0x9E
_0xA0:
; 0000 0244                     {
; 0000 0245                         rl3_status = 1;
	CALL SUBOPT_0x16
; 0000 0246                         sprintf(send_msg, "Canh bao gas");
	__POINTW1FN _0x0,162
	CALL SUBOPT_0x17
; 0000 0247                         SIM800A_sendSMS(send_tel_number, send_msg);
; 0000 0248                         mq2_sms_sent_count++;
; 0000 0249                     }
; 0000 024A                 }
_0x9E:
; 0000 024B                 max_mq2_adc = 0;
_0x9B:
_0x9A:
_0x91:
	CLR  R8
	CLR  R9
; 0000 024C             }
; 0000 024D 
; 0000 024E             //Khong co vat can - 1, co vat can - 0
; 0000 024F             if (IR_PIN == 1)
_0x8F:
	SBIS 0x16,0
	RJMP _0xA1
; 0000 0250             {
; 0000 0251                 ir_status = 0;
	CLR  R6
; 0000 0252             }
; 0000 0253             else
	RJMP _0xA2
_0xA1:
; 0000 0254             {
; 0000 0255                 ir_status = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0256             }
_0xA2:
; 0000 0257 
; 0000 0258             start_measure = 0;
	CLR  R12
; 0000 0259         }
; 0000 025A 
; 0000 025B         lcd_gotoxy(0,0);
_0x8D:
	CALL SUBOPT_0x11
; 0000 025C         lcd_puts("Qt  Den Gio");
	__POINTW2MN _0x7A,93
	CALL _lcd_puts
; 0000 025D 
; 0000 025E         if (rl1_status == 0)
	LDS  R30,_rl1_status
	CPI  R30,0
	BRNE _0xA3
; 0000 025F         {
; 0000 0260             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
; 0000 0261             lcd_puts("OFF");
	__POINTW2MN _0x7A,105
	CALL _lcd_puts
; 0000 0262             RL1_PIN = 0;
	CBI  0x12,6
; 0000 0263         }
; 0000 0264         else if (rl1_status == 1)
	RJMP _0xA6
_0xA3:
	LDS  R26,_rl1_status
	CPI  R26,LOW(0x1)
	BRNE _0xA7
; 0000 0265         {
; 0000 0266             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
; 0000 0267             lcd_puts("ON ");
	__POINTW2MN _0x7A,109
	CALL _lcd_puts
; 0000 0268             RL1_PIN = 1;
	SBI  0x12,6
; 0000 0269         }
; 0000 026A 
; 0000 026B         if (rl2_status == 0)
_0xA7:
_0xA6:
	LDS  R30,_rl2_status
	CPI  R30,0
	BRNE _0xAA
; 0000 026C         {
; 0000 026D             lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x14
; 0000 026E             lcd_puts("OFF");
	__POINTW2MN _0x7A,113
	CALL _lcd_puts
; 0000 026F             RL2_PIN = 0;
	CBI  0x12,5
; 0000 0270         }
; 0000 0271         else if (rl2_status == 1)
	RJMP _0xAD
_0xAA:
	LDS  R26,_rl2_status
	CPI  R26,LOW(0x1)
	BRNE _0xAE
; 0000 0272         {
; 0000 0273             lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x14
; 0000 0274             lcd_puts("ON ");
	__POINTW2MN _0x7A,117
	CALL _lcd_puts
; 0000 0275             RL2_PIN = 1;
	SBI  0x12,5
; 0000 0276         }
; 0000 0277 
; 0000 0278         if (rl3_status == 0)
_0xAE:
_0xAD:
	LDS  R30,_rl3_status
	CPI  R30,0
	BRNE _0xB1
; 0000 0279         {
; 0000 027A             lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x14
; 0000 027B             lcd_puts("OFF");
	__POINTW2MN _0x7A,121
	CALL _lcd_puts
; 0000 027C             RL3_PIN = 0;
	CBI  0x12,7
; 0000 027D         }
; 0000 027E         else if (rl3_status == 1)
	RJMP _0xB4
_0xB1:
	LDS  R26,_rl3_status
	CPI  R26,LOW(0x1)
	BRNE _0xB5
; 0000 027F         {
; 0000 0280             lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x14
; 0000 0281             lcd_puts("ON ");
	__POINTW2MN _0x7A,125
	CALL _lcd_puts
; 0000 0282             RL3_PIN = 1;
	SBI  0x12,7
; 0000 0283         }
; 0000 0284 
; 0000 0285         if ((ir_status == 1) && (ir_sms_sent_count == 0) && buzz_enable)
_0xB5:
_0xB4:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0xB9
	LDS  R26,_ir_sms_sent_count
	LDS  R27,_ir_sms_sent_count+1
	SBIW R26,0
	BRNE _0xB9
	LDS  R30,_buzz_enable
	CPI  R30,0
	BRNE _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
; 0000 0286         {
; 0000 0287             buzz_status = 1;
	LDI  R30,LOW(1)
	STS  _buzz_status,R30
; 0000 0288             sprintf(send_msg, "Co trom!");
	LDI  R30,LOW(_send_msg)
	LDI  R31,HIGH(_send_msg)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,195
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
; 0000 0289             SIM800A_sendSMS(send_tel_number, send_msg);
	LDI  R30,LOW(_send_tel_number)
	LDI  R31,HIGH(_send_tel_number)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_send_msg)
	LDI  R27,HIGH(_send_msg)
	RCALL _SIM800A_sendSMS
; 0000 028A             ir_sms_sent_count++;
	CALL SUBOPT_0x10
; 0000 028B         }
; 0000 028C 
; 0000 028D         if (buzz_status == 0)
_0xB8:
	LDS  R30,_buzz_status
	CPI  R30,0
	BRNE _0xBB
; 0000 028E         {
; 0000 028F             BUZZ_PIN = 0;
	CBI  0x15,0
; 0000 0290             lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x14
; 0000 0291             lcd_puts("    ");
	__POINTW2MN _0x7A,129
	RJMP _0xC5
; 0000 0292         }
; 0000 0293         else if (buzz_status == 1)
_0xBB:
	LDS  R26,_buzz_status
	CPI  R26,LOW(0x1)
	BRNE _0xBF
; 0000 0294         {
; 0000 0295             BUZZ_PIN = 1;
	SBI  0x15,0
; 0000 0296             lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x14
; 0000 0297             lcd_puts("Buzz");
	__POINTW2MN _0x7A,134
_0xC5:
	CALL _lcd_puts
; 0000 0298         }
; 0000 0299     }
_0xBF:
	RJMP _0x7B
; 0000 029A }
_0xC2:
	RJMP _0xC2
; .FEND

	.DSEG
_0x7A:
	.BYTE 0x8B
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	JMP  _0x2080001
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x18
	JMP  _0x2080002
; .FEND
_put_buff_G100:
; .FSTART _put_buff_G100
	CALL SUBOPT_0x2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x18
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x18
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x19
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x19
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x1A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1B
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1D
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x19
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1B
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x1E
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080007
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x1E
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x1F
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x1F
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strpbrkf:
; .FSTART _strpbrkf
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
strpbrkf0:
    ld   r22,x
    tst  r22
    breq strpbrkf2
    ldd  r31,y+1
    ld   r30,y
strpbrkf1:
	lpm
    tst  r0
    breq strpbrkf3
    adiw r30,1
    cp   r22,r0
    brne strpbrkf1
    movw r30,r26
    rjmp strpbrkf4
strpbrkf3:
    adiw r26,1
    rjmp strpbrkf0
strpbrkf2:
    clr  r30
    clr  r31
strpbrkf4:
	JMP  _0x2080005
; .FEND
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	JMP  _0x2080005
; .FEND
_strspnf:
; .FSTART _strspnf
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
    clr  r24
    clr  r25
strspnf0:
    ld   r22,x+
    tst  r22
    breq strspnf2
    ldd  r31,y+1
    ld   r30,y
strspnf1:
	lpm  r0,z+
    tst  r0
    breq strspnf2
    cp   r22,r0
    brne strspnf1
    adiw r24,1
    rjmp strspnf0
strspnf2:
    movw r30,r24
_0x2080005:
_0x2080006:
	ADIW R28,4
	RET
; .FEND
_strtok:
; .FSTART _strtok
	CALL SUBOPT_0x2
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x2020003
	LDS  R30,_p_S1010026000
	LDS  R31,_p_S1010026000+1
	SBIW R30,0
	BRNE _0x2020004
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080003
_0x2020004:
	LDS  R30,_p_S1010026000
	LDS  R31,_p_S1010026000+1
	STD  Y+4,R30
	STD  Y+4+1,R31
_0x2020003:
	CALL SUBOPT_0x3
	CALL _strspnf
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2020005
	LDI  R30,LOW(0)
	STS  _p_S1010026000,R30
	STS  _p_S1010026000+1,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080003
_0x2020005:
	CALL SUBOPT_0x3
	CALL _strpbrkf
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020006
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2020006:
	__PUTWMRN _p_S1010026000,0,16,17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
_0x2080003:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2080004:
	ADIW R28,6
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x15,4
	RJMP _0x2040005
_0x2040004:
	CBI  0x15,4
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x15,3
	RJMP _0x2040007
_0x2040006:
	CBI  0x15,3
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x15,2
	RJMP _0x2040009
_0x2040008:
	CBI  0x15,2
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x15,1
	RJMP _0x204000B
_0x204000A:
	CBI  0x15,1
_0x204000B:
	__DELAY_USB 18
	SBI  0x15,5
	__DELAY_USB 18
	CBI  0x15,5
	__DELAY_USB 18
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 184
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x20
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x20
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x2080001
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,7
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,7
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	LDD  R17,Y+0
_0x2080002:
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,4
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
	SBI  0x14,5
	SBI  0x14,7
	SBI  0x14,6
	CBI  0x15,5
	CBI  0x15,7
	CBI  0x15,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 276
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_send_tel_number:
	.BYTE 0xE
_send_msg:
	.BYTE 0x1E
_rcvd_tel_number:
	.BYTE 0xF
_rcvd_msg:
	.BYTE 0x32
_mq2_count:
	.BYTE 0x1
_timer1_count:
	.BYTE 0x1
_rl1_status:
	.BYTE 0x1
_rl2_status:
	.BYTE 0x1
_rl3_status:
	.BYTE 0x1
_buzz_status:
	.BYTE 0x1
_rl3_enable:
	.BYTE 0x1
_buzz_enable:
	.BYTE 0x1
_rl1_str:
	.BYTE 0x5
_rl2_str:
	.BYTE 0x4
_rl3_str:
	.BYTE 0x4
_buzz_str:
	.BYTE 0x4
_on_str:
	.BYTE 0x3
_off_str:
	.BYTE 0x4
_en_str:
	.BYTE 0x3
_dis_str:
	.BYTE 0x4
_mq2_sms_sent_count:
	.BYTE 0x2
_ir_sms_sent_count:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x64
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_p_S1010026000:
	.BYTE 0x2
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	MOVW R0,R30
	LDI  R26,LOW(_rx_buffer)
	LDI  R27,HIGH(_rx_buffer)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_comma*2)
	LDI  R27,HIGH(_comma*2)
	CALL _strtok
	MOVW R20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_rl1_str)
	LDI  R27,HIGH(_rl1_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_on_str)
	LDI  R27,HIGH(_on_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_off_str)
	LDI  R27,HIGH(_off_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_rl2_str)
	LDI  R27,HIGH(_rl2_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_rl3_str)
	LDI  R27,HIGH(_rl3_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_dis_str)
	LDI  R27,HIGH(_dis_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_en_str)
	LDI  R27,HIGH(_en_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD:
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(_buzz_str)
	LDI  R27,HIGH(_buzz_str)
	CALL _hasString
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_mq2_sms_sent_count)
	LDI  R27,HIGH(_mq2_sms_sent_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R26,_mq2_sms_sent_count
	LDS  R27,_mq2_sms_sent_count+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_ir_sms_sent_count)
	LDI  R27,HIGH(_ir_sms_sent_count)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL _delay_ms
	CALL _lcd_clear
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	STS  _rl3_status,R30
	LDI  R30,LOW(_send_msg)
	LDI  R31,HIGH(_send_msg)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R30,LOW(_send_tel_number)
	LDI  R31,HIGH(_send_tel_number)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_send_msg)
	LDI  R27,HIGH(_send_msg)
	CALL _SIM800A_sendSMS
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 276
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
