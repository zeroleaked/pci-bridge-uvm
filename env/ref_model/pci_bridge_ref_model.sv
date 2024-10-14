`ifndef PCI_BRIDGE_REF_MODEL 
`define PCI_BRIDGE_REF_MODEL

class pci_bridge_ref_model extends uvm_component;
	`uvm_component_utils(pci_bridge_ref_model)
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Local Signals 
	//////////////////////////////////////////////////////////////////////////////
	uvm_analysis_export#(pci_bridge_pci_transaction) rm_export;
	uvm_analysis_port#(pci_bridge_pci_transaction) rm2sb_port;
	pci_bridge_pci_transaction exp_trans,rm_trans;
	uvm_tlm_analysis_fifo#(pci_bridge_pci_transaction) rm_exp_fifo;
	//////////////////////////////////////////////////////////////////////////////
	//constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name="pci_bridge_ref_model", uvm_component parent);
		super.new(name,parent);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : build-phase 
	// Description : construct the components such as.. driver,monitor,sequencer..etc
	///////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rm_export = new("rm_export", this);
		rm2sb_port = new("rm2sb_port", this);
		rm_exp_fifo = new("rm_exp_fifo", this);
	endfunction : build_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : connect_phase 
	// Description : connect tlm ports ande exports (ex: analysis port/exports) 
	///////////////////////////////////////////////////////////////////////////////
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		rm_export.connect(rm_exp_fifo.analysis_export);
	endfunction : connect_phase
	//////////////////////////////////////////////////////////////////////////////
	// Method name : run 
	// Description : Driving the dut inputs
	//////////////////////////////////////////////////////////////////////////////
	task run_phase(uvm_phase phase);
		forever begin
			rm_exp_fifo.get(rm_trans);
			get_expected_transaction(rm_trans);
		end
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : get_expected_transaction 
	// Description : Expected transaction 
	//////////////////////////////////////////////////////////////////////////////
	task get_expected_transaction(pci_bridge_pci_transaction rm_trans);
		this.exp_trans =	rm_trans ;
		`uvm_info(get_full_name(),$sformatf("EXPECTED TRANSACTION FROM REF MODEL"),UVM_LOW);
		exp_trans.print();
		exp_trans.operation = pci_bridge_pci_transaction::RESET;
		rm2sb_port.write(exp_trans);
	endtask

endclass

`endif










