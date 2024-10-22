interface pci_bus_driver_bfm (pci_bridge_pci_interface pci_if);
	import pci_pkg::*;

	// Data Members
	pci_driver proxy;

	// Methods
	task run();
		pci_config_item item;
		forever @(posedge pci_if.clk) begin
			proxy.get_and_drive(item);
			drive_transaction(item);
		end
	endtask

	task drive_transaction(pci_config_item item);
		drive_common(item);
		if (item.is_write)
			drive_write(item);
		else
			drive_read(item);
	endtask

	task drive_common(pci_config_item item);
		// Common logic for both read and write
		pci_if.dr_cb.FRAME <= 1'b0;
		pci_if.dr_cb.AD <= item.address;
		pci_if.dr_cb.CBE <= item.command;
		@(pci_if.dr_cb);
		pci_if.dr_cb.IRDY <= 1'b0;
	endtask

	task drive_read(pci_config_item item);
		pci_if.dr_cb.AD <= 32'bz; // Release AD bus
		wait(!pci_if.dr_cb.TRDY);
		item.data = pci_if.dr_cb.AD; // Capture data
		@(pci_if.dr_cb);
		pci_if.dr_cb.IRDY <= 1'b1;
	endtask

	task drive_write(pci_config_item item);
		pci_if.dr_cb.AD <= item.data;
		pci_if.dr_cb.CBE <= 4'b1111; // All byte enables active
		wait(!pci_if.dr_cb.TRDY);
		@(pci_if.dr_cb);
		pci_if.dr_cb.IRDY <= 1'b1;
	endtask

	// Additional tasks for other types of transactions can be added here

endinterface