// Z80_Term_Get
.target "Z80"
.org 0x0407

Call $03D7      // CDD703
OR A            // B7
RET Z           // C8
Call $03E4      // CDE403
CP $80          // FE80
JP NZ,$041C     // C21C04
Ld A,$01        // 3E01
Ld ($3868),A    // 326838
JP $0422        // C32204
Push BC         // C5
Ld C,A          // 4F
Call $03C7      // CDC703
POP BC          // C1
Ret             // C9


Ld A,(0x3868)   // 3A6838 
CP $01          // FE01
JNZ $0436       // C23604
INC B           // 04
Push HL         // E5
Push DE         // D5
Call $0407      // CD0704
DI              // F3
Ld A,(BC)       // 2A
ADC A,D         // 8A
JR C,$ED        // 38ED
LD E,E          // 5B
CP B            // 88
JR C,$FB        // 38FB
XOR A           // AF
see below       // ED
LD D,D          // 52
Ld A,L          // 7D
OR H            // B4
JP NZ,$0450     // C25004
SCF             // 37
JP $0452        // C35204
SCF             // 37
CCF             // 3F
POP DE          // D1
POP HL          // E1
Ret             // C9




