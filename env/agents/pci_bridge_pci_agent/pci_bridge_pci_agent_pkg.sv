`ifndef PCI_BRIDGE_PCI_AGENT_PKG
`define PCI_BRIDGE_PCI_AGENT_PKG

package pci_bridge_pci_agent_pkg;
 
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	 //////////////////////////////////////////////////////////
	 // include Agent components : driver,monitor,sequencer
	 /////////////////////////////////////////////////////////
	// `include "pci_bridge_pci_defines.svh" use this for agent constants

	`include "pci_config_transaction.sv"
	`include "pci_config_read_transaction.sv"
	`include "pci_config_write_transaction.sv"
	`include "pci_config_sequencer.sv"
	`include "pci_config_driver.sv"
	`include "pci_config_monitor.sv"
	`include "pci_config_agent.sv"

	// `include "pci_bridge_pci_transaction.sv"
	// `include "pci_bridge_pci_sequencer.sv"
	// `include "pci_bridge_pci_driver.sv"
	// `include "pci_bridge_pci_monitor.sv"
	// `include "pci_bridge_pci_agent.sv"

endpackage

`endif



