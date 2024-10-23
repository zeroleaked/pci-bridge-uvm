`ifndef PCI_TRANSACTION 
`define PCI_TRANSACTION

class pci_transaction extends uvm_sequence_item;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction fields
	//////////////////////////////////////////////////////////////////////////////
	rand bit [31:0] address;
	rand bit [31:0] data;
	rand bit [3:0] byte_en;
	rand pci_cmd_t command;
	//////////////////////////////////////////////////////////////////////////////
	//Declaration of Utility and Field macros,
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils_begin(pci_transaction)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(byte_en, UVM_ALL_ON)
    	`uvm_field_enum(pci_cmd_t, command, UVM_ALL_ON)
	`uvm_object_utils_end
	//////////////////////////////////////////////////////////////////////////////
	//Constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_transaction");
		super.new(name);
	endfunction
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Constraints
	//////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	// Method name : is_write 
	// Description : check if transaction is write operation
	///////////////////////////////////////////////////////////////////////////////
	function bit is_write();
		return command[0];
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : is_config
	// Description : check if transaction is to configuration space
	///////////////////////////////////////////////////////////////////////////////
	function bit is_config();
		return command[3:1] == 3'b101;
	endfunction
endclass

`endif