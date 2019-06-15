
# Z80_S_EMUF_Cmds_Interrupts.z80
//
// Der Code befindet sich auf github.com/RoSchmi/Z80
// Nach dem Laden auf das Board wird zuerst einige Male Z80 PIO Port B Bit 0 getoggelt.
// Man kann hierdurch am Blinken einer angeschlossenen LED sehen, dass das Programm läuft.
// Danach wartet das Programm auf Zeichen über die serielle Schnittstelle.
// Die Zeichen können z.B. über die C# Anwendung "Z80_Term_Utility" oder z.B. über Teraterm
// an das Board gesendet werden. 
// Das empfangene Zeichen wird über die serielle Schnittstelle zum PC (Sender) 
// zurückgeschickt.
// Es erfolgt eine Reaktion auf die Tasten 'a', 's' und 'd'.
// a: Reagiert auf Impulse an PIO Port A, es wird Interrupt ausgelöst, --> '0' über UART
// s: Zählt Impulse an Z80 CTC Pin CLK/TRG0. Nach jedem 10. Impuls erfolgt Interrupt
//    bewirkt Ausgabe von '1' über UART.
// d: Bewirkt Ausgabe einer Impulsfoge an ZC/T01. 
// Das Programm wird mit der C# Anwendung "Z80_Term_Utility" auf den S-EMUF übertragen.
// Dieses Programm befindet sich auch auf github.com/RoSchmi/Z80
// Der Code startet automatisch ab Adresse 0x8000. Ob es funktioniert kann man mit einem
// Oszilloskop an den Pins der Z80 PIO überprüfen oder das Blinken einer angeschlossenen
// LED beobachten.

// Erstellt auf VS-Code mit https://enginedesigns.net/retroassembler



