`ifndef PCI_TRANSACTION_COVERAGE
`define PCI_TRANSACTION_COVERAGE

class pci_transaction_coverage #(type T=pci_transaction) extends uvm_subscriber#(T);
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Local fields
	///////////////////////////////////////////////////////////////////////////////
	pci_transaction cov_trans;
	pci_cmd_t prev_command;
	`uvm_component_utils(pci_transaction_coverage)

	///////////////////////////////////////////////////////////////////////////////
	// functional coverage: covergroup for PCI transaction
	///////////////////////////////////////////////////////////////////////////////
	covergroup pci_transaction_cg;
		option.per_instance = 1;
		option.goal = 100;

		// Address space coverage
		pci_address: coverpoint cov_trans.address {
			// Configuration space (the mandatory PCI header for PCI compliance)
			bins config_space[] = {[0:32'h3F]} with (item % 4 == 0);
			// // I/O space to do
			bins io_space = {[32'h0000_0000:32'h0000_FFFF]};
			// Memory space
			bins bridge_regs[] = {[TAR_BASE_ADDR_0 : TAR_BASE_ADDR_0 + TAR_MEM_SIZE_0 - 1]};
			// Different devices (based on upper bits)
			bins device_0 = {[32'h1000_0000:32'h1FFF_FFFF]}; // bridge
			bins device_1 = {[W_BASE_ADDR_1:W_BASE_ADDR_1+W_SIZE_1]}; // image1
		}

		// Data pattern coverage
		pci_data: coverpoint cov_trans.data {
			bins all_zeros = {32'h0000_0000};
			bins all_ones = {32'hFFFF_FFFF};
			bins byte_aligned[] = {32'h000000FF, 32'h0000FF00, 32'h00FF0000, 32'hFF000000};
			bins other_values = default;
		}

		// Byte enable coverage
		pci_byte_en: coverpoint cov_trans.byte_en {
			bins single_byte[] = {'b0001, 'b0010, 'b0100, 'b1000};
			bins two_bytes[] = {'b0011, 'b0110, 'b1100};
			bins three_bytes[] = {'b0111, 'b1110, 'b1101, 'b1011};
			bins all_bytes = {'b1111};
			illegal_bins invalid = {'b0000};
		}

		// Command coverage
		pci_command: coverpoint cov_trans.command {
			bins memory_read = {MEM_READ};
			bins memory_write = {MEM_WRITE};
			bins config_read = {CFG_READ};
			bins config_write = {CFG_WRITE};
			bins io_read = {IO_READ};
			bins io_write = {IO_WRITE};
		}

		// Transaction type coverage
		pci_role: coverpoint cov_trans.role {
			bins dut_target = {PCI_INITIATOR};
			bins dut_initiator = {PCI_TARGET};
		}

		// // PCI type coverage
		// pci_role: coverpoint cov_trans.pci_type {
		// 	bins single_cycle = {PCI_SINGLE};
		// 	bins burst = {PCI_BURST};
		// 	bins write_invalidate = {PCI_WRITE_INV};
		// 	bins read_line = {PCI_READ_LINE};
		// 	bins read_multiple = {PCI_READ_MULTIPLE};
		// }

		// // Transaction timing coverage
		// pci_wait_states: coverpoint cov_trans.wait_states {
		// 	bins no_wait = {0};
		// 	bins short_wait[] = {[1:3]};
		// 	bins medium_wait[] = {[4:7]};
		// 	bins long_wait[] = {[8:15]};
		// 	bins very_long_wait = {[16:$]};
		// }

		// // Burst transaction coverage
		// burst_length: coverpoint cov_trans.burst_length {
		// 	bins single = {1};
		// 	bins short_burst[] = {[2:4]};
		// 	bins medium_burst[] = {[5:8]};
		// 	bins long_burst[] = {[9:16]};
		// 	bins very_long_burst = {[17:$]};
		// }

		// // Error condition coverage
		// error_type: coverpoint cov_trans.error_type {
		// 	bins master_abort = {PCI_MASTER_ABORT};
		// 	bins target_abort = {PCI_TARGET_ABORT};
		// 	bins retry = {PCI_RETRY};
		// 	bins disconnect = {PCI_DISCONNECT};
		// 	bins parity_error = {PCI_PARITY_ERROR};
		// 	bins normal = {PCI_NO_ERROR};
		// }

		// Important cross coverage
		cmd_addr_cross: cross pci_command, pci_address {
			// Config commands should only access config space
			illegal_bins illegal_config = binsof(pci_command) intersect {CFG_READ, CFG_WRITE} &&
										!binsof(pci_address.config_space);
			// I/O commands should only access I/O space
			illegal_bins illegal_io = binsof(pci_command) intersect {IO_READ, IO_WRITE} &&
									!binsof(pci_address.io_space);
		}

		cmd_byte_en_cross: cross pci_command, pci_byte_en {
			// Config cycles must be full DWORD
			illegal_bins partial_config = binsof(pci_command) intersect {CFG_READ, CFG_WRITE} &&
										!binsof(pci_byte_en.all_bytes);
		}

		// cmd_burst_cross: cross pci_command, burst_length {
		// 	// Configuration cycles can't be burst
		// 	illegal_bins config_burst = binsof(pci_command) intersect {CFG_READ, CFG_WRITE} &&
		// 							  !binsof(burst_length.single);
		// }

		// Transaction ordering coverage
		trans_order: coverpoint cov_trans.command {
			// Write-Read ordering
			bins posted_write_to_read = (MEM_WRITE => MEM_READ);
			bins posted_write_to_cfg_read = (MEM_WRITE => CFG_READ);
			bins posted_write_to_io_read = (MEM_WRITE => IO_READ);
			
			// Read-Write ordering
			bins read_to_posted_write = (MEM_READ => MEM_WRITE);
			bins read_to_cfg_write = (MEM_READ => CFG_WRITE);
			bins read_to_io_write = (MEM_READ => IO_WRITE);
			
			// Write-Write ordering
			bins write_to_write = (MEM_WRITE => MEM_WRITE);
			bins write_to_cfg_write = (MEM_WRITE => CFG_WRITE);
			bins write_to_io_write = (MEM_WRITE => IO_WRITE);
			
			// Read-Read ordering
			bins read_to_read = (MEM_READ => MEM_READ);
			bins read_to_cfg_read = (MEM_READ => CFG_READ);
			bins read_to_io_read = (MEM_READ => IO_READ);
			
			// Config-Config ordering
			bins cfg_write_to_cfg_read = (CFG_WRITE => CFG_READ);
			bins cfg_read_to_cfg_write = (CFG_READ => CFG_WRITE);
			
			// IO transaction ordering
			bins io_write_to_read = (IO_WRITE => MEM_READ);
		}
	endgroup

	//////////////////////////////////////////////////////////////////////////////
	//constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name="pci_transaction_coverage", uvm_component parent);
		super.new(name, parent);
		pci_transaction_cg = new();
		cov_trans = new();
	endfunction

	///////////////////////////////////////////////////////////////////////////////
	// Method name : write
	// Description : sampling PCI transaction coverage
	///////////////////////////////////////////////////////////////////////////////
	function void write(T t);
		this.cov_trans = t;
		pci_transaction_cg.sample();
	endfunction

endclass

`endif