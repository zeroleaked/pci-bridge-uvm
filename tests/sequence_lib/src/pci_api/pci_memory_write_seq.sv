`ifndef PCI_MEMORY_WRITE_SEQ
`define PCI_MEMORY_WRITE_SEQ
class pci_memory_write_seq extends pci_initiator_base_seq;
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
	// Method name : set_address 
	// Description : override base set_address 
	//////////////////////////////////////////////////////////////////////////////
	task set_address(input bit [31:0] address);
		this.req_address = address | TAR_BASE_ADDR_0;
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : do_randomize 
	// Description : Setup randomize constraints for config read
	//////////////////////////////////////////////////////////////////////////////
	function bit do_randomize();
		return req.randomize() with {
			req.command == MEM_WRITE;
			req.address == req_address;
			req.data == req_data;
			req.byte_en	== 4'hF;
			req.trans_type == PCI_INITIATOR;
		};
	endfunction
	 
endclass

`endif


