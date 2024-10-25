`ifndef PCI_BRIDGE_WB_AGENT_PKG
`define PCI_BRIDGE_WB_AGENT_PKG

package pci_bridge_wb_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
  // `include "pci_bridge_wb_defines.svh" use this for agent constants
  `include "wb_transaction.sv"
  `include "wb_driver.sv"
  `include "wb_sequencer.sv"
  `include "wb_monitor.sv"
  `include "pci_bridge_wb_agent.sv"

endpackage

`endif



