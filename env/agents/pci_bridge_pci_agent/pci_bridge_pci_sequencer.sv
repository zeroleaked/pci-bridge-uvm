`ifndef PCI_BRIDGE_PCI_SEQUENCER
`define PCI_BRIDGE_PCI_SEQUENCER

class pci_bridge_pci_sequencer extends uvm_sequencer#(pci_bridge_pci_transaction);
 
  `uvm_component_utils(pci_bridge_pci_sequencer)
 
  ///////////////////////////////////////////////////////////////////////////////
  //constructor
  ///////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
endclass

`endif




