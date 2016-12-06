#include "msp430.h"
;-------------------------------------------------------------------------------------------------------------------
		ORG		0C000h 				;Program start
;-------------------------------------------------------------------------------------------------------------------
;		Housekeeping
;-------------------------------------------------------------------------------------------------------------------
RESET		mov		#0400h,SP			;Initialize stackpointer
StopWDT		mov		#WDTPW + WDTHOLD, &WDTCTL	;Stop WDT
SetupP1		bis.b		#0xFF,&P1DIR			;Set P1.0,P1.1,P1.2,P1.3,P1.4,P1.5 as output ports
SetupP2		bis.b		#00h,&P2DIR			;Set P2.0,P2.1 as input ports
;-------------------------------------------------------------------------------------------------------------------
;		PROGRAM
;-------------------------------------------------------------------------------------------------------------------
Main		mov		#0h, R4				;initialize state of lights
		;Set up internal resistance 
		bic.b		#3,&P2SEL			;selectP2.0 & P2.1
		bis.b		#3,&P2REN			;set P2.0 & P2.1 as pull-up resistor
		bis.b		#3,&P2OUT			;set P2.0 & P2.1 as pull-up resistor
		bis.b		#3,&P2IE			;enable BIT0 and BIT1 interrupts on
		bis.b		#3,&P2IES			
		
		eint						; turn on global interrupt enable
		
ask		bic.b		#0xFF,&P1OUT			;Clear ports
		bis.b		#0xFF,&P1OUT			;Turn on all lights		
		call		#Delay1				;1 second delay
		
		cmp		#0,R4				;If state equal to 0 go to Secuencia 1		
		jz		Sec1
		cmp		#1,R4				;If state equal to 1 go to Secuencia 2
		jz		Sec2
		cmp		#2,R4				;If state equal to 2 go to Secuencia 3
		jz		Sec3				
		cmp		#3,R4				;If state equal to 3 go to Secuencia 4
		jz		Sec4
		cmp		#4,R4				;If state equal to 4 go to Secuencia 5
		jz		Sec5
Sec1		call		#Secuencia1			;go to secuencia 1
		jmp		Sec1
Sec2		call		#Secuencia2			;go to secuencia 2
		jmp		Sec2
Sec3		call		#Secuencia3			;go to secuencia 3
		jmp		Sec3
Sec4		call		#Secuencia4			;go to secuencia 4
		jmp		Sec4
Sec5		call		#Secuencia5			;go to secuencia 5
		jmp		Sec5
;-------------------------------------------------------------------------------------------------------------------
;		Interrupt Service
;-------------------------------------------------------------------------------------------------------------------	
ButtonPressed:	
		call		#Delay1				;Delay to overcome bouncing problems
		pop		R6				;SR content
		pop 		R7				;next instruction after return
		
		bit.b		#1,&P2IFG			;Check if foward button was pressed
		jc		Foward				
		bit.b		#2,&P2IFG			;Chech if backward button was pressed
		jc		Backward

Foward		call		#increment			;go to increment
		jmp		Return
		
Backward	call		#substract			;go to substract
		
Return		bic.b		#3,&P2IFG
		
		mov		#0400h,SP			;reset SP in case it was in a subroutine
		push		#0xC034				;push location after reti 
		push		R6				; push previous SR
		call		#Delay1				;Delay to overcome bouncing
		
		reti
;-------------------------------------------------------------------------------------------------------------------
;		Subroutines
;-------------------------------------------------------------------------------------------------------------------
increment:	
		bic.b		#3,&P2IFG			;Clear interrupt flags
		cmp		#4,R4				;check if state equals 4
		jz		cuatro			
		inc		R4				;if not 4, increment state (R4)
		jmp		L1
cuatro		mov		#0,R4				;if it's 4, set state to zero
L1		
		ret
;-------------------------------------------------------------------------------------------------------------------
substract:	
		bic.b		#3,&P2IFG			;Clear interrupt flags
		cmp		#0,R4				; check if state equals 0
		jz		cero
		dec		R4				;if not 0, decrease state (R4)
		jmp		L2
cero		mov		#4,R4				;if it's 0, set state to four
L2
		ret
;-------------------------------------------------------------------------------------------------------------------

Secuencia1:	
		call		#Delay2
		bic.b		#0xFF,&P1OUT			;Clear ports
		;start light sequence
		call		#Delay2
		xor.b		#1,&P1OUT
		call		#Delay2
		xor.b		#00000010b,&P1OUT
		call		#Delay2
		xor.b		#00000100b,&P1OUT
		call		#Delay2
		xor.b		#00001000b,&P1OUT
		call		#Delay2
		xor.b		#00010000b,&P1OUT
		call		#Delay2
		xor.b		#00100000b,&P1OUT
		call		#Delay2
		xor.b		#01000000b,&P1OUT
		call		#Delay2
		xor.b		#10000000b,&P1OUT
		ret
;-------------------------------------------------------------------------------------------------------------------
Secuencia2:	
		call		#Delay2
		bic.b		#0xFF,&P1OUT			;Clear ports
		;start light sequence
		call		#Delay2
		xor.b		#10000001b,&P1OUT
		call		#Delay2
		xor.b		#01000010b,&P1OUT
		call		#Delay2
		xor.b		#00100100b,&P1OUT
		call		#Delay2
		xor.b		#00011000b,&P1OUT
		ret
;-------------------------------------------------------------------------------------------------------------------
Secuencia3:	
		call		#Delay2
		bic.b		#0xFF,&P1OUT			;Clear ports
		;start light sequence
		call		#Delay2
		xor.b		#11000000b,&P1OUT
		call		#Delay2
		xor.b		#00001100b,&P1OUT
		call		#Delay2
		xor.b		#00110000b,&P1OUT
		call		#Delay2
		xor.b		#00000011b,&P1OUT
		ret	
;-------------------------------------------------------------------------------------------------------------------		
Secuencia4:	
		call		#Delay2
		bic.b		#0xFF,&P1OUT			;Clear ports
		;start light sequence
		call		#Delay2
		xor.b		#10000000b,&P1OUT
		call		#Delay2
		xor.b		#00100000b,&P1OUT
		call		#Delay2
		xor.b		#00001000b,&P1OUT
		call		#Delay2
		xor.b		#00000010b,&P1OUT
		call		#Delay2
		xor.b		#01000000b,&P1OUT
		call		#Delay2
		xor.b		#00010000b,&P1OUT
		call		#Delay2
		xor.b		#00000100b,&P1OUT
		call		#Delay2
		xor.b		#00000001b,&P1OUT
		ret	
;-------------------------------------------------------------------------------------------------------------------		
Secuencia5:	
		call		#Delay2
		bic.b		#0xFF,&P1OUT			;Clear ports
		;start light sequence
		call		#Delay2
		xor.b		#00001111b,&P1OUT
		call		#Delay2
		xor.b		#11110000b,&P1OUT
		call		#Delay2
		xor.b		#11111111b,&P1OUT
		call		#Delay2
		xor.b		#11111111b,&P1OUT
		ret			
;-------------------------------------------------------------------------------------------------------------------
;		Delay Subroutines
;-------------------------------------------------------------------------------------------------------------------
;one second Delay
Delay1:	
		mov 		#4, R15
D1		mov		#43000, R14
D2		dec		R14
		jnz		D2
		dec		R15
		jnz		D1
		
		ret
;-------------------------------------------------------------------------------------------------------------------		
;half second delay
Delay2:	
		mov 		#2, R15
D3		mov		#43000, R14
D4		dec		R14
		jnz		D4
		dec		R15
		jnz		D3
		
		ret		
;-------------------------------------------------------------------------------------------------------------------
;	Interrupt Vectors
;-------------------------------------------------------------------------------------------------------------------
		ORG		0FFFEh				;MSP430 RESET VECTOR
		DW		RESET
;-------------------------------------------------------------------------------------------------------------------
		ORG		0FFE6h				;P2 interruption Vector
		DW		ButtonPressed
		END