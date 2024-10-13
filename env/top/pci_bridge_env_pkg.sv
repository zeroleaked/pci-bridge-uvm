`ifndef PCI_BRIDGE_ENV_PKG
`define PCI_BRIDGE_ENV_PKG

package pci_bridge_env_pkg;
   
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // importing packages : agent,ref model, register ...
   /////////////////////////////////////////////////////////
   import pci_bridge_pci_agent_pkg::*;

   //////////////////////////////////////////////////////////
   // include top env files 
   /////////////////////////////////////////////////////////
  `include "pci_bridge_scoreboard.sv"
  `include "pci_bridge_env.sv"

endpackage

`endif


