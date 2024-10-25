`ifndef PCI_REGISTER_RESET_SEQ
`define PCI_REGISTER_RESET_SEQ
class pci_register_reset_seq extends uvm_sequence#(pci_transaction);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_register_reset_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_register_reset_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Reset all device's register
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		pci_memory_write_seq write_seq;
		bit [31:0] addr;
		write_seq = pci_memory_write_seq::type_id::create("req");
		for (addr = P_TA0; addr <= W_TA5; addr += 3'b100) begin
			write_seq.set_address(addr);
			write_seq.set_data(31'h0);
			write_seq.start(m_sequencer);
		end
    	`uvm_info(get_type_name(), "register reset sequence completed", UVM_LOW)
	endtask

endclass

`endif


