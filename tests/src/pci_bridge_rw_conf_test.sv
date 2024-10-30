`ifndef PCI_BRIDGE_RW_TEST 
`define PCI_BRIDGE_RW_TEST

class pci_bridge_rw_conf_test extends uvm_test;
 
	////////////////////////////////////////////////////////////////////
	//declaring component utils for the basic test-case 
	////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_rw_conf_test)
 
	pci_bridge_environment	env;
	pci_init_seq		pci_init_seq_i;
	wb_image_vseq wb_image_vseq_i;
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
		pci_init_seq_i = pci_init_seq::type_id::create("seq");
		wb_image_vseq_i = wb_image_vseq::type_id::create("seq");
	endfunction : build_phase
	////////////////////////////////////////////////////////////////////
	// Method name : run_phase 
	// Decription: Trigger the sequences to run 
	////////////////////////////////////////////////////////////////////
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

		pci_init_seq_i.start(env.pci_agent.sequencer);

		wb_image_vseq_i.wb_sequencer = env.wb_agent.sequencer;
		wb_image_vseq_i.pci_sequencer = env.pci_agent.sequencer;
		wb_image_vseq_i.start(null);
		
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this, 1000ns);
	endtask : run_phase

endclass : pci_bridge_rw_conf_test

`endif












