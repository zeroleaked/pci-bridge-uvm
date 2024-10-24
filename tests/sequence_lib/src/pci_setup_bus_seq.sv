`ifndef PCI_SETUP_BUS_SEQ
`define PCI_SETUP_BUS_SEQ
class pci_setup_bus_seq extends uvm_sequence#(pci_transaction);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_setup_bus_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_setup_bus_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		// turn on I/O Space (0) and Memory Space (1) accesses, turn on bus master (2) 
		do_config_write(COMMAND_STATUS, 32'h7);
		// set target base address to 1000_0000
		do_config_write(BAR0, TAR0_BASE_ADDR_0);
    	`uvm_info(get_type_name(), "write config sequence completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : do_config_write 
	// Description : Task to send a write transaction
	//////////////////////////////////////////////////////////////////////////////
	task do_config_write(input bit [7:0] req_address, input bit [31:0] req_data);
		req = pci_transaction::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			command		== CFG_WRITE;
			address		== req_address;
			data		== req_data;
			byte_en		== 4'h0;
		})
		else `uvm_error(get_type_name(), "Randomization failed");
		finish_item(req);
		get_response(rsp);
	endtask

endclass

`endif


