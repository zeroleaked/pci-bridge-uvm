`ifndef WB_DRIVER
`define WB_DRIVER

class wb_driver extends uvm_driver #(wb_transaction);
 
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction item 
	//////////////////////////////////////////////////////////////////////////////
	wb_transaction trans;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Virtual interface 
	//////////////////////////////////////////////////////////////////////////////
	virtual pci_bridge_wb_interface vif;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of component utils to register with factory 
	//////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(wb_driver)
	uvm_analysis_port#(wb_transaction) drv2rm_port;
	//////////////////////////////////////////////////////////////////////////////
	// Constructor 
	//////////////////////////////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	//////////////////////////////////////////////////////////////////////////////
	// Method name : build_phase 
	// Description : construct the components 
	//////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual pci_bridge_wb_interface)::get(this, "", "intf", vif))
			`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
		drv2rm_port = new("drv2rm_port", this);
	endfunction: build_phase
	//////////////////////////////////////////////////////////////////////////////
	// Method name : run_phase 
	// Description : Drive the transaction info to DUT
	//////////////////////////////////////////////////////////////////////////////
	virtual task run_phase(uvm_phase phase);
		wb_transaction req;
		forever begin
			seq_item_port.get_next_item(req);
			// `uvm_info(get_type_name(), "driver rx", UVM_LOW)
			// req.print();
			
			if (req.is_write) vif.dr_cb.SDAT_I <= req.data;  // Drive data
			drive_initial_phase(req);

			drive_response_phase(req);
			
			cleanup_transaction();
			
			// driver to reference model
			$cast(rsp,req.clone());
			rsp.set_id_info(req);
			drv2rm_port.write(rsp);
			seq_item_port.item_done();
			seq_item_port.put(rsp);
		end
	endtask : run_phase
	//////////////////////////////////////////////////////////////////////////////
	// Method name : cleanup_transaction 
	// Description : Reset signals to default states
	//////////////////////////////////////////////////////////////////////////////
	task cleanup_transaction();
		vif.dr_cb.ADR_I <= 32'h0;
		vif.dr_cb.SDAT_I <= 32'h0;
		vif.dr_cb.SEL_I <= 4'h0;
		vif.dr_cb.CYC_I <= 1'b0;
		vif.dr_cb.STB_I <= 1'b0;
		vif.dr_cb.WE_I <= 1'b0;
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : drive_address_phase 
	// Description : Drive address phase
	//////////////////////////////////////////////////////////////////////////////
	task drive_initial_phase(wb_transaction tx);
		vif.dr_cb.ADR_I <= tx.address;
		vif.dr_cb.SEL_I <= tx.select;
		vif.dr_cb.CYC_I <= 1'b1;
		vif.dr_cb.STB_I <= 1'b1;
		vif.dr_cb.WE_I <= tx.is_write;
		@(vif.dr_cb);
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : drive_data_phase 
	// Description : Drive data phase
	//////////////////////////////////////////////////////////////////////////////
	task drive_response_phase(wb_transaction tx);
		int timeout_count = 0;
		// Wait for target ready with timeout
		while (!vif.rc_cb.ACK_O) begin
			@(vif.rc_cb);
			timeout_count++;
			if (timeout_count >= 128) begin
				`uvm_error(get_type_name(), "Target response timeout - no response within 128 clock cycles");
				break;
			end
		end
		@(vif.dr_cb);
	endtask
endclass

`endif