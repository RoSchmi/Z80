
# Z80_S_EMUF_Cmds_Interrupts.z80
//
// Der Code befindet sich auf github.com/RoSchmi/Z80
// Nach dem Laden auf das Board wird zuerst einige Male Z80 PIO Port B Bit 0 getoggelt.
// Man kann hierdurch am Blinken einer angeschlossenen LED sehen, dass das Programm l�uft.
// Danach wartet das Programm auf Zeichen �ber die serielle Schnittstelle.
// Die Zeichen k�nnen z.B. �ber die C# Anwendung "Z80_Term_Utility" oder z.B. �ber Teraterm
// an das Board gesendet werden. 
// Das empfangene Zeichen wird �ber die serielle Schnittstelle zum PC (Sender) 
// zur�ckgeschickt.
// Es erfolgt eine Reaktion auf die Tasten 'a', 's' und 'd'.
// a: Reagiert auf Impulse an PIO Port A, es wird Interrupt ausgel�st, --> '0' �ber UART
// s: Z�hlt Impulse an Z80 CTC Pin CLK/TRG0. Nach jedem 10. Impuls erfolgt Interrupt
//    bewirkt Ausgabe von '1' �ber UART.
// d: Bewirkt Ausgabe einer Impulsfoge an ZC/T01. 
// Das Programm wird mit der C# Anwendung "Z80_Term_Utility" auf den S-EMUF �bertragen.
// Dieses Programm befindet sich auch auf github.com/RoSchmi/Z80
// Der Code startet automatisch ab Adresse 0x8000. Ob es funktioniert kann man mit einem
// Oszilloskop an den Pins der Z80 PIO �berpr�fen oder das Blinken einer angeschlossenen
// LED beobachten.

// Erstellt auf VS-Code mit https://enginedesigns.net/retroassembler



