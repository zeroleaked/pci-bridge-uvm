`ifndef PCI_API_SEQ_PKG
`define PCI_API_SEQ_PKG

package pci_api_seq_pkg;
 
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pkg::*;
	import pci_bridge_pci_agent_pkg::*;
	`include "pci_api_base_seq.sv"
	`include "pci_config_read_seq.sv"
	`include "pci_config_write_seq.sv"
	`include "pci_memory_read_seq.sv"
	`include "pci_memory_write_seq.sv"

endpackage

`endif



