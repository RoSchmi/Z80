// Testprogramm gibt Zeichen über STI-A aus
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
        
@Start  Ld A,$50
        Ld C,A 
        Call 0x03C7           // Output byte in Reg C to STI-A             
        Call @Delay           // Delay ca. 200 msec     
        Ld A,$0D
        Ld C,A 
        Call 0x03C7               
        Ld A,$0A
        Ld C,A       
        Call 0x03C7                   
        Ld A,$51
        Ld C,A            
        Call 0x03C7             
        Ld A,$0D
        Ld C,A
        Call 0x03C7             
        Ld A,$0A
        Ld C,A
        Call 0x03C7                      
        Ret
        Nop
        Nop
        Nop
@Loop
        Nop
        Jr @Loop
        Nop






        


