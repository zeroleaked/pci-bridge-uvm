`ifndef PCI_CONFIG_WRITE_SEQ 
`define PCI_CONFIG_WRITE_SEQ
class pci_config_write_seq extends uvm_sequence#(pci_config_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_config_write_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_config_write_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		// turn on I/O Space (0) and Memory Space (1) accesses, turn on bus master (2) 
		do_config_write(8'h04, 32'h00000007);
		// set base address to 1000_0000
		do_config_write(8'h10, 32'h10000000);
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : do_config_write 
	// Description : Task to send a write transaction
	//////////////////////////////////////////////////////////////////////////////
	task do_config_write(input bit [5:0] req_address, input bit [31:0] req_data);
		req = pci_config_write_transaction::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			reg_addr  == req_address;
			data     == req_data;
		})
		else `uvm_error("PCI_CONFIG_WRITE_SEQ", "Randomization failed");
		finish_item(req);
		get_response(rsp);
	endtask

endclass

`endif


