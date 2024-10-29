`ifndef BRIDGE_SEQ_LIST 
`define BRIDGE_SEQ_LIST

package bridge_seq_list;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pkg::*;
	import pci_bridge_pci_agent_pkg::*;
	import pci_bridge_wb_agent_pkg::*;
	import pci_api_seq_list::*;
	import wb_api_seq_pkg::*;

	//////////////////////////////////////////////////////////////////////////////
	// including pci_bridge test list
	//////////////////////////////////////////////////////////////////////////////

	`include "bridge_wb2pci_vseq.sv"

endpackage

`endif
