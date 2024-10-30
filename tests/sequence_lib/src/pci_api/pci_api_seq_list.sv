`ifndef PCI_API_SEQ_LIST
`define PCI_API_SEQ_LIST

package pci_api_seq_list;
 
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pkg::*;
	import pci_bridge_pci_agent_pkg::*;

	`include "pci_initiator_base_seq.sv"
	`include "pci_config_read_seq.sv"
	`include "pci_config_write_seq.sv"
	`include "pci_memory_read_seq.sv"
	`include "pci_memory_write_seq.sv"

	`include "pci_target_base_seq.sv"
	`include "pci_resp_mem_w_seq.sv"
	`include "pci_resp_mem_r_seq.sv"

endpackage

`endif



