`ifndef WB_IMAGE_VSEQ
`define WB_IMAGE_VSEQ
class wb_image_vseq extends uvm_sequence#(uvm_sequence_item);
	// Test WB image
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(wb_image_vseq)
	pci_sequencer pci_sequencer;
	wb_sequencer wb_sequencer;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb_image_vseq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : write to pci
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		pci_wb_image_config_seq image_cfg_seq; 
		wb2pci_rw_vseq rw_vseq;
		wb2pci_mr_sa_vseq mr_sa_vseq;

		image_cfg_seq = pci_wb_image_config_seq::type_id::create("req");
		image_cfg_seq.start(pci_sequencer);

		rw_vseq = wb2pci_rw_vseq::type_id::create("req");
		rw_vseq.wb_sequencer = wb_sequencer;
		rw_vseq.pci_sequencer = pci_sequencer;
		rw_vseq.start(null);

		mr_sa_vseq = wb2pci_mr_sa_vseq::type_id::create("req");
		mr_sa_vseq.wb_sequencer = wb_sequencer;
		mr_sa_vseq.pci_sequencer = pci_sequencer;
		mr_sa_vseq.start(null);

    	`uvm_info(get_type_name(), "wb image test sequence completed", UVM_LOW)
		
	endtask

endclass

`endif


