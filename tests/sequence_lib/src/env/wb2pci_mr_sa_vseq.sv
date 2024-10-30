`ifndef WB2PCI_MR_SA_VSEQ
`define WB2PCI_MR_SA_VSEQ
class wb2pci_mr_sa_vseq extends bridge_base_vseq;
	// Multiple read, single address, multiple data
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(wb2pci_mr_sa_vseq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb2pci_mr_sa_vseq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		wb_read_seq wb_read;
		pci_resp_mem_r_seq pci_read_response;
		bit [31:0] test_addr = 32'h48;
		
		wb_read = wb_read_seq::type_id::create("req");
		wb_read.configure(wb_sequencer);
		pci_read_response = pci_resp_mem_r_seq::type_id::create("req");
		pci_read_response.configure(pci_sequencer);


		repeat(5) fork
			wb_read.read_transaction(test_addr);
			pci_read_response.read_response();
		join

    	`uvm_info(get_type_name(), "multiple read, single address through wb image to pci sequence completed", UVM_LOW)

		
	endtask

endclass

`endif


