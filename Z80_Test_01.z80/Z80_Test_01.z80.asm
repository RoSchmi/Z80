// First simple test for TERM1
// Gibt Zeichen 0x51 über serielle Schnittstelle aus

OutToSTI_A      .equ $03C7

Nop
Ld A,0x51
ld	a,c
jp OutToSTI_A
Ret


