`ifndef WB_TRANSACTION_COVERAGE
`define WB_TRANSACTION_COVERAGE

class wb_transaction_coverage#(type T=wb_transaction) extends uvm_subscriber#(T);

///////////////////////////////////////////////////////////////////////////////
// Declaration of Local fields
///////////////////////////////////////////////////////////////////////////////
wb_transaction cov_trans;
`uvm_component_utils(wb_transaction_coverage)

///////////////////////////////////////////////////////////////////////////////
// functional coverage: covergroup for wishbone transaction
///////////////////////////////////////////////////////////////////////////////
covergroup wb_transaction_cg;
	option.per_instance = 1;
	option.goal = 100;

	// Address coverage - different regions that map to PCI spaces
	wb_address: coverpoint cov_trans.address {
		// PCI Configuration Space mapping to do
		bins cfg_space = {[32'hC000_0000:32'hC000_0FFF]};
		// PCI Memory Space mapping
		bins device_1 = {[W_BASE_ADDR_1:W_BASE_ADDR_1+W_SIZE_1]}; // image1
		// PCI I/O Space mapping to do
		bins io_space = {[32'hA000_0000:32'hA000_FFFF]};
		// Bridge internal registers to do
		bins bridge_regs = {[32'hB000_0000:32'hB000_00FF]};
		// Other addresses
		bins other = default;
	}

	// Data pattern coverage
	wb_data: coverpoint cov_trans.data {
		bins zeros = {32'h0000_0000};
		bins ones = {32'hFFFF_FFFF};
		bins byte_patterns[] = {32'h000000FF, 32'h0000FF00, 32'h00FF0000, 32'hFF000000};
		bins other_values = default;
	}

	// Byte select coverage
	wb_select: coverpoint cov_trans.select {
		bins single_byte[] = {'b0001, 'b0010, 'b0100, 'b1000};
		bins two_bytes[] = {'b0011, 'b0110, 'b1100};
		bins three_bytes[] = {'b0111, 'b1110, 'b1101, 'b1011};
		bins all_bytes = {'b1111};
		illegal_bins invalid = {'b0000};
	}

	// Operation type coverage
	wb_is_write: coverpoint cov_trans.is_write {
		bins read = {0};
		bins write = {1};
	}

	// // Cycle type coverage
	// wb_cycle_type: coverpoint cov_trans.cycle_type {
	// 	bins single = {WB_SINGLE};
	// 	bins block = {WB_BLOCK};
	// 	bins burst = {WB_BURST};
	// 	bins end_of_burst = {WB_EOB};
	// }

	// // Response coverage
	// wb_response: coverpoint cov_trans.response {
	// 	bins normal = {WB_NORMAL};
	// 	bins retry = {WB_RETRY};
	// 	bins error = {WB_ERROR};
	// 	bins timeout = {WB_TIMEOUT};
	// }

	// // Wait states coverage
	// wb_wait_states: coverpoint cov_trans.wait_states {
	// 	bins no_wait = {0};
	// 	bins few_wait[] = {[1:3]};
	// 	bins many_wait[] = {[4:$]};
	// }

	// Cross coverage for address and select
	addr_select_cross: cross wb_address, wb_select {
		// Configuration space must use full word access
		illegal_bins cfg_partial = binsof(wb_address.cfg_space) &&
								 !binsof(wb_select.all_bytes);
	}

	// // Cross coverage for operation type
	// op_type_cross: cross wb_is_write, wb_cycle_type {
	// 	// All cycle types should work with both reads and writes
	// 	bins read_single = binsof(wb_is_write.read) && binsof(wb_cycle_type.single);
	// 	bins write_single = binsof(wb_is_write.write) && binsof(wb_cycle_type.single);
	// 	bins read_block = binsof(wb_is_write.read) && binsof(wb_cycle_type.block);
	// 	bins write_block = binsof(wb_is_write.write) && binsof(wb_cycle_type.block);
	// }

	// // Cross coverage for address and response
	// addr_response_cross: cross wb_address, wb_response {
	// 	// Expected error responses for invalid addresses
	// 	bins invalid_addr_error = binsof(wb_address.other) && 
	// 							binsof(wb_response.error);
	// 	// Normal responses for valid addresses
	// 	bins valid_addr_normal = !binsof(wb_address.other) && 
	// 						   binsof(wb_response.normal);
	// }

endgroup

//////////////////////////////////////////////////////////////////////////////
//constructor
//////////////////////////////////////////////////////////////////////////////
function new(string name="wb_transaction_coverage", uvm_component parent);
	super.new(name, parent);
	wb_transaction_cg = new();
	cov_trans = new();
endfunction

///////////////////////////////////////////////////////////////////////////////
// Method name : write
// Description : sampling wishbone transaction coverage
///////////////////////////////////////////////////////////////////////////////
function void write(T t);
	this.cov_trans = t;
	wb_transaction_cg.sample();
endfunction

endclass

`endif