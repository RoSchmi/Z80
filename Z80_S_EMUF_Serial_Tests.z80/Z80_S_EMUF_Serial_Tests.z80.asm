// Z80_S_EMUF_Serial_Tests.z80 
// Das Programm toggelt zuerst 3 x Z80 PIO Port B Bit 0
// Man kann hierdurch am Blinken der LED sehen, dass das Programm läuft
// Danach wartet das Programm auf Zeichen über die serielle Schnittstelle.
// Das empfangene Zeichen wir auf Z80 PIO Port B ausgegeben und zusätzlich
// über die serielle Schnittstelle zum PC (Sender) zurückgeschickt.
// Das Programm wird mit der C# Anwendung "Z80_Term_Utility" auf den S-EMUF übertragen.
// Der Code startet automatisch ab Adresse 0x8000. Ob es funktioniert kann man mit einem
// Oszilloskop an den Pins der Z80 PIO überprüfen oder das Blinken einer LED beobachten

.target "Z80"
.org 0x8000

PIO_A_Data .equ $00
PIO_A_Cont .equ $02
PIO_B_Data .equ $01
PIO_B_Cont .equ $03

UARTSE     .equ $30
UARTRE     .equ $32
UARTCO     .equ $31

CTC0       .equ $20
CTC1       .equ $21
CTC2       .equ $22
CTC3       .equ $23

Stack      .equ $8700

DelSpan .equ $FF        // Factor for Delay Loop


Nop
DI 
IM 2 
Ld SP,Stack            // Stackpointer auf 0x8016
jr @Start
@Delay                             
        Ld C,A         // Delay Factor is in Reg A, value x 2msec
@PWS1   
        Ld A,$FA       // Delay 2 ms     
@PWS2   
        Dec A
        Jr NZ, @PWS2     
        DEC C      
        Jr NZ, @PWS1
        Ret
       
@Start
Ld A,$0F
Out (PIO_B_Cont),A
Ld D,$01                // Pio Port to be toggled
LD B,$06                // Count how many times
@SetPioB
Ld A,$01
XOR D
Ld D,A
Out (PIO_B_Data),A  
Ld A,DelSpan            // Delay Cont of Reg A x 2 msec
Ld C,$00
CALL @Delay
Dec B
JP NZ,@SetPioB

@L4
IN A,(UARTCO)
Bit 7,A 
JP Z,@L4
In A,(UARTRE)
Out (PIO_B_Data),A
Out (UARTSE),A

@L2
In A,(UARTCO)
Bit 6,A 
JP Z,@L2

Ld D,$01                // Pio Port to be toggled
LD B,$02                // Count how many times
@SetPioB2
Ld A,$01
XOR D
Ld D,A
Out (PIO_B_Data),A  
Ld A,DelSpan            // Delay Cont of Reg A x 2 msec
Ld C,$00
CALL @Delay
Dec B
JP NZ,@SetPioB2

Jp @L4 
HALT