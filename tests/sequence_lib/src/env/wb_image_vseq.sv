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
		wb_pci_rw_vseq rw_vseq;
		wb_same_addr_rd_vseq mr_sa_vseq;
		wb_multi_write_vseq mw_ma_vseq;

		image_cfg_seq = pci_wb_image_config_seq::type_id::create("req");
		image_cfg_seq.start(pci_sequencer);

		rw_vseq = wb_pci_rw_vseq::type_id::create("req");
		rw_vseq.start_with(pci_sequencer, wb_sequencer);

		mr_sa_vseq = wb_same_addr_rd_vseq::type_id::create("req");
		mr_sa_vseq.start_with(pci_sequencer, wb_sequencer);

		mw_ma_vseq = wb_multi_write_vseq::type_id::create("req");
		mw_ma_vseq.start_with(pci_sequencer, wb_sequencer);

    	`uvm_info(get_type_name(), "wb image test sequence completed", UVM_LOW)
		
	endtask

endclass

`endif

pci_memory_write_seq.sv
pci_bridge_scoreboard.sv