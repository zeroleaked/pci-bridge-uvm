`ifndef PCI_BRIDGE_WB_AGENT_PKG
`define PCI_BRIDGE_WB_AGENT_PKG

package pci_bridge_wb_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
  // `include "pci_bridge_wb_defines.svh" use this for agent constants
  `include "pci_bridge_wb_transaction.sv"
  `include "pci_bridge_wb_sequencer.sv"
  `include "pci_bridge_wb_driver.sv"
  `include "pci_bridge_wb_monitor.sv"
  `include "pci_bridge_wb_agent.sv"

endpackage

`endif



