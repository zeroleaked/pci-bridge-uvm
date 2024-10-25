`ifndef PCI_WB_IMAGE_CONFIG_SEQ
`define PCI_WB_IMAGE_CONFIG_SEQ
class pci_wb_image_config_seq extends uvm_sequence#(pci_transaction);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_wb_image_config_seq)
	pci_memory_write_seq write_seq;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_wb_image_config_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : reset W_ERR_CS W_IMG_CTRL1, write 0xc000_0000 to W_BA1,
	// set W_AM1
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		write_seq = pci_memory_write_seq::type_id::create("req");
		write(W_ERR_CS, 32'h0);
		write(W_IMG_CTRL1, 32'h0);
		write(W_BA1, W_BASE_ADDR_1);
		write(W_AM1, 32'hFFFF_FFFF);
    	`uvm_info(get_type_name(), "wb image config sequence completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : reset W_ERR_CS W_IMG_CTRL1, write 0xc000_0000 to W_BA1,
	// set W_AM1
	//////////////////////////////////////////////////////////////////////////////
	task write();
		input bit [31:0] address, data;
		write_seq.set_address(address);
		write_seq.set_data(data);
		write_seq.start(m_sequencer);
	endtask

endclass

`endif


