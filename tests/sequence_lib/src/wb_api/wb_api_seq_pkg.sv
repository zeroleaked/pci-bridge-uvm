`ifndef WB_API_SEQ_PKG
`define WB_API_SEQ_PKG

package wb_api_seq_pkg;
 
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import pci_bridge_pkg::*;
	import pci_bridge_wb_agent_pkg::*;
	`include "wb_api_base_seq.sv"
	`include "wb_read_seq.sv"
	`include "wb_write_seq.sv"

endpackage

`endif



