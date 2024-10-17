`ifndef PCI_BRIDGE_WB_INTERFACE
`define PCI_BRIDGE_WB_INTERFACE

interface pci_bridge_wb_interface(input logic clk);

	////////////////////////////////////////////////////////////////////////////
	// Declaration of Signals
	////////////////////////////////////////////////////////////////////////////

	// WISHBONE system signals
	logic RST_I, RST_O, INT_I, INT_O;

	// WISHBONE slave
	logic [31:0] ADR_I, SDAT_I, SDAT_O;
	logic [3:0] SEL_I;
	logic CYC_I, STB_I, WE_I, CAB_I;
	logic [2:0] CTI_I;
	logic [1:0] BTE_I;
	logic ACK_O, RTY_O, ERR_O;

	// WISHBONE master
	logic [31:0] ADR_O, MDAT_I, MDAT_O;
	logic [3:0] SEL_O;
	logic CYC_O, STB_O, WE_O;
	logic [2:0] CTI_O;
	logic [1:0] BTE_O;
	logic ACK_I, RTY_I, ERR_I;

	////////////////////////////////////////////////////////////////////////////
	// clocking block and modport declaration for driver 
	////////////////////////////////////////////////////////////////////////////
	clocking dr_cb@(posedge clk);
		// WISHBONE system signals
		output	RST_I;
		input	RST_O;
		output	INT_I;
		input	INT_O;

		// WISHBONE slave interface
		output	ADR_I;
		output	SDAT_I;
		input	SDAT_O;
		output	SEL_I;
		output	CYC_I;
		output	STB_I;
		output	WE_I;
		output	CAB_I;
		output	CTI_I;
		output	BTE_I;
		input	ACK_O;
		input	RTY_O;
		input	ERR_O;

		// WISHBONE master interface
		input	ADR_O;
		output	MDAT_I;
		input	MDAT_O;
		input	SEL_O;
		input	CYC_O;
		input	STB_O;
		input	WE_O;
		input	CTI_O;
		input	BTE_O;
		output	ACK_I;
		output	RTY_I;
		output	ERR_I;
  	endclocking
  
  	modport DRV (clocking dr_cb, input clk);

	////////////////////////////////////////////////////////////////////////////
	// clocking block and modport declaration for monitor 
	////////////////////////////////////////////////////////////////////////////
	clocking rc_cb@(negedge clk);
		// WISHBONE system signals
		input	RST_I;
		input	RST_O;
		input	INT_I;
		input	INT_O;

		// WISHBONE slave interface
		input	ADR_I;
		input	SDAT_I;
		input	SDAT_O;
		input	SEL_I;
		input	CYC_I;
		input	STB_I;
		input	WE_I;
		input	CAB_I;
		input	CTI_I;
		input	BTE_I;
		input	ACK_O;
		input	RTY_O;
		input	ERR_O;

		// WISHBONE master interface
		input	ADR_O;
		input	MDAT_I;
		input	MDAT_O;
		input	SEL_O;
		input	CYC_O;
		input	STB_O;
		input	WE_O;
		input	CTI_O;
		input	BTE_O;
		input	ACK_I;
		input	RTY_I;
		input	ERR_I;
	endclocking
  
  	modport RCV (clocking rc_cb, input clk);

endinterface

`endif
