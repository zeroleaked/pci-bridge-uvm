`ifndef PCI_BRIDGE_REF_MODEL 
`define PCI_BRIDGE_REF_MODEL

class pci_bridge_ref_model extends uvm_component;
	`uvm_component_utils(pci_bridge_ref_model)
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Local Signals 
	//////////////////////////////////////////////////////////////////////////////
	uvm_analysis_export#(pci_transaction) pci_rm_export;
	uvm_analysis_port#(pci_transaction) pci_rm2sb_port;
	pci_transaction pci_exp_trans;
	pci_transaction pci_rm_trans;
	uvm_tlm_analysis_fifo#(pci_transaction) pci_rm_exp_fifo;

	uvm_analysis_export#(wb_transaction) wb_rm_export;
	uvm_analysis_port#(wb_transaction) wb_rm2sb_port;
	wb_transaction wb_exp_trans,wb_rm_trans;
	uvm_tlm_analysis_fifo#(wb_transaction) wb_rm_exp_fifo;

	protected pci_register_handler register_handler;

	//////////////////////////////////////////////////////////////////////////////
	//constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name="pci_bridge_ref_model", uvm_component parent);
		super.new(name, parent);
		register_handler = pci_register_handler::type_id::create("register_handler");
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : build-phase 
	// Description : construct the components such as.. driver,monitor,sequencer..etc
	///////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pci_rm_export = new("pci_rm_export", this);
		pci_rm2sb_port = new("pci_rm2sb_port", this);
		pci_rm_exp_fifo = new("pci_rm_exp_fifo", this);

		wb_rm_export = new("wb_rm_export", this);
		wb_rm2sb_port = new("wb_rm2sb_port", this);
		wb_rm_exp_fifo = new("wb_rm_exp_fifo", this);
	endfunction : build_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : connect_phase 
	// Description : connect tlm ports ande exports (ex: analysis port/exports) 
	///////////////////////////////////////////////////////////////////////////////
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		pci_rm_export.connect(pci_rm_exp_fifo.analysis_export);
		wb_rm_export.connect(wb_rm_exp_fifo.analysis_export);
	endfunction : connect_phase
	//////////////////////////////////////////////////////////////////////////////
	// Method name : run 
	// Description : Process the dut inputs
	//////////////////////////////////////////////////////////////////////////////
	task run_phase(uvm_phase phase);
		forever begin
			pci_rm_exp_fifo.get(pci_rm_trans);
			get_expected_transaction(pci_rm_trans);
			pci_rm2sb_port.write(pci_exp_trans);
		end
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : get_expected_transaction 
	// Description : Expected transaction 
	//////////////////////////////////////////////////////////////////////////////
	task get_expected_transaction(pci_transaction trans);
		pci_exp_trans = trans;
		
		if (pci_exp_trans.is_write())	
			register_handler.write_config(pci_exp_trans.address[11:0], pci_exp_trans.data);
		else
			pci_exp_trans.data = register_handler.read_config(pci_exp_trans.address[11:0]);
	endtask
endclass

`endif