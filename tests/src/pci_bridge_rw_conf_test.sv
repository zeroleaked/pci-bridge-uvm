`ifndef PCI_BRIDGE_RW_TEST 
`define PCI_BRIDGE_RW_TEST

class pci_bridge_rw_conf_test extends uvm_test;
 
	////////////////////////////////////////////////////////////////////
	//declaring component utils for the basic test-case 
	////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_rw_conf_test)
 
	pci_bridge_environment		env;
	pci_bridge_read_conf_seq	read_conf_seq;
	pci_bridge_reset_seq		reset_seq;
	////////////////////////////////////////////////////////////////////
	// Method name : new
	// Decription: Constructor 
	////////////////////////////////////////////////////////////////////
	function new(string name = "pci_bridge_rw_conf_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new
	////////////////////////////////////////////////////////////////////
	// Method name : build_phase 
	// Decription: Construct the components and objects 
	////////////////////////////////////////////////////////////////////
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
 
		env = pci_bridge_environment::type_id::create("env", this);
		read_conf_seq = pci_bridge_read_conf_seq::type_id::create("seq");
    	reset_seq = pci_bridge_reset_seq::type_id::create("seq");
	endfunction : build_phase
	////////////////////////////////////////////////////////////////////
	// Method name : run_phase 
	// Decription: Trigger the sequences to run 
	////////////////////////////////////////////////////////////////////
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			reset_seq.start(env.pci_agent.sequencer);
    		`uvm_info(get_type_name(), "reset sequence completed", UVM_LOW)
			read_conf_seq.start(env.pci_agent.sequencer);
    		`uvm_info(get_type_name(), "read sequence completed", UVM_LOW)
		phase.drop_objection(this);
	endtask : run_phase
 
endclass : pci_bridge_rw_conf_test

`endif












