// Z80_S_EMUF_1.Z80
// Befindet sich auch in Github /RoSchmi/Z80
// Das Programm soll sich im EPROM des Super EMUF Boards ab Adr. 0000 befinden.
// Es dient dazu Code über die serielle Schnittstelle (Baudrate 9600)
// entgegenzunehmen, ab Adresse hex 8000 abzuspeichern und dann zu
// starten. Über die serielle Schnittstell kommt zuerst die Länge des Codes
// (2 byte, das höhere Byte zuerst), danach der Code selbst. 
// Ist der gesamte Code übertragen, wird das Programm ab Adresse hex 8000 gestartet.

.target "Z80"
.org 0x0000

PIO_A_Data .equ $00
PIO_A_Cont .equ $02
PIO_B_Data .equ $01
PIO_B_Cont .equ $03

UARTSE     .equ $30
UARTRE     .equ $32
UARTCO     .equ $31

Stack      .equ $8700

PgmStart   .equ $8000

DI 
IM 2
Ld A,$FF
Out (PIO_A_Cont),A      // Control Mode 3
Ld A,$FF
Out (PIO_A_Cont),A      // Port A all Input
Ld A,$FF
Out (PIO_B_Cont),A      // Port B all Input
In A,(UARTCO)           // Dummy
Ld HL,PgmStart          // Pgm Start Addr in HL
WaitSer1                // Wait for 1. Byte
In A,(UARTCO)
Bit 7,A 
Jp Z,WaitSer1
In A,(UARTRE) 
Ld D,A
WaitSer2                // Wait for 2. Byte
In A,(UARTCO)
Bit 7,A 
Jp Z,WaitSer2
In A,(UARTRE) 
Ld E,A
Ld C,UARTRE
Inc DE
WaitSer3                // Wait for next and following bytes
In A,(UARTCO)
Bit 7,A 
Jp Z,WaitSer3
Ini 
Dec DE 
Ld A,D 
OR E 
Jp NZ,WaitSer3          // Ready ?
Jp PgmStart