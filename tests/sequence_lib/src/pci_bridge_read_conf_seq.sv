`ifndef PCI_BRIDGE_READ_CONF_SEQ 
`define PCI_BRIDGE_READ_CONF_SEQ
class pci_bridge_read_conf_seq extends uvm_sequence#(pci_bridge_pci_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_bridge_read_conf_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_bridge_read_conf_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Body of sequence to send randomized transaction through
	// sequencer to driver
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		req = pci_bridge_pci_transaction::type_id::create("req");
		for (bit [31:0] test_address = 32'h0;
			test_address < 32'h40; test_address += 4) begin
				start_item(req);
				assert(req.randomize() with {
					is_reset == 0;
					is_write == 0;
					address == test_address;
				})
				else `uvm_error("PCI_READ_SEQ", "Randomization failed")
				finish_item(req);
				get_response(rsp);
		end
	endtask
	 
endclass

`endif


