`ifndef PCI_DRIVER
`define PCI_DRIVER

class pci_driver extends uvm_driver #(pci_transaction);
 
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction item 
	//////////////////////////////////////////////////////////////////////////////
	pci_transaction trans;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Virtual interface 
	//////////////////////////////////////////////////////////////////////////////
	virtual pci_bridge_pci_interface vif;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of component utils to register with factory 
	//////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_driver)
	uvm_analysis_port#(pci_transaction) drv2rm_port;
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
		if(!uvm_config_db#(virtual pci_bridge_pci_interface)::get(this, "", "intf", vif))
			`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
		drv2rm_port = new("drv2rm_port", this);
	endfunction: build_phase
	//////////////////////////////////////////////////////////////////////////////
	// Method name : run_phase 
	// Description : Drive the transaction info to DUT
	//////////////////////////////////////////////////////////////////////////////
	virtual task run_phase(uvm_phase phase);
		pci_transaction req;
		reset();
		forever begin
			seq_item_port.get_next_item(req);
			// `uvm_info(get_type_name(), "driver rx", UVM_LOW)
			// req.print();
			
			if (req.is_config()) vif.dr_cb.IDSEL <= 1'b1;
			drive_address_phase(req);

			if (req.is_write()) vif.dr_cb.AD <= req.data;  // Drive data
			else vif.dr_cb.AD <= 32'bz;    // Release AD bus
			drive_data_phase(req);
			
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
	// Method name : reset 
	// Description : reset DUT
	//////////////////////////////////////////////////////////////////////////////
	task reset();
		cleanup_transaction();
		vif.dr_cb.RST <= 1'b0;
		repeat(5) @(vif.dr_cb);
		vif.dr_cb.RST <= 1'b1;
		repeat(100) @(vif.dr_cb);
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : cleanup_transaction 
	// Description : Reset signals to default states
	//////////////////////////////////////////////////////////////////////////////
	task cleanup_transaction();
		// Signals driven by the initiator
		vif.dr_cb.RST		<= 1'b1;    // Active low, so set to inactive
		vif.dr_cb.GNT		<= 1'b1;    // Active low, so set to inactive
		vif.dr_cb.IDSEL		<= 1'b0;    // Typically low when inactive
		vif.dr_cb.CBE		<= 4'b1111; // All byte enables inactive
		vif.dr_cb.IRDY		<= 1'bz;

		// Bidirectional signals set to high-impedance when not driven
		vif.dr_cb.AD		<= 32'bz;
		vif.dr_cb.PAR		<= 1'bz;
		vif.dr_cb.PERR   	<= 1'bz;    

		// Driven by target
		vif.dr_cb.DEVSEL	<= 1'bz;
		vif.dr_cb.TRDY		<= 1'bz;
		vif.dr_cb.STOP		<= 1'bz;
		vif.dr_cb.INTA		<= 1'bz;
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : drive_address_phase 
	// Description : Drive address phase
	//////////////////////////////////////////////////////////////////////////////
	task drive_address_phase(pci_transaction tx);
		vif.dr_cb.FRAME <= 1'b0;  // Assert FRAME#
		vif.dr_cb.AD <= tx.address;  // Send register address
		vif.dr_cb.CBE <= tx.command; // Config Read or Write command
		@(vif.dr_cb);
		vif.dr_cb.FRAME <= 1'b1;  // Assert FRAME#
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : drive_data_phase 
	// Description : Drive data phase
	//////////////////////////////////////////////////////////////////////////////
	task drive_data_phase(pci_transaction tx);
		int timeout_count = 0;
		vif.dr_cb.IRDY <= 1'b0;   // Assert IRDY#
		vif.dr_cb.CBE <= tx.byte_en; // All byte enables active

		// Wait for target ready with timeout
		while (vif.rc_cb.DEVSEL | vif.rc_cb.TRDY) begin
			@(vif.rc_cb);
			timeout_count++;
			if (timeout_count >= 16) begin
				`uvm_error(get_type_name(), "Target response timeout - no response within 16 clock cycles");
				break;
			end
		end
		@(vif.dr_cb);
		vif.dr_cb.IRDY <= 1'b1;   // Deassert IRDY#
	endtask
endclass

`endif