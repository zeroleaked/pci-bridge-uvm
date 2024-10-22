`ifndef PCI_CONFIG_TRANSACTION 
`define PCI_CONFIG_TRANSACTION

class pci_config_transaction extends uvm_sequence_item;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction fields
	//////////////////////////////////////////////////////////////////////////////
	rand bit [5:0] reg_addr;
	rand bit [3:0] command;
	rand bit [31:0] data;
	//////////////////////////////////////////////////////////////////////////////
	//Declaration of Utility and Field macros,
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils_begin(pci_config_transaction)
		`uvm_field_int(reg_addr, UVM_ALL_ON)
		`uvm_field_int(command, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
	`uvm_object_utils_end
	//////////////////////////////////////////////////////////////////////////////
	//Constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_config_transaction");
		super.new(name);
	endfunction
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Constraints
	//////////////////////////////////////////////////////////////////////////////
	constraint reg_addr_c { reg_addr[1:0] == 2'b00; }
	///////////////////////////////////////////////////////////////////////////////
	// Method name : is_write 
	// Description : check if is_write
	///////////////////////////////////////////////////////////////////////////////
	function bit is_write();
		return command[0];
	endfunction
endclass

`endif