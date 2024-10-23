`ifndef PCI_CONFIG_READ_SEQ 
`define PCI_CONFIG_READ_SEQ
class pci_config_read_seq extends uvm_sequence#(pci_config_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_config_read_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_config_read_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		req = pci_config_transaction::type_id::create("req");
		for (bit [7:0] test_address = VENDOR_DEVICE_ID;
			test_address <= INT_INFO; test_address += 3'b100) begin
				start_item(req);
				assert(req.randomize() with {
					command == CFG_READ;
					reg_addr == test_address;
					byte_en		== 4'h0;
				})
				else `uvm_error("PCI_READ_SEQ", "Randomization failed")
				finish_item(req);
				get_response(rsp);
		end
    	`uvm_info(get_type_name(), "read sequence completed", UVM_LOW)
	endtask
	 
endclass

`endif


