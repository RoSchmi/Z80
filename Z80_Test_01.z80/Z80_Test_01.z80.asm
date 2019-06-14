//.setting "LaunchCommand", "C:\\Emulator\\emulator.exe {0}"
//Hello
OutToSTI_A      .equ $03C7

 Nop
Ld A,0x51
ld	a,c
jp OutToSTI_A
Ret


