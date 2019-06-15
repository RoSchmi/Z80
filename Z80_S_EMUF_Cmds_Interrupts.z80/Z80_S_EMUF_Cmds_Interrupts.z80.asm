// Z80_S_EMUF_Cmds_Interrupts.z80
//
// Der Code befindet sich auf github.com/RoSchmi/Z80
// Nach dem Laden auf das Board wird zuerst einige Male Z80 PIO Port B Bit 0 getoggelt.
// Man kann hierdurch am Blinken einer angeschlossenen LED sehen, dass das Programm läuft
// Danach wartet das Programm auf Zeichen über die serielle Schnittstelle.
// Die Zeichen können z.B. über die C# Anwendung "Z80_Term_Utility" oder z.B. über Teraterm
// an das Board gesendet werden. 
// Das empfangene Zeichen wird über die serielle Schnittstelle zum PC (Sender) 
// zurückgeschickt.
// Es erfolgt eine Reaktion auf die Tasten 'a', 's' und 'd'.
// a: Reagiert auf Impulse an PIO Port A, es wird Interrupt ausgelöst, --> '0' über UART
// s: Zählt Impulse an Z0 CTC Pin CLK/TRG0. Nach jedem 10. Impuls erfolgt Interrupt
//    bewirkt Ausgabe von '1' über UART.
// d: Bewirkt Ausgabe einer Impulsfoge an ZC/T01. 
// Das Programm wird mit der C# Anwendung "Z80_Term_Utility" auf den S-EMUF übertragen.
// Dieses Programm befindet sich auch auf github.com/RoSchmi/Z80
// Der Code startet automatisch ab Adresse 0x8000. Ob es funktioniert kann man mit einem
// Oszilloskop an den Pins der Z80 PIO überprüfen oder das Blinken einer angeschlossenen
// LED beobachten.

// Erstellt auf VS-Code mit https://enginedesigns.net/retroassembler

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

INCTC0     .equ $8410
INCTC1     .equ $8412
INCTC2     .equ $8414
INCTC3     .equ $8416

INPI1A     .equ $8400
INPI1B     .equ $8402

Stack      .equ $8700

Nop
DI 
IM 2
Ld A,$84
Ld I,A 
Ld HL,Stack            // Stackpointer auf 0x8700
Ld SP,HL
Ld A,$00
Out (PIO_A_Cont),A 
Ld A,$02 
Out (PIO_B_Cont),A 
Ld A,$10 
Out (CTC0),A 
Ld A,%00010101 
Out (CTC1),A 
Ld A,$FF
Out (PIO_A_Cont),A 
Ld A,%11111111
Out (PIO_A_Cont),A 
Ld A,%00010111
Out (PIO_A_Cont),A
Ld A,%11111110
Out (PIO_A_Cont),A
Ld A,$0F 
Out (PIO_B_Cont),A 
Ld HL,IntPr1
Ld (INPI1A),HL 
LD HL,IntPr2
Ld (INCTC0),HL
jr Start
Delay
        Push AF 
        Push BC                             
        Ld C,A         // Delay Factor is in Reg A, value x 2msec
@PWS1   
        Ld A,$FA       // Delay 2 ms     
@PWS2   
        Dec A
        Jr NZ, @PWS2     
        DEC C      
        Jr NZ, @PWS1
        Pop BC
        Pop AF
        Ret

TogglePio
Push AF
Push BC
Push DE
Ld E,A                    // A (time x 2 msec) in E zwischenspeichern
Ld A,$0F
Out (PIO_B_Cont),A
//Ld D,$01                // Pio Port to be toggled
//LD B,$06                // Count how many times
Ld D,C                    // C (Port) in D speichern
 
@SetPioB
Ld A,D 
XOR C 
Ld C,A
Out (PIO_B_Data),A  
Ld A,E            // Delay Cont of Reg A x 2 msec
CALL Delay
Dec B
JP NZ,@SetPioB
Pop DE
Pop BC
Pop AF
Ret
       
Start
Ld A, $FA       // time = a x 2 msec
Ld B,$A         // Count
Ld C,$01        // Bits of Port B
Call TogglePio

@L4
IN A,(UARTCO)
Bit 7,A 
JP Z,@L4
In A,(UARTRE)
Out (UARTSE),A
EX AF,AF'                  // A sichern

@L2
In A,(UARTCO)            // Beendigung serielle Ausgabe abwarten
Bit 6,A 
JP Z,@L2

Ld A,$AF                // time = a x 2 msec
Ld B,$02                // Count
Ld C,$01                // Bits of Port B
Call TogglePio

EX AF,AF'
Ld C,A
XOR A,$61               // a ?
Jp NZ,@Nota 
Call Routa
Jp @L4
@Nota
Ld A,C 
XOR A,$73               // s ?
Jp NZ,@Nots
Call Routs
Jp @L4
@Nots
Ld A,C
XOR A,$64               // d ?
Jp NZ,@Notd
Call Routd
Jp @L4
@Notd
Ld A,C
XOR A,$66               // f ?
Jp NZ,@L4
Call Routf
Jp @L4 
HALT

Routa
Call TINTZT            // PIO Interrupt Testprogramm
Ret

Routs
Call TCTCZA            // CTC Zähler Testprogramm
Ret

Routd
Call TCTCZE            // Erzeugt Impulsfolge an ZC/T01
Ret

Routf
Ret
//**************************************************
//  CTC Zähler Testprogramm, zählt Impulse am CLK/TRG0
//  nach dem 10. Impuls wird Interrupt ausgelöst, IntPr2
//**************************************************
TCTCZA                  // s

Ld A,$AF                // time = a x 2 msec
Ld B,$04                // Count
Ld C,$01                // Bits of Port B
Call TogglePio

Push AF
Ld A, %11010101
//Ld A, %11010111
Out (CTC0),A 
Ld A,$0A 
Out (CTC0),A 
EI 
Halt
Pop AF
Ret

//**************************************************
//  CTC Zeitgeber Testprogramm, erzeugt am ZC/T01 Impulsfolge
//**************************************************
TCTCZE                  // d

Ld A,$AF                // time = a x 2 msec
Ld B,$04                // Count
Ld C,$01                // Bits of Port B
Call TogglePio

Push AF
Ld A,$10     // Zeitkonstante laden
Out (CTC1),A
Pop AF 
Ret

//**************************************************
//  Interrupt Testprogramm für PIO Port A, nach jedem Interrupt
//  wird Interruptroutine INTPR1 angesprungen
//**************************************************
TINTZT            // a
Push AF
EI
Ld A,%10000011      // Interrupt Freigabe für PIO-A
Out (PIO_A_Cont),A 
Halt
Ld A,%00000011
Out (PIO_A_Cont),A  // Interrupts für PIO-A gesperrt
Pop AF 
Ret

//**************************************************
//   Interruptprogramm git eine "0" ueber UART aus
//**************************************************

IntPr1                  // PIO A Interrupt

Ld A,$AF                // time = a x 2 msec
Ld B,$02                // Count
Ld C,$01                // Bits of Port B
Call TogglePio

Push AF
Ld A,$30
Out (UARTSE),A
@L6 
In A,(UARTCO)
Bit 6,A 
Jp Z,@L6
Pop AF
EI 
Reti


//**************************************************
//   Interruptprogramm git eine "1" ueber UART aus
//**************************************************

IntPr2                  // CTC Interrupt

Ld A,$AF                // time = a x 2 msec
Ld B,$02                // Count
Ld C,$01                // Bits of Port B
Call TogglePio

Push AF
Ld A,$31
Out (UARTSE),A
@L5 
In A,(UARTCO)
Bit 6,A 
Jp Z,@L5
Pop AF
EI 
Reti

