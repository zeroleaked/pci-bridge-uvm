`ifndef WB2PCI_RW_VSEQ
`define WB2PCI_RW_VSEQ
class wb2pci_rw_vseq extends uvm_sequence#(uvm_sequence_item);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(wb2pci_rw_vseq)
	pci_sequencer pci_sequencer;
	wb_sequencer wb_sequencer;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb2pci_rw_vseq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		wb_write_seq wb_write;
		pci_resp_mem_w_seq pci_write_response;
		wb_read_seq wb_read;
		pci_resp_mem_r_seq pci_read_response;
		
		bit [31:0] test_addr, test_data;

		test_addr = 32'h0;
		test_data = 32'h12153524;

		// wb master
		wb_write = wb_write_seq::type_id::create("req");
		wb_write.configure(wb_sequencer);
		wb_write.write_transaction(test_addr, test_data);

		// pci target
		pci_write_response = pci_resp_mem_w_seq::type_id::create("req");
		pci_write_response.configure(pci_sequencer);
		pci_write_response.write_response();
    	`uvm_info(get_type_name(), "normal single memory write through wb image to pci sequence completed", UVM_LOW)

		// unlike write transactions, wb read transactions ask for retry until
		// pci targets respond. So, we have to do the sequence in parallel
		wb_read = wb_read_seq::type_id::create("req");
		wb_read.configure(wb_sequencer);
		pci_read_response = pci_resp_mem_r_seq::type_id::create("req");
		pci_read_response.configure(pci_sequencer);

		fork
			wb_read.read_transaction(test_addr);
			pci_read_response.read_response(test_data);
		join
    	`uvm_info(get_type_name(), "normal single memory read through wb image to pci sequence completed", UVM_LOW)

		
	endtask

endclass

`endif


