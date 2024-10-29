`ifndef PCI_MEMORY_READ_SEQ_NEW
`define PCI_MEMORY_READ_SEQ_NEW
class pci_memory_read_seq extends pci_api_base_seq;
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
	// Method name : set_address 
	// Description : override base set_address 
	//////////////////////////////////////////////////////////////////////////////
	task set_address(input bit [31:0] address);
		this.req_address = address | TAR0_BASE_ADDR_0;
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : do_randomize 
	// Description : Setup randomize constraints for config read
	//////////////////////////////////////////////////////////////////////////////
	function bit do_randomize();
		return req.randomize() with {
			req.command == MEM_READ;
			req.address == req_address;
			req.byte_en	== 4'h0;
			req.trans_type == PCI_INITIATOR;
		};
	endfunction
	 
endclass

`endif


