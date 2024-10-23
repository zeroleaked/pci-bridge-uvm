`ifndef PCI_MONITOR 
`define PCI_MONITOR

class pci_monitor extends uvm_monitor;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Virtual interface
	///////////////////////////////////////////////////////////////////////////////
	virtual pci_bridge_pci_interface vif;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Analysis ports and exports 
	///////////////////////////////////////////////////////////////////////////////
	uvm_analysis_port #(pci_transaction) mon2sb_port;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction item 
	///////////////////////////////////////////////////////////////////////////////
	pci_transaction tx;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of component	utils 
	///////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_monitor)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new 
	// Description : constructor
	///////////////////////////////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
		tx = new();
		mon2sb_port = new("mon2sb_port", this);
	endfunction : new
	///////////////////////////////////////////////////////////////////////////////
	// Method name : build_phase 
	// Description : construct the components
	///////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual pci_bridge_pci_interface)::get(this, "", "intf", vif))
			 `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
	endfunction: build_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : run_phase 
	// Description : Extract the info from DUT via interface 
	///////////////////////////////////////////////////////////////////////////////
	virtual task run_phase(uvm_phase phase);
		forever begin
			wait(!vif.rc_cb.FRAME); // Wait for start of transaction
			collect_transaction();
		end
	endtask : run_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : collect_transaction 
	// Description : Main collection task
	///////////////////////////////////////////////////////////////////////////////
	task collect_transaction();
		bit [31:0] addr;

		collect_address_phase();
		if (tx == null) return;
		
		collect_data_phase();

		mon2sb_port.write(tx);
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : collect_address_phase 
	// Description : Collect address phase information
	///////////////////////////////////////////////////////////////////////////////
	task collect_address_phase();
		pci_config_transaction cfg_tx;
		bit [3:0] command = vif.rc_cb.CBE;
		if (command[3:1] == 3'b101) begin
			tx = pci_config_transaction::type_id::create("tx");
			$cast(cfg_tx, tx);
			cfg_tx.reg_addr = vif.rc_cb.AD[7:0];
		end
		else tx = pci_transaction::type_id::create("tx");
		$cast(tx.command, command);
		tx.address = vif.rc_cb.AD;
		@(vif.rc_cb); // Wait for next clock
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : collect_data_phase 
	// Description : Monitor data phase
	///////////////////////////////////////////////////////////////////////////////
	task collect_data_phase();
		// Wait for target ready
		wait(!vif.rc_cb.DEVSEL && !vif.rc_cb.TRDY);
		tx.data = vif.rc_cb.AD;
		tx.byte_en = vif.rc_cb.CBE;
		@(vif.rc_cb); // Wait for next clock
	endtask
endclass : pci_monitor

`endif