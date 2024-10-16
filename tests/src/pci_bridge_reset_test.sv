`ifndef PCI_BRIDGE_RESET_TEST 
`define PCI_BRIDGE_RESET_TEST

class pci_bridge_reset_test extends uvm_test;
 
  ////////////////////////////////////////////////////////////////////
  //declaring component utils for the basic test-case 
  ////////////////////////////////////////////////////////////////////
  `uvm_component_utils(pci_bridge_reset_test)
 
  pci_bridge_environment     env;
  pci_bridge_reset_seq       seq;
  ////////////////////////////////////////////////////////////////////
  // Method name : new
  // Decription: Constructor 
  ////////////////////////////////////////////////////////////////////
  function new(string name = "pci_bridge_reset_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
  ////////////////////////////////////////////////////////////////////
  // Method name : build_phase 
  // Decription: Construct the components and objects 
  ////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    env = pci_bridge_environment::type_id::create("env", this);
    seq = pci_bridge_reset_seq::type_id::create("seq");
  endfunction : build_phase
  ////////////////////////////////////////////////////////////////////
  // Method name : run_phase 
  // Decription: Trigger the sequences to run 
  ////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
     seq.start(env.pci_agent.sequencer);
    phase.drop_objection(this);
  endtask : run_phase
 
endclass : pci_bridge_reset_test

`endif












