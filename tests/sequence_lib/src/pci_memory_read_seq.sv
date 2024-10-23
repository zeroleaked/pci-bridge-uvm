`ifndef PCI_MEMORY_READ_SEQ 
`define PCI_MEMORY_READ_SEQ
class pci_memory_read_seq extends uvm_sequence#(pci_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_memory_read_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_memory_read_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		// Target scan registers (aside from PCI configuration space 0x000-0x0FF)
		for (bit [7:0] test_address = 8'h00;
		test_address < 8'hec; test_address += 4) begin
			do_memory_read({{4'h1}, {20'h1}, {test_address}});
		end
    	`uvm_info(get_type_name(), "read memory completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : do_config_write 
	// Description : Task to send a write transaction
	//////////////////////////////////////////////////////////////////////////////
	task do_memory_read(input bit [31:0] req_address);
		req = pci_transaction::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			command		== MEM_READ;
			address		== req_address;
			byte_en		== 4'h0;
		})
		else `uvm_error("PCI_MEMORY_WRITE_SEQ", "Randomization failed");
		finish_item(req);
		get_response(rsp);
	endtask
endclass

`endif


