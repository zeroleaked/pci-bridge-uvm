`ifndef PCI_BRIDGE_SCOREBOARD 
`define PCI_BRIDGE_SCOREBOARD

class pci_bridge_scoreboard extends uvm_scoreboard;
 
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of component utils
	///////////////////////////////////////////////////////////////////////////////
	`uvm_component_utils(pci_bridge_scoreboard)
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Analysis ports and exports 
	///////////////////////////////////////////////////////////////////////////////
	uvm_analysis_export#(pci_bridge_pci_transaction) pci_rm2sb_export,pci_mon2sb_export;
	uvm_tlm_analysis_fifo#(pci_bridge_pci_transaction) pci_rm2sb_export_fifo,pci_mon2sb_export_fifo;
	pci_bridge_pci_transaction pci_exp_trans,pci_act_trans;
	pci_bridge_pci_transaction pci_exp_trans_fifo[$],pci_act_trans_fifo[$];

	uvm_analysis_export#(pci_bridge_wb_transaction) wb_rm2sb_export,wb_mon2sb_export;
	uvm_tlm_analysis_fifo#(pci_bridge_wb_transaction) wb_rm2sb_export_fifo,wb_mon2sb_export_fifo;
	pci_bridge_wb_transaction wb_exp_trans,wb_act_trans;
	pci_bridge_wb_transaction wb_exp_trans_fifo[$],wb_act_trans_fifo[$];

	bit error;
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : Constructor 
	///////////////////////////////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	///////////////////////////////////////////////////////////////////////////////
	// Method name : build phase 
	// Description : Constructor 
	///////////////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pci_rm2sb_export = new("pci_rm2sb_export", this);
		pci_mon2sb_export = new("pci_mon2sb_export", this);
		pci_rm2sb_export_fifo = new("pci_rm2sb_export_fifo", this);
		pci_mon2sb_export_fifo = new("pci_mon2sb_export_fifo", this);

		wb_rm2sb_export = new("wb_rm2sb_export", this);
		wb_mon2sb_export = new("wb_mon2sb_export", this);
		wb_rm2sb_export_fifo = new("wb_rm2sb_export_fifo", this);
		wb_mon2sb_export_fifo = new("wb_mon2sb_export_fifo", this);
	endfunction: build_phase
		///////////////////////////////////////////////////////////////////////////////
	// Method name : build phase 
	// Description : Constructor 
	///////////////////////////////////////////////////////////////////////////////
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		pci_rm2sb_export.connect(pci_rm2sb_export_fifo.analysis_export);
		pci_mon2sb_export.connect(pci_mon2sb_export_fifo.analysis_export);

		wb_rm2sb_export.connect(wb_rm2sb_export_fifo.analysis_export);
		wb_mon2sb_export.connect(wb_mon2sb_export_fifo.analysis_export);
	endfunction: connect_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : run 
	// Description : comparing expected and actual transactions
	///////////////////////////////////////////////////////////////////////////////
	virtual task run_phase(uvm_phase phase);
	 super.run_phase(phase);
		forever begin
			fork
				pci_mon2sb_export_fifo.get(pci_act_trans);
				wb_mon2sb_export_fifo.get(wb_act_trans);
			join_any
			disable fork;			

			if (pci_act_trans != null) begin
				pci_act_trans_fifo.push_back(pci_act_trans);
				pci_compare_trans();
			end

			if (wb_act_trans != null) begin
				wb_act_trans_fifo.push_back(wb_act_trans);
				
				wb_act_trans = wb_act_trans_fifo.pop_front();
				`uvm_info(get_full_name(),$sformatf("sb rx wb trans"),UVM_LOW);
				wb_act_trans.print();
				wb_act_trans = null;
			end
		 	// compare_trans();
		end
	endtask

	task pci_compare_trans();
		pci_bridge_pci_transaction pci_exp_trans,pci_act_trans;

		pci_act_trans = pci_act_trans_fifo.pop_front();
		`uvm_info(get_full_name(),$sformatf("sb rx pci act trans"),UVM_LOW);
		pci_act_trans.print();
		// pci_exp_trans = pci_exp_trans_fifo.pop_front();
		// `uvm_info(get_full_name(),$sformatf("sb rx pci exp trans"),UVM_LOW);
		// pci_exp_trans.print();
	endtask

	///////////////////////////////////////////////////////////////////////////////
	// Method name : compare_trans 
	// Description : comparing expected and actual transactions
	///////////////////////////////////////////////////////////////////////////////
	task compare_trans();
		 pci_bridge_wb_transaction wb_exp_trans,wb_act_trans;
		 if(wb_exp_trans_fifo.size!=0) begin
			 wb_exp_trans = wb_exp_trans_fifo.pop_front();
				if(wb_act_trans_fifo.size!=0) begin
					wb_act_trans = wb_act_trans_fifo.pop_front();
					`uvm_info(get_full_name(),$sformatf("expected is_reset = %s , actual is_reset = %s ",wb_exp_trans.is_reset,wb_act_trans.is_reset),UVM_LOW);
					if(wb_act_trans.is_reset == 1) begin
						 `uvm_info(get_full_name(),$sformatf("Reset propagated"),UVM_LOW);
					end else begin
						 `uvm_error(get_full_name(),$sformatf("Reset conditions not met"));
						 error=1;
					end
				end
			end
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : report 
	// Description : Report the testcase status PASS/FAIL
	///////////////////////////////////////////////////////////////////////////////
	function void report_phase(uvm_phase phase);
		if(error==0) begin
			$write("%c[7;32m",27);
			$display("-------------------------------------------------");
			$display("------ INFO : TEST CASE PASSED ------------------");
			$display("-----------------------------------------");
			$write("%c[0m",27);
		end else begin
			$write("%c[7;31m",27);
			$display("---------------------------------------------------");
			$display("------ ERROR : TEST CASE FAILED ------------------");
			$display("---------------------------------------------------");
			$write("%c[0m",27);
		end
	endfunction 
endclass : pci_bridge_scoreboard

`endif
