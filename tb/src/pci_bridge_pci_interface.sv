`ifndef PCI_BRIDGE_PCI_INTERFACE
`define PCI_BRIDGE_PCI_INTERFACE

interface pci_bridge_pci_interface(input logic clk);
  
	////////////////////////////////////////////////////////////////////////////
	// Declaration of Signals
	////////////////////////////////////////////////////////////////////////////
	logic [31:0] AD;
	logic [3:0] CBE;
	logic RST, INTA, REQ, GNT, FRAME, IRDY, IDSEL, DEVSEL, TRDY, STOP;
	logic PAR, PERR, SERR;
	////////////////////////////////////////////////////////////////////////////
	// clocking block and modport declaration for driver 
	////////////////////////////////////////////////////////////////////////////
	clocking dr_cb@(posedge clk);
		inout	AD;
		inout	CBE;
		output	RST;
		inout	INTA;
		input	REQ;
		output	GNT;
		inout	FRAME;
		inout	IRDY;
		output	IDSEL;
		inout	DEVSEL;
		inout	TRDY;
		inout	STOP;
		inout	PAR;
		inout	PERR;
		input	SERR;
  	endclocking
  
  	modport DRV (clocking dr_cb, input clk);

	////////////////////////////////////////////////////////////////////////////
	// clocking block and modport declaration for monitor 
	////////////////////////////////////////////////////////////////////////////
	clocking rc_cb@(negedge clk);
		input	AD;
		input	CBE;
		input	RST;
		input	INTA;
		input	REQ;
		input	GNT;
		input	FRAME;
		input	IRDY;
		input	IDSEL;
		input	DEVSEL;
		input	TRDY;
		input	STOP;
		input	PAR;
		input	PERR;
		input	SERR;
	endclocking
  
  	modport RCV (clocking rc_cb, input clk);

endinterface

`endif
