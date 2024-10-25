`ifndef PCI_BRIDGE_SEQ_LIST 
`define PCI_BRIDGE_SEQ_LIST

package pci_bridge_seq_list;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pkg::*;
	import pci_bridge_pci_agent_pkg::*;
	import pci_bridge_wb_agent_pkg::*;
	import pci_api_seq_pkg::*;

	//////////////////////////////////////////////////////////////////////////////
	// including pci_bridge test list
	//////////////////////////////////////////////////////////////////////////////

	`include "pci_header_scan_seq.sv"
	`include "pci_bus_setup_seq.sv"
	`include "pci_register_scan_seq.sv"
	`include "pci_register_reset_seq.sv"
	`include "pci_wb_image_config_seq.sv"
	
	`include "pci_init_seq.sv"

endpackage

`endif
