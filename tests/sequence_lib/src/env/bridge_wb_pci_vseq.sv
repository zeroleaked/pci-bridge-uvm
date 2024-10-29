`ifndef BRIDGE_WB_PCI_VSEQ
`define BRIDGE_WB_PCI_VSEQ
class bridge_wb_pci_vseq extends uvm_sequence#(uvm_sequence_item);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(bridge_wb_pci_vseq)
	pci_sequencer pci_sequencer;
	wb_sequencer wb_sequencer;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "bridge_wb_pci_vseq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		wb_write_seq write_seq;
		// wb_read_seq read_seq;

		write_seq = wb_write_seq::type_id::create("req");
		write_seq.configure(wb_sequencer);
		write_seq.write_transaction(32'h3, 32'h12153524);
    	`uvm_info(get_type_name(), "normal single memory write through wb image to pci sequence completed", UVM_LOW)

		
	endtask

endclass

`endif


