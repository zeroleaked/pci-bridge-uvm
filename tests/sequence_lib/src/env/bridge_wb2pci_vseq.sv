`ifndef BRIDGE_WB2PCI_VSEQ
`define BRIDGE_WB2PCI_VSEQ
class bridge_wb2pci_vseq extends uvm_sequence#(uvm_sequence_item);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(bridge_wb2pci_vseq)
	pci_sequencer pci_sequencer;
	wb_sequencer wb_sequencer;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "bridge_wb2pci_vseq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		wb_img1_seq wb_write;
		pci_target_seq pci_target;
		
		wb_img1_seq wb_read;
		
		bit [31:0] test_addr, test_data;

		test_addr = 32'h3;
		test_data = 32'h12153524;

		wb_write = wb_img1_seq::type_id::create("req");
		wb_write.configure(wb_sequencer);
		wb_write.write_transaction(test_addr, test_data);

		pci_target = pci_target_seq::type_id::create("req");
		pci_target.start(pci_sequencer);
    	`uvm_info(get_type_name(), "normal single memory write through wb image to pci sequence completed", UVM_LOW)


		
	endtask

endclass

`endif


