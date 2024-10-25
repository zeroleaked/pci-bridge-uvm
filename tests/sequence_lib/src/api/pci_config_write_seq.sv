`ifndef PCI_CONFIG_WRITE_SEQ
`define PCI_CONFIG_WRITE_SEQ
class pci_config_write_seq extends pci_api_base_seq;
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
	// Method name : do_randomize 
	// Description : Setup randomize constraints for config read
	//////////////////////////////////////////////////////////////////////////////
	virtual function bit do_randomize();
		return req.randomize() with {
			req.command == CFG_WRITE;
			req.address == req_address;
			req.data == req_data;
			req.byte_en	== 4'h0;
		};
	endfunction
	 
endclass

`endif


