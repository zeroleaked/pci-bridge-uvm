`ifndef PCI_BRIDGE_SEQ_LIST 
`define PCI_BRIDGE_SEQ_LIST

package pci_bridge_seq_list;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

 import pci_bridge_pkg::*;
 import pci_bridge_pci_agent_pkg::*;
 import pci_bridge_wb_agent_pkg::*;

 //////////////////////////////////////////////////////////////////////////////
 // including pci_bridge test list
 //////////////////////////////////////////////////////////////////////////////

 `include "pci_config_read_seq.sv"
 `include "pci_config_write_seq.sv"
 `include "pci_memory_read_seq.sv"
 `include "pci_memory_write_seq.sv"

endpackage

`endif
