`ifndef PCI_SEQUENCER
`define PCI_SEQUENCER

class pci_sequencer extends uvm_sequencer#(pci_transaction);
 
  `uvm_component_utils(pci_sequencer)
 
  ///////////////////////////////////////////////////////////////////////////////
  //constructor
  ///////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
endclass

`endif




