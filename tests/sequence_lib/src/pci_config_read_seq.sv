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
		req = pci_config_read_transaction::type_id::create("req");
		for (bit [31:0] test_address = 32'h800;
			test_address < 32'h840; test_address += 4) begin
				start_item(req);
				assert(req.randomize() with {
					address == test_address;
				})
				else `uvm_error("PCI_READ_SEQ", "Randomization failed")
				finish_item(req);
				get_response(rsp);
		end
	endtask
	 
endclass

`endif


