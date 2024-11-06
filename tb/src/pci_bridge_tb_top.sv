`ifndef PCI_BRIDGE_TB_TOP
`define PCI_BRIDGE_TB_TOP
 `include "uvm_macros.svh"
`include "pci_bridge_pci_interface.sv"
`include "pci_bridge_wb_interface.sv"
import uvm_pkg::*;
module pci_bridge_tb_top;
	 
 
	import pci_bridge_test_list::*;

	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Local Fields
	//////////////////////////////////////////////////////////////////////////////
	parameter pci_cycle = 30 ;
	parameter wb_cycle = 10 ;
	bit pci_clk, wb_clk;
	//////////////////////////////////////////////////////////////////////////////
	//clock generation
	//////////////////////////////////////////////////////////////////////////////
	initial begin
		pci_clk=0;
		forever #(pci_cycle/2) pci_clk=~pci_clk;
	end
	initial begin
		wb_clk = 0;
		forever #(wb_cycle/2) wb_clk=~wb_clk;
	end

	//////////////////////////////////////////////////////////////////////////////
	//creatinng instance of interface, inorder to connect DUT and testcase
	//////////////////////////////////////////////////////////////////////////////
	pci_bridge_pci_interface pci_intf(pci_clk);
	pci_bridge_wb_interface wb_intf(wb_clk);
	
	//////////////////////////////////////////////////////////////////////////////
	/*********************pci_bridge DUT Instantation **********************************/
	//////////////////////////////////////////////////////////////////////////////

	pullup(pci_intf.FRAME);
	pullup(pci_intf.IRDY);
	pullup(pci_intf.TRDY);
	pullup(pci_intf.STOP);
	pullup(pci_intf.DEVSEL);
	pullup(pci_intf.PERR);
	pullup(pci_intf.SERR);
	pullup(pci_intf.INTA);

	TOP dut_inst(
		// PCI
		.CLK(pci_clk),
		.AD(pci_intf.AD),
		.CBE(pci_intf.CBE),
		.RST(pci_intf.RST),
		.INTA(pci_intf.INTA),
		.REQ(pci_intf.REQ),
		.GNT(pci_intf.GNT),
		.FRAME(pci_intf.FRAME),
		.IRDY(pci_intf.IRDY),
		.IDSEL(pci_intf.IDSEL),
		.DEVSEL(pci_intf.DEVSEL),
		.TRDY(pci_intf.TRDY),
		.STOP(pci_intf.STOP),
		.PAR(pci_intf.PAR),
		.PERR(pci_intf.PERR),
		.SERR(pci_intf.SERR),

		// WB
		.CLK_I(wb_clk),
		.RST_I(wb_intf.RST_I),
		.RST_O(wb_intf.RST_O),
		.INT_I(wb_intf.INT_I),
		.INT_O(wb_intf.INT_O),

		.ADR_I(wb_intf.ADR_I),
		.SDAT_I(wb_intf.SDAT_I),
		.SDAT_O(wb_intf.SDAT_O),
		.SEL_I(wb_intf.SEL_I),
		.CYC_I(wb_intf.CYC_I),
		.STB_I(wb_intf.STB_I),
		.WE_I(wb_intf.WE_I),
		.CAB_I(wb_intf.CAB_I),
		.CTI_I(wb_intf.CTI_I),
		.BTE_I(wb_intf.BTE_I),
		.ACK_O(wb_intf.ACK_O),
		.RTY_O(wb_intf.RTY_O),
		.ERR_O(wb_intf.ERR_O),

		.ADR_O(wb_intf.ADR_O),
		.MDAT_I(wb_intf.MDAT_I),
		.MDAT_O(wb_intf.MDAT_O),
		.SEL_O(wb_intf.SEL_O),
		.CYC_O(wb_intf.CYC_O),
		.STB_O(wb_intf.STB_O),
		.WE_O(wb_intf.WE_O),
		.CTI_O(wb_intf.CTI_O),
		.BTE_O(wb_intf.BTE_O),
		.ACK_I(wb_intf.ACK_I),
		.RTY_I(wb_intf.RTY_I),
		.ERR_I(wb_intf.ERR_I)
	);


	
	//////////////////////////////////////////////////////////////////////////////
	/*********************starting the execution uvm phases**********************/
	//////////////////////////////////////////////////////////////////////////////
	initial begin
		run_test("pci_bridge_rw_conf_test");
	end
	//////////////////////////////////////////////////////////////////////////////
	/**********Set the Interface instance Using Configuration Database***********/
	//////////////////////////////////////////////////////////////////////////////
	initial begin
		uvm_config_db#(virtual pci_bridge_pci_interface)::set(uvm_root::get(),"*","intf",pci_intf);
		uvm_config_db#(virtual pci_bridge_wb_interface)::set(uvm_root::get(),"*","intf",wb_intf);
	end

endmodule

`endif



