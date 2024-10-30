`ifndef PCI_INITIATOR_BASE_SEQ
`define PCI_INITIATOR_BASE_SEQ
class pci_initiator_base_seq extends uvm_sequence#(pci_transaction);
	bit [31:0] req_address;
	bit [31:0] req_data;
	uvm_sequencer_base sequencer;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils_begin(pci_initiator_base_seq)
		`uvm_field_int(req_address, UVM_ALL_ON)
		`uvm_field_int(req_data, UVM_ALL_ON)
	`uvm_object_utils_end
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_initiator_base_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		req = pci_transaction::type_id::create("req");
		start_item(req);
		assert(do_randomize())
		else `uvm_error(get_type_name(), "Randomization failed")
		finish_item(req);
		get_response(rsp);
    	// `uvm_info(get_type_name(), "read config sequence completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : do_randomize 
	// Description : Pure virtual method - must be implemented by derived classes
	//////////////////////////////////////////////////////////////////////////////
	virtual function bit do_randomize();
        `uvm_fatal(get_type_name(), "do_randomize() not implemented in derived class!")
        return 0;
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : set_address 
	// Description : set address to one of the register
	//////////////////////////////////////////////////////////////////////////////
	virtual task set_address(input bit [31:0] address);
		this.req_address = address;
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : configure
	// Description : one-time setup
	//////////////////////////////////////////////////////////////////////////////
	task configure(input uvm_sequencer_base sequencer);
		this.sequencer = sequencer;
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : write_transaction
	// Description : do a write pci transaction
	//////////////////////////////////////////////////////////////////////////////
	task write_transaction(input bit [31:0] address, data);
		set_address(address);
		req_data = data;
		start(sequencer);
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : read_transaction
	// Description : do a read pci transaction
	//////////////////////////////////////////////////////////////////////////////
	task read_transaction(input bit [31:0] address);
		set_address(address);
		start(sequencer);
	endtask
	 
endclass

`endif


