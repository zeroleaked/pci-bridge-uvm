`ifndef PCI_WORKER_SEQ_LIST 
`define PCI_WORKER_SEQ_LIST

package pci_worker_seq_list;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pkg::*;
	import pci_bridge_pci_agent_pkg::pci_transaction;
	import pci_api_seq_list::*;

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
