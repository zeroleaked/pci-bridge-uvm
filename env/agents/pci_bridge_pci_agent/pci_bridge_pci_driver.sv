`ifndef PCI_BRIDGE_PCI_DRIVER
`define PCI_BRIDGE_PCI_DRIVER

class pci_bridge_pci_driver extends uvm_driver #(pci_bridge_pci_transaction);
 
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction item 
	//////////////////////////////////////////////////////////////////////////////
	pci_bridge_pci_transaction trans;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Virtual interface 
	//////////////////////////////////////////////////////////////////////////////
	virtual pci_bridge_pci_interface vif;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of component utils to register with factory 
	//////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_pci_driver)
	uvm_analysis_port#(pci_bridge_pci_transaction) drv2rm_port;
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
		forever begin
			seq_item_port.get_next_item(req);
			if (req.is_reset) reset();
			else if (!req.is_write) read();
			// log
			`uvm_info(get_full_name(),$sformatf("TRANSACTION FROM DRIVER"),UVM_LOW);
			req.print();
			@(vif.dr_cb);
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
		// Signals driven by the initiator
		vif.dr_cb.RST    <= 1'b1;    // Active low, so set to inactive
		vif.dr_cb.GNT    <= 1'b1;    // Active low, so set to inactive
		vif.dr_cb.IDSEL  <= 1'b0;    // Typically low when inactive
		vif.dr_cb.CBE    <= 4'b1111; // All byte enables inactive

		// Bidirectional signals set to high-impedance when not driven
		vif.dr_cb.AD     <= 32'bz;
		vif.dr_cb.PAR    <= 1'bz;
		vif.dr_cb.PERR   <= 1'bz;    

		// Driven by target
		vif.dr_cb.DEVSEL <= 1'bz;
		vif.dr_cb.TRDY   <= 1'bz;
		vif.dr_cb.STOP   <= 1'bz;
		vif.dr_cb.INTA   <= 1'bz;

		vif.dr_cb.RST <= 1'b0;
		repeat(5) @(vif.dr_cb);
		vif.dr_cb.RST <= 1'b1;
		repeat(100) @(vif.dr_cb);
	endtask
	//////////////////////////////////////////////////////////////////////////////
	// Method name : read
	// Description : simple read to DUT
	//////////////////////////////////////////////////////////////////////////////
	task read();
		// address phase
		vif.dr_cb.AD <= req.address;
		vif.dr_cb.CBE <= 4'b1010; // config read
		vif.dr_cb.FRAME <= 1'b0;
		vif.dr_cb.IDSEL <= 1'b1;
		@(vif.dr_cb);

		// data phase
		vif.dr_cb.AD <= 32'bz;
		vif.dr_cb.CBE <= 4'b0000;
		vif.dr_cb.FRAME <= 1'b1;
		vif.dr_cb.IRDY <= 1'b0;

		// wait for target to assert DEVSEL# and TRDY#
		wait(!vif.dr_cb.DEVSEL && !vif.dr_cb.TRDY);
		@(vif.dr_cb);
	endtask

endclass : pci_bridge_pci_driver

`endif





