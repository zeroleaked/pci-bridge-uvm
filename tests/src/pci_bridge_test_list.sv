`ifndef PCI_BRIDGE_TEST_LIST 
`define PCI_BRIDGE_TEST_LIST

package pci_bridge_test_list;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

 import pci_bridge_env_pkg::*;
 import pci_bridge_pkg::*;
 import wb_api_seq_pkg::*;
 import bridge_seq_list::*;
 import pci_worker_seq_list::*;

 //////////////////////////////////////////////////////////////////////////////
 // including pci_bridge test list
 //////////////////////////////////////////////////////////////////////////////

 `include "pci_bridge_rw_conf_test.sv"

endpackage 

`endif





