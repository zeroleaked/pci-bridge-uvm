`ifndef PCI_BRIDGE_SEQ_LIST 
`define PCI_BRIDGE_SEQ_LIST

package pci_bridge_seq_list;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

 import pci_bridge_pci_agent_pkg::*;
 import pci_bridge_wb_agent_pkg::*;
 import pci_bridge_ref_model_pkg::*;
 import pci_bridge_env_pkg::*;

 //////////////////////////////////////////////////////////////////////////////
 // including pci_bridge test list
 //////////////////////////////////////////////////////////////////////////////

 `include "pci_bridge_reset_seq.sv"
 `include "pci_bridge_read_conf_seq.sv"

endpackage

`endif
