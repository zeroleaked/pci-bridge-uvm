`ifndef WB_PCI_RW_VSEQ
`define WB_PCI_RW_VSEQ
class wb_pci_rw_vseq extends bridge_base_vseq;
	// Single normal read and write from wishbone to pci
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(wb_pci_rw_vseq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb_pci_rw_vseq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	task body();
		wb_write_seq wb_write;
		pci_resp_mem_w_seq pci_write_response;
		wb_read_seq wb_read;
		pci_resp_mem_r_seq pci_read_response;
		
		bit [31:0] test_addr, test_data;

		test_addr = 32'h0;

		// wb master
		wb_write = wb_write_seq::type_id::create("req");
		wb_write.configure(wb_sequencer);
		wb_write.write_transaction(test_addr);

		// pci target
		pci_write_response = pci_resp_mem_w_seq::type_id::create("req");
		pci_write_response.configure(pci_sequencer);
		pci_write_response.write_response();
		
		test_data = pci_write_response.rsp.data;
    	`uvm_info(get_type_name(), "normal single memory write through wb image to pci sequence completed", UVM_LOW)

		// unlike write transactions, wb read transactions ask for retry until
		// pci targets respond. So, we have to do the sequence in parallel
		wb_read = wb_read_seq::type_id::create("req");
		wb_read.configure(wb_sequencer);
		pci_read_response = pci_resp_mem_r_seq::type_id::create("req");
		pci_read_response.configure(pci_sequencer);

		fork
			wb_read.read_transaction(test_addr);
			pci_read_response.read_response_with_data(test_data);
		join
    	`uvm_info(get_type_name(), "normal single memory read through wb image to pci sequence completed", UVM_LOW)
	endtask

endclass

`endif


