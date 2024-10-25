`ifndef PCI_REGISTER_SCAN_SEQ 
`define PCI_REGISTER_SCAN_SEQ
class pci_register_scan_seq extends uvm_sequence#(pci_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_register_scan_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_register_scan_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Scan all device dependent register
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		pci_memory_read_seq read_seq;
		bit [31:0] addr;
		read_seq = pci_memory_read_seq::type_id::create("req");
		for (addr = VENDOR_DEVICE_ID; addr <= INT_ACK; addr += 3'b100) begin
			read_seq.set_address(addr);
			read_seq.start(m_sequencer, this);
		end
    	`uvm_info(get_type_name(), "register scan sequence completed", UVM_LOW)
	endtask
	 
endclass

`endif


