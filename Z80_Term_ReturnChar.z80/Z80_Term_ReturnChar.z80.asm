// Z80_Term_ReturnChar.z80.asm
//
// Z80 Read Character from Serial and return
// Testprogramm empfängt Zeichen von STI-A und gibt Zeichen über STI-A wieder aus
// Wird Esc Taste gedrückt, wird das Programm mit eigenem Code beendet
// Um wieder zum eigenen Code zurück zu kommen, muss man dann WE $4700 CR eingeben
.target "Z80"
.org 0x4700

Nop
jr @Start
@Delay  
        Ld A,$64          // Delay Factor is in Reg A, value x 2msec
        Ld C,A
@PWS1   
        Ld A,$FA          // Delay 2 ms
@PWS2   
        Dec A
        Jr NZ, @PWS2     
        DEC C      
        Jr NZ, @PWS1
        Ret
        
@Start  Call $0455              // Zeichen da ?
        Jr  C,@Start            // Nein, warten, repeat
        Ld C,A                  // 4F
        XOR A,$1B               // EE1B
        Jr NZ,@Next1            //2003
        jp @RetCmd              //C33A47   Jump out of own Code (Back here with WE $4700)
@Next1
        Ld A,C                  //79 
@Out    
        Call 0x03C7             // Output byte in Reg C to STI-A             
        Call @Delay             // Delay ca. 200 msec
        Ld A,$0A        
        Call $00C7              // An Grafikcontroller
        Ld A,C       
        Call $00C7              // An Grafikcontroller
        Call @Delay             // Delay ca. 200 msec 
        Jp @Start
@RetCmd                             
        Ret
        Nop
        Nop
        Nop
@Loop
        Nop
        Jr @Loop
        Nop