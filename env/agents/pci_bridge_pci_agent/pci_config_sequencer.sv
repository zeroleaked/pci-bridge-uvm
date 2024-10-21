`ifndef PCI_CONFIG_SEQUENCER
`define PCI_CONFIG_SEQUENCER

class pci_config_sequencer extends uvm_sequencer#(pci_config_transaction);
 
  `uvm_component_utils(pci_config_sequencer)
 
  ///////////////////////////////////////////////////////////////////////////////
  //constructor
  ///////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
endclass

`endif




