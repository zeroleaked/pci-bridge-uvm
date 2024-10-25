`ifndef PCI_INIT_SEQ
`define PCI_INIT_SEQ
class pci_init_seq extends uvm_sequence#(pci_transaction);
	///////////////////////////////////////////////////////////////////////////////
	// Declaration of Sequence utils
	//////////////////////////////////////////////////////////////////////////////
	`uvm_object_utils(pci_init_seq)
	///////////////////////////////////////////////////////////////////////////////
	// Method name : new
	// Description : sequence constructor
	//////////////////////////////////////////////////////////////////////////////
	function new(string name = "pci_init_seq");
		super.new(name);
	endfunction
	///////////////////////////////////////////////////////////////////////////////
	// Method name : body 
	// Description : Scan PCI header, setup bus access, scan registers,
	// reset image registers
	//////////////////////////////////////////////////////////////////////////////
	virtual task body();
		pci_header_scan_seq	header_scan_seq;
		pci_bus_setup_seq bus_setup_seq;
		pci_register_scan_seq register_scan_seq;
		pci_register_reset_seq register_reset_seq;

		header_scan_seq = pci_header_scan_seq::type_id::create("header_scan_seq");
		header_scan_seq.start(m_sequencer);

		bus_setup_seq = pci_bus_setup_seq::type_id::create("bus_setup_seq");
		bus_setup_seq.start(m_sequencer);

		register_scan_seq = pci_register_scan_seq::type_id::create("reg_scan_seq");
		register_scan_seq.start(m_sequencer);

		register_reset_seq = pci_register_reset_seq::type_id::create("reg_reset_seq");
		register_reset_seq.start(m_sequencer);

    	`uvm_info(get_type_name(), "initialization sequence completed", UVM_LOW)
	endtask

endclass

`endif


