`ifndef PCI_BUS_SETUP_SEQ
`define PCI_BUS_SETUP_SEQ
class pci_bus_setup_seq extends uvm_sequence#(pci_transaction);
	// Initialize the basic Config Registers of the PCI bridge
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_bus_setup_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_bus_setup_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Enable bus access and set device address
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		pci_config_write_seq write_seq;
		write_seq = pci_config_write_seq::type_id::create("req");
		write_seq.configure(m_sequencer);
		// turn on I/O Space (0) and Memory Space (1) accesses, turn on bus master (2)
		write_seq.write_transaction(COMMAND_STATUS, 32'h7);
		// set target base address to 1000_0000
		write_seq.write_transaction(BAR0, TAR_BASE_ADDR_0);
    	`uvm_info(get_type_name(), "bus setup sequence completed", UVM_LOW)
	endtask

endclass

`endif


