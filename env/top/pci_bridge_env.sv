`ifndef PCI_BRIDGE_ENV
`define PCI_BRIDGE_ENV

class pci_bridge_environment extends uvm_env;
	
	//////////////////////////////////////////////////////////////////////////////
	//Declaration components
	//////////////////////////////////////////////////////////////////////////////
	pci_bridge_pci_agent pci_agent;
	pci_bridge_wb_agent wb_agent;
	pci_bridge_ref_model ref_model;
	pci_bridge_coverage#(pci_bridge_pci_transaction) coverage;
	pci_bridge_scoreboard sb;
	 
	//////////////////////////////////////////////////////////////////////////////
	//Declaration of component utils to register with factory
	//////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_environment)
		 
	//////////////////////////////////////////////////////////////////////////////
	// Method name : new 
	// Description : constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	//////////////////////////////////////////////////////////////////////////////
	// Method name : build_phase 
	// Description : constructor
	//////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pci_agent = pci_bridge_pci_agent::type_id::create("pci_bridge_pci_agent", this);
		wb_agent = pci_bridge_wb_agent::type_id::create("pci_bridge_wb_agent", this);
		ref_model = pci_bridge_ref_model::type_id::create("ref_model", this);
		coverage = pci_bridge_coverage#(pci_bridge_pci_transaction)::type_id::create("coverage", this);
		sb = pci_bridge_scoreboard::type_id::create("sb", this);
	endfunction : build_phase
	//////////////////////////////////////////////////////////////////////////////
	// Method name : build_phase 
	// Description : constructor
	//////////////////////////////////////////////////////////////////////////////
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// monitor to scoreboard
		pci_agent.monitor.mon2sb_port.connect(sb.pci_mon2sb_export);
		wb_agent.monitor.mon2sb_port.connect(sb.wb_mon2sb_export);

		// connect ref
		ref_model.pci_rm2sb_port.connect(coverage.analysis_export);
		pci_agent.driver.drv2rm_port.connect(ref_model.pci_rm_export);
		ref_model.pci_rm2sb_port.connect(sb.pci_rm2sb_export);

		// ref_model.wb_rm2sb_port.connect(coverage.wb_analysis_export);
		// wb_agent.driver.drv2rm_port.connect(ref_model.wb_rm_export);
		ref_model.wb_rm2sb_port.connect(sb.wb_rm2sb_export);
	endfunction : connect_phase
endclass : pci_bridge_environment

`endif




