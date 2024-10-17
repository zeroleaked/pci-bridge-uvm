`ifndef PCI_BRIGE_PCI_TRANSACTION 
`define PCI_BRIGE_PCI_TRANSACTION

class pci_bridge_pci_transaction extends uvm_sequence_item;
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of transaction fields
	//////////////////////////////////////////////////////////////////////////////
	rand bit is_reset;
	rand bit [31:0] address;
	rand bit [31:0] data;
	rand bit is_write;
	rand bit [3:0] byte_enable;
	//////////////////////////////////////////////////////////////////////////////
	//Declaration of Utility and Field macros,
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils_begin(pci_bridge_pci_transaction)
		`uvm_field_int(is_reset, UVM_ALL_ON)
		`uvm_field_int(address, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(is_write, UVM_ALL_ON)
		`uvm_field_int(byte_enable, UVM_ALL_ON)
	`uvm_object_utils_end
	//////////////////////////////////////////////////////////////////////////////
	//Constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_bridge_pci_transaction");
		super.new(name);
	endfunction
	//////////////////////////////////////////////////////////////////////////////
	// Declaration of Constraints
	//////////////////////////////////////////////////////////////////////////////
	constraint valid_address {
		address[1:0] == 2'b00; // 32-bit aligned addresses
	}

	constraint write_byte_enable {
		if (is_write) byte_enable != 4'b0000;
	}
	//////////////////////////////////////////////////////////////////////////////
	// Method name : post_randomize();
	// Description : To display transaction info after randomization
	//////////////////////////////////////////////////////////////////////////////
	function void post_randomize();
	endfunction	
	 
endclass


`endif


