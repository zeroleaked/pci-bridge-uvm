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
	// api for wb2pci
	wb_write_seq wb_write;
	wb_read_seq wb_read;
	pci_resp_mem_w_seq pci_write_response;
	pci_resp_mem_r_seq pci_read_response;
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


		wb_write = wb_write_seq::type_id::create("req");
		wb_read = wb_read_seq::type_id::create("req");
		pci_write_response = pci_resp_mem_w_seq::type_id::create("req");
		pci_read_response = pci_resp_mem_r_seq::type_id::create("req");

		wb_write.configure(wb_sequencer);
		wb_read.configure(wb_sequencer);
		pci_write_response.configure(pci_sequencer);
		pci_read_response.configure(pci_sequencer);

		// wb image configuration
		image_cfg_seq = pci_wb_image_config_seq::type_id::create("req");
		image_cfg_seq.start(pci_sequencer);

		// run some testcases
		wb_pci_read_write();
		wb_same_address_read();
		wb_multiple_write();
		wb_multiple_b2b_rw_vseq();

    	`uvm_info(get_type_name(), "wb image test sequence completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : wb_pci_read_write 
	// Description : single read and write test
	//////////////////////////////////////////////////////////////////////////////
	task wb_pci_read_write();
		bit [31:0] test_addr, test_data;

		test_addr = 32'h0;

		wb_write.write_transaction(test_addr);
		pci_write_response.write_response();
		test_data = pci_write_response.rsp.data;
    	`uvm_info(get_type_name(), "normal single memory write through wb image to pci sequence completed", UVM_LOW)

		// unlike write transactions, wb read transactions ask for retry until
		// pci targets respond. So, we have to do the sequence in parallel
		fork
			wb_read.read_transaction(test_addr);
			pci_read_response.read_response_with_data(test_data);
		join
		
    	`uvm_info(get_type_name(), "normal single memory read through wb image to pci sequence completed", UVM_LOW)
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : wb_same_address_read 
	// Description : multiple single reads to same address, change data
	//////////////////////////////////////////////////////////////////////////////
	task wb_same_address_read();
		bit [31:0] test_addr = 32'h48;
		
		repeat(5) fork
			wb_read.read_transaction(test_addr);
			pci_read_response.read_response();
		join

    	`uvm_info(get_type_name(), "multiple read, single address through wb image to pci sequence completed", UVM_LOW)		
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : wb_multiple_write
	// Description : multiple non-consecutive single write (then read)
	//////////////////////////////////////////////////////////////////////////////
	task wb_multiple_write();
		bit [31:0] test_data [0:127];

		for (int addr = 32'h200; addr >= 0; addr += -4) begin
			wb_write.write_transaction(addr);
			pci_write_response.write_response();
			test_data[addr >> 2] = pci_write_response.rsp.data;
		end

		// read back
		for (int addr = 32'h200; addr >= 0; addr += -4) begin
			fork
				wb_read.read_transaction(addr);
				pci_read_response.read_response_with_data(test_data[addr >> 2]);
			join
			assert (wb_read.rsp.data == test_data[addr >> 2])
			else `uvm_error(get_type_name(), "Unexpected data value");
		end

		`uvm_info(get_type_name(), "multiple non-consecutive single memory writes through wishbone slave unit sequence completed", UVM_LOW)	
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : wb_multiple_b2b_rw_vseq
	// Description : multiple fast back2back single writes/reads
	//////////////////////////////////////////////////////////////////////////////
	task wb_multiple_b2b_rw_vseq();
		for (int addr = 32'h200; addr > 0; addr += -4) begin
			// write
			wb_write.write_transaction(addr-4);
			pci_write_response.write_response();

			// then read a different address
			fork
				wb_read.read_transaction(addr);
				pci_read_response.read_response();
			join
		end
	endtask
endclass

`endif