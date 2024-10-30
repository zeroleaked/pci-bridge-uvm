`ifndef WB_MULTI_WRITE_VSEQ
`define WB_MULTI_WRITE_VSEQ
class wb_multi_write_vseq extends bridge_base_vseq;
	// Multiple normal write, different address from wishbone to pci
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(wb_multi_write_vseq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "wb_multi_write_vseq");
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
		
		bit [31:0] test_addr;
		bit [31:0] test_data [0:127];

		test_addr = 32'h0;

		// wb master
		wb_write = wb_write_seq::type_id::create("req");
		wb_write.configure(wb_sequencer);

		// pci target
		pci_write_response = pci_resp_mem_w_seq::type_id::create("req");
		pci_write_response.configure(pci_sequencer);

		for (int addr = 32'h200; addr >= 0; addr += -4) begin
			wb_write.write_transaction(addr);
			pci_write_response.write_response();
			test_data[addr >> 2] = pci_write_response.rsp.data;
		end

		// read back

		// wb master
		wb_read = wb_read_seq::type_id::create("req");
		wb_read.configure(wb_sequencer);

		// pci target
		pci_read_response = pci_resp_mem_r_seq::type_id::create("req");
		pci_read_response.configure(pci_sequencer);

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

endclass

`endif


