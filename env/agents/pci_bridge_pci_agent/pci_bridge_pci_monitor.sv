`ifndef PCI_BRIDGE_PCI_MONITOR 
`define PCI_BRIDGE_PCI_MONITOR

class pci_bridge_pci_monitor extends uvm_monitor;

	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Virtual interface
	///////////////////////////////////////////////////////////////////////////////
	virtual pci_bridge_pci_interface vif;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Analysis ports and exports 
	///////////////////////////////////////////////////////////////////////////////
	uvm_analysis_port #(pci_bridge_pci_transaction) mon2sb_port;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction item 
	///////////////////////////////////////////////////////////////////////////////
	pci_bridge_pci_transaction act_trans;
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of component	utils 
	///////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_pci_monitor)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new 
	// Description : constructor
	///////////////////////////////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
		act_trans = new();
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
		bit reset = 0;
		forever begin
			@(vif.rc_cb);
			if (!vif.rc_cb.RST & !reset) begin
				act_trans.is_reset = 1;
				mon2sb_port.write(act_trans);

				reset = 1;
			end
			else if (vif.rc_cb.RST & reset) reset = 0;
			else if (!vif.rc_cb.FRAME) begin
				act_trans.is_reset = 0;
				act_trans.address = vif.rc_cb.AD;
				wait(!vif.dr_cb.DEVSEL && !vif.dr_cb.TRDY);
				act_trans.data = vif.rc_cb.AD;
				mon2sb_port.write(act_trans);
			end
		end
	endtask : run_phase

endclass : pci_bridge_pci_monitor

`endif
