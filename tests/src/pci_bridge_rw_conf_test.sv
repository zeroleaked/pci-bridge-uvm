`ifndef PCI_BRIDGE_RW_TEST 
`define PCI_BRIDGE_RW_TEST

class pci_bridge_rw_conf_test extends uvm_test;
 
	////////////////////////////////////////////////////////////////////
	//declaring component utils for the basic test-case 
	////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_rw_conf_test)
 
	pci_bridge_environment	env;
	pci_header_scan_seq		read_conf_seq;
	pci_config_write_seq	write_conf_seq;
	pci_memory_read_seq 	read_mem_seq;
	pci_memory_write_seq 	write_mem_seq;
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
		read_conf_seq = pci_header_scan_seq::type_id::create("seq");
		write_conf_seq = pci_config_write_seq::type_id::create("seq");
		read_mem_seq = pci_memory_read_seq::type_id::create("seq");
		write_mem_seq = pci_memory_write_seq::type_id::create("seq");
	endfunction : build_phase
	////////////////////////////////////////////////////////////////////
	// Method name : run_phase 
	// Decription: Trigger the sequences to run 
	////////////////////////////////////////////////////////////////////
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			read_conf_seq.start(env.pci_agent.sequencer);
			write_conf_seq.start(env.pci_agent.sequencer);
			read_conf_seq.start(env.pci_agent.sequencer);
			read_mem_seq.start(env.pci_agent.sequencer);
			write_mem_seq.start(env.pci_agent.sequencer);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this, 1000ns);
	endtask : run_phase
 
endclass : pci_bridge_rw_conf_test

`endif












