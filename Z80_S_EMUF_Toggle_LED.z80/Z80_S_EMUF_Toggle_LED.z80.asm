// Z80_S_EMUF_Toggle_LED.z80
// Programm toggelt Ausgänge der Z80 PIP Port B
// Einfaches Testprogramm um festzustellen, ob die Übertragung von Code vom PC
// über die serielle Schnittstelle funktioniert
// Das Programm wird mit der C# Anwendung "Z80_Term_Utility" auf den S-EMUF übertragen.
// Der Code startet automatisch ab Adresse 0x8000. Ob es funktioniert kann man mit einem
// Oszilloskop an den Pins der Z80 PIO überbrüfen

.target "Z80"
.org 0x8000

PIO_A_Data .equ $00
PIO_A_Cont .equ $02
PIO_B_Data .equ $01
PIO_B_Cont .equ $03

DelSpan .equ $FF        // Factor for Delay Loop


Nop
Ld SP,$8016             // Stackpointer auf 0x8016
jr @Start
@Delay                             
        Ld C,A         // Delay Factor is in Reg A, value x 2msec
@PWS1   
        Ld A,$FA          // Delay 2 ms     
@PWS2   
        Dec A
        Jr NZ, @PWS2     
        DEC C      
        Jr NZ, @PWS1
        Ret
        // Reserved for Stack
        Nop
        Nop
        Nop
        Nop
        Nop
        Nop
        // End of Stack
        Nop
        Nop
        Nop
        Nop
@Start
Ld A,$0F
Out (PIO_B_Cont),A
Ld A,DelSpan
Ld C,$00 
CALL @Delay
@Set
Ld A,$01
@Out
Out (PIO_B_Data),A
Ld A,DelSpan            // Delay Cont of Reg A x 2 msec
Ld C,$00
CALL @Delay
Ld A,$00
Out (PIO_B_Data),A
Ld A,DelSpan           // Delay Cont of Reg A x 2 msec
Ld C,$00
CALL @Delay
JP @Set

