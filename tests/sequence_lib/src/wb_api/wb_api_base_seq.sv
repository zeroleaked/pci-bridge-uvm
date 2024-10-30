`ifndef WB_API_BASE_SEQ
`define WB_API_BASE_SEQ
class wb_api_base_seq extends uvm_sequence#(wb_transaction);
	bit [31:0] req_address;
	bit [31:0] req_data;
	bit is_write;
	uvm_sequencer_base sequencer;
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

		if (is_write) begin
			assert(req.randomize() with {
				req.is_write == 1'b1;
				req.address[31:2] == req_address[31:2];
				req.data == req_data;
				req.select == 4'hF;
			})
			else `uvm_error(get_type_name(), "Randomization failed")
		end
		else begin // read
			assert(req.randomize() with {
				req.is_write == 1'b0;
				req.address[31:2] == req_address[31:2];
				req.select == 4'hF;
			})
			else `uvm_error(get_type_name(), "Randomization failed")
		end

		finish_item(req);
		get_response(rsp);
    	// `uvm_info(get_type_name(), "read config sequence completed", UVM_LOW)
	endtask
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
	// Description : do a write wb transaction
	//////////////////////////////////////////////////////////////////////////////
	task write_transaction(input bit [31:0] address, data);
		set_address(address);
		req_data = data;
		is_write = 1;
		start(sequencer);
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : read_transaction
	// Description : do a read wb transaction
	//////////////////////////////////////////////////////////////////////////////
	task read_transaction(input bit [31:0] address);
		set_address(address);
		is_write = 0;
		start(sequencer);
	endtask
	 
endclass

`endif


