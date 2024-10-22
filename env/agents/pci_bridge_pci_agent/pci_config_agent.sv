`ifndef PCI_CONFIG_AGENT 
`define PCI_CONFIG_AGENT

class pci_config_agent extends uvm_agent;
  ///////////////////////////////////////////////////////////////////////////////
  // Declaration of UVC components such as.. driver,monitor,sequencer..etc
  ///////////////////////////////////////////////////////////////////////////////
  pci_config_driver    driver;
  pci_config_sequencer sequencer;
  pci_config_monitor monitor;
  ///////////////////////////////////////////////////////////////////////////////
  // Declaration of component utils 
  ///////////////////////////////////////////////////////////////////////////////
  `uvm_component_utils(pci_config_agent)
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : new 
  // Description : constructor
  ///////////////////////////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : build-phase 
  // Description : construct the components such as.. driver,monitor,sequencer..etc
  ///////////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = pci_config_driver::type_id::create("driver", this);
    sequencer = pci_config_sequencer::type_id::create("sequencer", this);
    monitor = pci_config_monitor::type_id::create("monitor", this);
  endfunction : build_phase
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : connect_phase 
  // Description : connect tlm ports ande exports (ex: analysis port/exports) 
  ///////////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase
 
endclass : pci_config_agent

`endif
