// Programm gibt hochzählend 00 bis FF über PIO Port B aus
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

Nop
Ld A,$0F
Out (PIO_B_Cont),A
@Start
Ld A,$00
@Ausgabe
Out (PIO_B_Data),A 
Inc A 
JP NZ,@Ausgabe
JP  @Start
