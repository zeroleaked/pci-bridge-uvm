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
	uvm_analysis_export#(pci_bridge_pci_transaction) rm2sb_export,mon2sb_export;
	uvm_tlm_analysis_fifo#(pci_bridge_pci_transaction) rm2sb_export_fifo,mon2sb_export_fifo;
	pci_bridge_pci_transaction exp_trans,act_trans;
	pci_bridge_pci_transaction exp_trans_fifo[$],act_trans_fifo[$];
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
		rm2sb_export = new("rm2sb_export", this);
		mon2sb_export = new("mon2sb_export", this);
		rm2sb_export_fifo = new("rm2sb_export_fifo", this);
		mon2sb_export_fifo = new("mon2sb_export_fifo", this);
	endfunction: build_phase
		///////////////////////////////////////////////////////////////////////////////
	// Method name : build phase 
	// Description : Constructor 
	///////////////////////////////////////////////////////////////////////////////
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		rm2sb_export.connect(rm2sb_export_fifo.analysis_export);
		mon2sb_export.connect(mon2sb_export_fifo.analysis_export);
	endfunction: connect_phase
	///////////////////////////////////////////////////////////////////////////////
	// Method name : run 
	// Description : comparing expected and actual transactions
	///////////////////////////////////////////////////////////////////////////////
	virtual task run_phase(uvm_phase phase);
	 super.run_phase(phase);
		forever begin
		 mon2sb_export_fifo.get(act_trans);
		 if(act_trans==null) $stop;
		 act_trans_fifo.push_back(act_trans);
		 rm2sb_export_fifo.get(exp_trans);
		 if(exp_trans==null) $stop;
		 exp_trans_fifo.push_back(exp_trans);
		 compare_trans();
		end
	endtask
	///////////////////////////////////////////////////////////////////////////////
	// Method name : compare_trans 
	// Description : comparing expected and actual transactions
	///////////////////////////////////////////////////////////////////////////////
	task compare_trans();
		 pci_bridge_pci_transaction exp_trans,act_trans;
		 if(exp_trans_fifo.size!=0) begin
			 exp_trans = exp_trans_fifo.pop_front();
				if(act_trans_fifo.size!=0) begin
					act_trans = act_trans_fifo.pop_front();
					`uvm_info(get_full_name(),$sformatf("expected operation = %s , actual operation = %s ",exp_trans.operation.name(),act_trans.operation.name()),UVM_LOW);
					if(act_trans.operation == pci_bridge_pci_transaction::RESET) begin
						 `uvm_info(get_full_name(),$sformatf("Reset test passed on PCI"),UVM_LOW);
					end else begin
						 `uvm_error(get_full_name(),$sformatf("PCI reset conditions not met"));
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
