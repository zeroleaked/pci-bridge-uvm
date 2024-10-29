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
	// Description : Reset all device register
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		pci_memory_write_seq write_seq;
		bit [31:0] addr;
		write_seq = pci_memory_write_seq::type_id::create("req");
		write_seq.configure(m_sequencer);
		for (addr = P_TA0; addr <= W_TA5; addr += 3'b100) begin
			write_seq.write_transaction(addr, 32'h0);
		end
    	`uvm_info(get_type_name(), "register reset sequence completed", UVM_LOW)
	endtask

endclass

`endif


