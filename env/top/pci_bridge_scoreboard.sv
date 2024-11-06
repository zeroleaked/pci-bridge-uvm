`ifndef PCI_BRIDGE_SCOREBOARD 
`define PCI_BRIDGE_SCOREBOARD

class pci_bridge_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(pci_bridge_scoreboard)

	`uvm_analysis_imp_decl(_pci_exp)
	`uvm_analysis_imp_decl(_pci_act)
	`uvm_analysis_imp_decl(_wb_exp)
	`uvm_analysis_imp_decl(_wb_act)

	// Analysis imports
	uvm_analysis_imp_pci_exp #(pci_transaction, pci_bridge_scoreboard) pci_exp_imp;
	uvm_analysis_imp_pci_act #(pci_transaction, pci_bridge_scoreboard) pci_act_imp;
	uvm_analysis_imp_wb_exp #(wb_transaction, pci_bridge_scoreboard) wb_exp_imp;
	uvm_analysis_imp_wb_act #(wb_transaction, pci_bridge_scoreboard) wb_act_imp;

	// Transaction queues
	// incoming transaction
	pci_transaction pci_exp_queue[$], pci_act_queue[$];
	wb_transaction wb_exp_queue[$], wb_act_queue[$];
	// outcoming transaction
	uvm_sequence_item pair_queue[$];

	// Error flag
	bit error;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pci_exp_imp = new("pci_exp_imp", this);
		pci_act_imp = new("pci_act_imp", this);
		wb_exp_imp = new("wb_exp_imp", this);
		wb_act_imp = new("wb_act_imp", this);
	endfunction: build_phase

	// Analysis port write implementations
	function void write_pci_exp(pci_transaction trans);
		pci_exp_queue.push_back(trans);
	endfunction: write_pci_exp

	function void write_pci_act(pci_transaction trans);
		pci_act_queue.push_back(trans);
	endfunction: write_pci_act

	function void write_wb_exp(wb_transaction trans);
		wb_exp_queue.push_back(trans);
	endfunction: write_wb_exp

	function void write_wb_act(wb_transaction trans);
		wb_act_queue.push_back(trans);
	endfunction: write_wb_act

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			// `uvm_info(get_type_name(), $sformatf("exp_q:%d act_q:%d", pci_exp_queue.size(), pci_act_queue.size()), UVM_LOW)
			// Wait for either PCI or WB transactions to be available
			wait((pci_exp_queue.size() > 0 && pci_act_queue.size() > 0) ||
					(wb_exp_queue.size() > 0 && wb_act_queue.size() > 0));
			
			if (pci_exp_queue.size() > 0 && pci_act_queue.size() > 0) begin
				compare_pci_trans();
			end
			if (wb_exp_queue.size() > 0 && wb_act_queue.size() > 0) begin
				compare_wb_trans();
			end
		end
	endtask

	task compare_pci_trans();
		pci_transaction exp_trans, act_trans;
		
		exp_trans = pci_exp_queue.pop_front();
		act_trans = pci_act_queue.pop_front();

		// `uvm_info(get_type_name(), $sformatf("Comparing PCI transactions:\nExpected:\n%s\nActual:\n%s", exp_trans.sprint(), act_trans.sprint()), UVM_LOW)

		if (!exp_trans.compare(act_trans)) begin
			`uvm_error(get_type_name(), $sformatf("PCI transaction mismatch:\nExpected:\n%s\nActual:\n%s", exp_trans.sprint(), act_trans.sprint()))
			error = 1;
		end else begin
			`uvm_info(get_type_name(), $sformatf("PCI match %s\t0x%h: 0x%h", act_trans.command.name(), act_trans.address, act_trans.data), UVM_LOW)
		end
	endtask

	task compare_wb_trans();
		wb_transaction exp_trans, act_trans;
		
		exp_trans = wb_exp_queue.pop_front();
		act_trans = wb_act_queue.pop_front();

		// `uvm_info(get_type_name(), $sformatf("Comparing WB transactions:\nExpected:\n%s\nActual:\n%s", exp_trans.sprint(), act_trans.sprint()), UVM_LOW)

		if (!exp_trans.compare(act_trans)) begin
			`uvm_error(get_type_name(), $sformatf("WB transaction mismatch:\nExpected:\n%s\nActual:\n%s", exp_trans.sprint(), act_trans.sprint()))
			error = 1;
		end else begin
			`uvm_info(get_type_name(), $sformatf("WB  match %s\t0x%h: 0x%h", (act_trans.is_write ? "WRITE" : "READ "), act_trans.address, act_trans.data), UVM_LOW)
		end

		// if (exp_trans.has_match)
		// 	find_match(exp_trans);
	endtask	

	// task find_match(uvm_sequence_item trans);
	// 	foreach (wb_trans_queue[i]) begin
	// 		if (wb_trans_queue[i].trans_id == trans.trans_id) begin
	// 			// Found a match!
	// 			bridge_coverage::bridge_trans_pair pair;
	// 			pair.pci = trans;
	// 			pair.wb = wb_trans_queue[i];
	// 			pair.latency = $time - wb_trans_queue[i].start_time;
				
	// 			// Send to coverage
	// 			matched_ap.write(pair);
				
	// 			// Mark both transactions as matched
	// 			trans.has_match = 1;
	// 			wb_trans_queue[i].has_match = 1;
				
	// 			// Remove matched WB transaction
	// 			wb_trans_queue.delete(i);
	// 			return;
	// 		end
	// 	end
	// endtask

	function void report_phase(uvm_phase phase);
		$display($sformatf("PCI queue: %d/%d\nWB queue: %d/%d", pci_act_queue.size(), pci_exp_queue.size(), wb_act_queue.size(), wb_exp_queue.size()));
		if ((pci_act_queue.size() != 0) ||(pci_exp_queue.size() != 0)
		|| (wb_act_queue.size() != 0) || (wb_exp_queue.size() != 0)) begin
			`uvm_error(get_type_name(), $sformatf("Scoreboard queue not depleted"))
			error = 1;
		end
		if(error==0) begin
			$display("-------------------------------------------------");
			$display("------ INFO : TEST CASE PASSED ------------------");
			$display("-----------------------------------------");
		end else begin
			$display("---------------------------------------------------");
			$display("------ ERROR : TEST CASE FAILED ------------------");
			$display("---------------------------------------------------");
		end
	endfunction 
endclass : pci_bridge_scoreboard

`endif