`ifndef PCI_HEADER_SCAN_SEQ 
`define PCI_HEADER_SCAN_SEQ
class pci_header_scan_seq extends uvm_sequence#(pci_transaction);

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_header_scan_seq)
	pci_config_read_seq read_seq;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_header_scan_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Scan all PCI predefined register
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		bit [7:0] addr;
		read_seq = pci_config_read_seq::type_id::create("req");
		read_seq.configure(m_sequencer);
		for (addr = VENDOR_DEVICE_ID; addr <= INT_INFO; addr += 3'b100) begin
			read_seq.read_transaction(addr);
		end
    	`uvm_info(get_type_name(), "header scan sequence completed", UVM_LOW)
	endtask
	 
endclass

`endif


