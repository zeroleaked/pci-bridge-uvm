`ifndef PCI_CONFIG_DRIVER
`define PCI_CONFIG_DRIVER

class pci_config_driver extends uvm_driver #(pci_config_transaction);
 
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction item 
	//////////////////////////////////////////////////////////////////////////////
	pci_config_transaction trans;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Virtual interface 
	//////////////////////////////////////////////////////////////////////////////
	virtual pci_bridge_pci_interface vif;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of component utils to register with factory 
	//////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_config_driver)
	uvm_analysis_port#(pci_config_transaction) drv2rm_port;
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
		pci_config_transaction req;
		reset();
		forever begin
			seq_item_port.get_next_item(req);
			// `uvm_info(get_type_name(), "driver rx", UVM_LOW)
			// req.print();
			drive_transaction(req);
			// driver to reference model
			$cast(rsp,req.clone());
			rsp.set_id_info(req);
			drv2rm_port.write(rsp);
			seq_item_port.item_done();
			seq_item_port.put(rsp);
		end
	endtask : run_phase

	task drive_transaction(pci_config_transaction tx);
		drive_address_phase(tx);
		if (tx.is_write()) begin
			drive_data_phase_write(tx);
		end
		else begin
			drive_data_phase_read(tx);
		end
		cleanup_transaction();
	endtask

	task drive_address_phase(pci_config_transaction tx);
		vif.dr_cb.FRAME <= 1'b0;  // Assert FRAME#
		vif.dr_cb.IDSEL <= 1'b1;  // Assert IDSEL
		vif.dr_cb.AD <= tx.address;  // Send register address
		vif.dr_cb.CBE <= tx.command; // Config Read or Write command
		@(vif.dr_cb);
		vif.dr_cb.FRAME <= 1'b1;  // Assert FRAME#
	endtask

	task drive_data_phase_read(pci_config_transaction tx);
		vif.dr_cb.IRDY <= 1'b0;   // Assert IRDY#
		vif.dr_cb.AD <= 32'bz;    // Release AD bus
		vif.dr_cb.CBE <= 4'b0000; // All byte enables active

		wait(!vif.dr_cb.DEVSEL && !vif.dr_cb.TRDY);  // Wait for target
		@(vif.dr_cb);
		vif.dr_cb.IRDY <= 1'b1;   // Deassert IRDY#
	endtask

	task drive_data_phase_write(pci_config_transaction tx);
		vif.dr_cb.IRDY <= 1'b0;   // Assert IRDY#
		vif.dr_cb.AD <= tx.data;  // Drive data
		vif.dr_cb.CBE <= 4'b0000; // All byte enables active

		wait(!vif.dr_cb.DEVSEL && !vif.dr_cb.TRDY);  // Wait for target

		@(vif.dr_cb);
		vif.dr_cb.IRDY <= 1'b1;   // Deassert IRDY#
	endtask

	task cleanup_transaction();
		// Reset signals to default states

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
	

endclass : pci_config_driver

`endif





