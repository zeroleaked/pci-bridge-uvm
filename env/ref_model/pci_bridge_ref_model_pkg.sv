`ifndef PCI_BRIDGE_REF_MODEL_PKG
`define PCI_BRIDGE_REF_MODEL_PKG

package pci_bridge_ref_model_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	//////////////////////////////////////////////////////////
	// importing packages : agent,ref model, register ...
	/////////////////////////////////////////////////////////
	import pci_bridge_pci_agent_pkg::*;
	import pci_bridge_wb_agent_pkg::*;
	import pci_bridge_ref_model_register_pkg::*;

	//////////////////////////////////////////////////////////
	// include ref model files 
	/////////////////////////////////////////////////////////
	`include "pci_config_handler.sv"
	`include "pci_bridge_ref_model.sv"

endpackage

`endif



