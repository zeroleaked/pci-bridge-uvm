`ifndef PCI_BRIDGE_API_SEQ_PKG
`define PCI_BRIDGE_API_SEQ_PKG

package pci_api_seq_pkg;
 
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pci_agent_pkg::*;
	`include "pci_api_base_seq.sv"
	`include "pci_config_read_seq.sv"

endpackage

`endif



