`ifndef PCI_MEMORY_WRITE_SEQ 
`define PCI_MEMORY_WRITE_SEQ
class pci_memory_write_seq extends uvm_sequence#(pci_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_memory_write_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_memory_write_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		bit [31:0] write_address;
		req = pci_transaction::type_id::create("req");
		for (bit [31:0] register_address = P_TA0;
		register_address <= W_TA5; register_address += 3'b100) begin
			write_address = TAR0_BASE_ADDR_0 | register_address;
			start_item(req);
			assert(req.randomize() with {
				command == MEM_WRITE;
				address == write_address;
				data == 32'h0;
				byte_en	== 4'h0;
			})
			else `uvm_error(get_type_name(), "Randomization failed")
			finish_item(req);
			get_response(rsp);
		end
    	`uvm_info(get_type_name(), "write memory sequence completed", UVM_LOW)
	endtask

endclass

`endif


