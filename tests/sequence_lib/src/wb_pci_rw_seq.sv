`ifndef WB_PCI_RW_SEQ
`define WB_PCI_RW_SEQ
class wb_pci_rw_seq extends uvm_sequence#(wb_transaction);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(wb_pci_rw_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb_pci_rw_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		wb_write_seq write_seq;
		write_seq = wb_write_seq::type_id::create("req");
		write_seq.set_address(32'h3);
		write_seq.set_data(32'h12153524);
		write_seq.start(m_sequencer);
    	`uvm_info(get_type_name(), "normal single memory write through wb image to pci sequence completed", UVM_LOW)
	endtask

endclass

`endif


