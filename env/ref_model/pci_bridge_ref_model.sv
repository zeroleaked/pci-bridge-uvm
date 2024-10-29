`ifndef PCI_BRIDGE_REF_MODEL 
`define PCI_BRIDGE_REF_MODEL

class pci_bridge_ref_model extends uvm_component;
	`uvm_component_utils(pci_bridge_ref_model)
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Local Signals 
	//////////////////////////////////////////////////////////////////////////////
	// inputs
	`uvm_analysis_imp_decl(_pci)
	`uvm_analysis_imp_decl(_wb)
	uvm_analysis_imp_pci #(pci_transaction, pci_bridge_ref_model) pci_imp;
	uvm_analysis_imp_wb #(wb_transaction, pci_bridge_ref_model) wb_imp;
	// outputs
	uvm_analysis_port#(pci_transaction) pci_rm2sb_port;
	uvm_analysis_port#(wb_transaction) wb_rm2sb_port;
	// input queues
	pci_transaction pci_queue[$];
	wb_transaction wb_queue[$];

	pci_transaction pci_trans;
	wb_transaction wb_trans;

	protected pci_register_handler register_handler;

	//////////////////////////////////////////////////////////////////////////////
	//constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name="pci_bridge_ref_model", uvm_component parent);
		super.new(name, parent);
		register_handler = pci_register_handler::type_id::create("register_handler");
		pci_rm2sb_port = new("pci_rm2sb_port", this);
		wb_rm2sb_port = new("wb_rm2sb_port", this);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : build-phase 
	// Description : construct the components such as.. driver,monitor,sequencer..etc
	///////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pci_imp = new("pci_imp", this);
		wb_imp = new("wb_imp", this);
	endfunction : build_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : write_*
	// Description : Analysis port write implementations
	///////////////////////////////////////////////////////////////////////////////
	function void write_pci(pci_transaction trans);
		pci_queue.push_back(trans);
	endfunction: write_pci
	function void write_wb(wb_transaction trans);
		wb_queue.push_back(trans);
	endfunction: write_wb
	//////////////////////////////////////////////////////////////////////////////
	// Method name : run 
	// Description : Process the dut inputs
	//////////////////////////////////////////////////////////////////////////////
	task run_phase(uvm_phase phase);
		forever begin
			wait((pci_queue.size() > 0) || (wb_queue.size() > 0));
			
			if (pci_queue.size() > 0) begin
				pci_trans = pci_queue.pop_front();
				pci_expected_transaction();
				pci_rm2sb_port.write(pci_trans);
				// `uvm_info(get_type_name(), "rm tx", UVM_LOW)
				// pci_trans.print();
			end
			if (wb_queue.size() > 0) begin
				wb_trans = wb_queue.pop_front();
				wb_expected_transaction();
				wb_rm2sb_port.write(wb_trans);
				// `uvm_info(get_type_name(), "rm tx", UVM_LOW)
				// wb_trans.print();
			end
		end
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : pci_expected_transaction 
	// Description : Task for processing PCI transaction
	//////////////////////////////////////////////////////////////////////////////
	task pci_expected_transaction();
		// check base address
		bit [31:0] base_addr = register_handler.read_config(BAR0);
		bit is_in_range = (pci_trans.address >= base_addr) &&
			(pci_trans.address < (base_addr + 12'h200));
		if (pci_trans.is_config() | is_in_range) begin
			if (pci_trans.is_write())	
				register_handler.write_config(pci_trans.address[11:0], pci_trans.data);
			else
				pci_trans.data = register_handler.read_config(pci_trans.address[11:0]);
		end
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : wb_expected_transaction 
	// Description : Task for processing WB transaction
	//////////////////////////////////////////////////////////////////////////////
	task wb_expected_transaction();
		bit is_in_range;
		bit [31:0] mask, img_addr;
		// check if in range of image
		mask = register_handler.read_config(W_AM1);
		img_addr = register_handler.read_config(W_BA1);
		is_in_range = (wb_trans.address & mask) == (img_addr & mask);
		// if in range, propagate to pci bus
		if (is_in_range) begin
			pci_trans = pci_transaction::type_id::create("pci_exp_trans", this);
			pci_trans.address = wb_trans.address & mask;
			pci_trans.data = wb_trans.data;
			pci_trans.byte_en = ~wb_trans.select; // pci is active low, wb is active high
			pci_trans.command = MEM_WRITE;
			pci_rm2sb_port.write(pci_trans);
		end
	endtask
endclass

`endif