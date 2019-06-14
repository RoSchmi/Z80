// Testprogramm gibt Zeichen über STI-A aus
Nop
jr @Start
@Delay  Ld A,$64          // Delay Factor is in Reg A, value x 2msec
        Ld C,A
@PWS1   
        Ld A,$FA          // Delay 2 ms
@PWS2   
        Dec A
        Jr NZ, @PWS2
        Ld A,c
        DEC A
        Jr NZ, @PWS1
        Ret
@Start  Ld A,$50
        Out ($8f), A
        Jp @Delay           // Delay ca. 200 msec
        Ld A,$51
        Out ($8f), A
        Jp @Delay
        Ld A,$52
        Out ($8f), A
        Ret
        Nop
        Nop
        Nop
@Loop
        Nop
        Jr @Loop
        


