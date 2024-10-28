`ifndef PCI_BRIDGE_REGISTER_HANDLER 
`define PCI_BRIDGE_REGISTER_HANDLER
class pci_register_handler extends uvm_object;
	`uvm_object_utils(pci_register_handler)
	
	// Two separate arrays for standard and extended configuration space
	protected bit [31:0] std_config_space[0:63];
	protected bit [31:0] ext_config_space[0:63];

	function new(string name = "pci_register_handler");
		super.new(name);
		// Initialize configuration spaces with default values
		foreach (std_config_space[i]) begin
			std_config_space[i] = CONFIG_SPACE_DEFAULTS[i];
		end
		foreach (ext_config_space[i]) begin
			ext_config_space[i] = REGISTER_DEFAULTS[i];
		end
	endfunction

	function bit[31:0] read_config(bit[11:0] addr);
		if (addr < 12'h100) begin
			return std_config_space[addr[7:2]];
		end else begin
			return ext_config_space[(addr - 12'h100) >> 2];
		end
	endfunction

	function void write_config(bit[11:0] addr, bit[31:0] data);
		if (addr < 12'h100) begin
			if (addr == 12'h004) std_config_space[addr[7:2]] ^= data; 
			else std_config_space[addr[7:2]] = data;
		end else begin
			case (addr)
				// disable 12 LSB for W_AM
				W_AM1, W_AM2, W_AM3, W_AM4, W_AM5: begin
					ext_config_space[(addr - 12'h100) >> 2] = data & 32'hFFFF_F000;
				end
				default: begin
					ext_config_space[(addr - 12'h100) >> 2] = data;
				end
			endcase
		end
	endfunction
endclass

`endif
