`ifndef PCI_CONFIG_READ_SEQ
`define PCI_CONFIG_READ_SEQ
class pci_config_read_seq extends uvm_sequence#(pci_transaction);
	rand bit [7:0] addr;
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
		req = pci_transaction::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {
			command == CFG_READ;
			address == addr;
			byte_en	== 4'hF;
		})
		else `uvm_error(get_type_name(), "Randomization failed")
		finish_item(req);
		get_response(rsp);
    	// `uvm_info(get_type_name(), "read config sequence completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : set_address 
	// Description : set address to one of the register of PCI predefined header
	//////////////////////////////////////////////////////////////////////////////
	task set_address(input bit [7:0] address);
		this.addr = address;
	endtask
	 
endclass

`endif


