`ifndef WB_API_BASE_SEQ
`define WB_API_BASE_SEQ
class wb_api_base_seq extends uvm_sequence#(wb_transaction);
	bit [31:0] req_address;
	bit [31:0] req_data;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils_begin(wb_api_base_seq)
		`uvm_field_int(req_address, UVM_ALL_ON)
		`uvm_field_int(req_data, UVM_ALL_ON)
	`uvm_object_utils_end
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb_api_base_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		req = wb_transaction::type_id::create("req");
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
	task set_address(input bit [31:0] address);
		this.req_address = address;
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : set_data
	// Description : set data to be write to register
	//////////////////////////////////////////////////////////////////////////////
	task set_data(input bit [31:0] data);
		this.req_data = data;
	endtask
	 
endclass

`endif


