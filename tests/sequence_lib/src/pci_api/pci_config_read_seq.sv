`ifndef PCI_CONFIG_READ_SEQ
`define PCI_CONFIG_READ_SEQ
class pci_config_read_seq extends pci_initiator_base_seq;
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
	// Method name : do_randomize 
	// Description : Setup randomize constraints for config read
	//////////////////////////////////////////////////////////////////////////////
	function bit do_randomize();
		// bit ok;
		return req.randomize() with {
			req.command == CFG_READ;
			req.address == req_address;
			req.byte_en	== 4'hF;
			req.role == PCI_INITIATOR;
		};
		// return ok;
	endfunction
	 
endclass

`endif


