`ifndef PCI_BRIDGE_REF_MODEL_REGISTER_PKG
`define PCI_BRIDGE_REF_MODEL_REGISTER_PKG

package pci_bridge_ref_model_register_pkg;
	// Configuration Space Register Default Values
	parameter bit [31:0] CONFIG_SPACE_DEFAULTS [0:15] = '{
		32'h00011895, // Vendor & Device ID
		32'h02800000, // Command & Status
		32'h06800001, // Class Code & Revision ID
		32'h00000000, // BIST, Header Type, Latency Timer, Cache Line Size
		32'h00000000, // Base Address Register 0
		32'h00000001, // Base Address Register 1
		32'h00000000, // Base Address Register 2
		32'h00000000, // Base Address Register 3
		32'h00000000, // Base Address Register 4
		32'h00000000, // Base Address Register 5
		32'h00000000, // CardBus CIS Pointer
		32'h00011895, // Subsystem Vendor ID & Subsystem ID
		32'h00000000, // Expansion ROM Base Address
		32'h00000000, // Reserved
		32'h00000000, // Reserved
		32'h1a080100  // Max Latency, Min Grant, Interrupt Pin, Interrupt Line
	};

	// Registers (0x100-0x1F0)
	parameter bit [31:0] REGISTER_DEFAULTS [0:61] = '{
		32'h00000000, // 0x100: P_IMG_CTRL0
		32'h10000000, // 0x104: P_BA0 (extended)
		32'hfffff000, // 0x108: P_AM0
		32'h00000000, // 0x10C: P_TA0
		32'h00000000, // 0x110: P_IMG_CTRL1
		32'h00000001, // 0x114: P_BA1 (extended)
		32'hffffff00, // 0x118: P_AM1
		32'h00000000, // 0x11C: P_TA1
		32'h00000000, // 0x120: P_IMG_CTRL2
		32'h00000000, // 0x124: P_BA2 (extended)
		32'h00000000, // 0x128: P_AM2
		32'h00000000, // 0x12C: P_TA2
		32'h00000000, // 0x130: P_IMG_CTRL3
		32'h00000000, // 0x134: P_BA3 (extended)
		32'h00000000, // 0x138: P_AM3
		32'h00000000, // 0x13C: P_TA3
		32'h00000000, // 0x140: P_IMG_CTRL4
		32'h00000000, // 0x144: P_BA4 (extended)
		32'h00000000, // 0x148: P_AM4
		32'h00000000, // 0x14C: P_TA4
		32'h00000000, // 0x150: P_IMG_CTRL5
		32'h00000000, // 0x154: P_BA5 (extended)
		32'h00000000, // 0x158: P_AM5
		32'h00000000, // 0x15C: P_TA5
		32'h00000000, // 0x160: P_ERR_CS
		32'h00000000, // 0x164: P_ERR_ADDR
		32'h00000000, // 0x168: P_ERR_DATA
		32'h00000000, // 0x168: reserved
		32'h00000000, // 0x16C: reserved
		32'h00000000, // 0x170: reserved
		32'h00000000, // 0x174: reserved
		32'h00000000, // 0x178: reserved
		32'h00000000, // 0x17C: reserved
		32'h00000000, // 0x180: WB_CONF_SPC_BAR
		32'h00000000, // 0x184: W_IMG_CTRL1
		32'h00000000, // 0x188: W_BA1
		32'h80000000, // 0x18C: W_AM1
		32'h00000000, // 0x190: W_TA1
		32'h00000000, // 0x194: W_IMG_CTRL2
		32'h80000000, // 0x198: W_BA2
		32'h80000000, // 0x19C: W_AM2
		32'h00000000, // 0x1A0: W_TA2
		32'h00000000, // 0x1A4: W_IMG_CTRL3
		32'h00000000, // 0x1A8: W_BA3
		32'h00000000, // 0x1AC: W_AM3
		32'h00000000, // 0x1B0: W_TA3
		32'h00000000, // 0x1B4: W_IMG_CTRL4
		32'h00000000, // 0x1B8: W_BA4
		32'h00000000, // 0x1BC: W_AM4
		32'h00000000, // 0x1C0: W_TA4
		32'h00000000, // 0x1C4: W_IMG_CTRL5
		32'h00000000, // 0x1C8: W_BA5
		32'h00000000, // 0x1CC: W_AM5
		32'h00000000, // 0x1D0: W_TA5
		32'h00000000, // 0x1D4: W_ERR_CS
		32'h00000000, // 0x1D8: W_ERR_ADDR
		32'h00000000, // 0x1DC: W_ERR_DATA
		32'h00000000, // 0x1E0: CNF_ADDR
		32'h00000000, // 0x1E4: CNF_DATA
		32'h00000000, // 0x1E8: INT_ACK
		32'h00000000, // 0x1EC: ICR
		32'h00000000  // 0x1F0: ISR
	};

	// Helper class for configuration space access
	class ConfigSpaceHelper;
		// Read from configuration space
		static function bit[31:0] read_config(bit[11:0] addr);
			if (addr < 12'h100) begin
				// Standard Configuration Space
				return CONFIG_SPACE_DEFAULTS[addr[7:2]];
			end else begin
				// Extended Configuration Space
				return REGISTER_DEFAULTS[(addr - 12'h100) >> 2];
			end
		endfunction

		// Write to configuration space
		static function void write_config(ref bit[31:0] config_space[0:63], 
									   ref bit[31:0] ext_space[0:63],
									   bit[11:0] addr, 
									   bit[31:0] data);
			if (addr < 12'h100) begin
				// Standard Configuration Space
				config_space[addr[7:2]] = data;
			end else begin
				// Extended Configuration Space
				ext_space[(addr - 12'h100) >> 2] = data;
			end
		endfunction
	endclass

	// Register address definitions
	typedef enum bit [11:0] {
		// PCI Configuration Header Registers
		VENDOR_DEVICE_ID	= 12'h000,
		COMMAND_STATUS	  = 12'h004,
		CLASS_REVISION	  = 12'h008,
		HEADER_INFO		 = 12'h00C,
		BAR0			   = 12'h010,
		BAR1			   = 12'h014,
		BAR2			   = 12'h018,
		BAR3			   = 12'h01C,
		BAR4			   = 12'h020,
		BAR5			   = 12'h024,
		CARDBUS_CIS		= 12'h028,
		SUBSYS_ID		  = 12'h02C,
		ROM_BASE		   = 12'h030,
		RESERVED1		  = 12'h034,
		RESERVED2		  = 12'h038,
		INT_INFO		   = 12'h03C,

		// PCI Image Registers
		P_IMG_CTRL0		= 12'h100,
		P_BA0_EXT		  = 12'h104,
		P_AM0			  = 12'h108,
		P_TA0			  = 12'h10C,
		P_IMG_CTRL1		= 12'h110,
		P_BA1_EXT		  = 12'h114,
		P_AM1			  = 12'h118,
		P_TA1			  = 12'h11C,
		P_IMG_CTRL2		= 12'h120,
		P_BA2_EXT		  = 12'h124,
		P_AM2			  = 12'h128,
		P_TA2			  = 12'h12C,
		P_IMG_CTRL3		= 12'h130,
		P_BA3_EXT		  = 12'h134,
		P_AM3			  = 12'h138,
		P_TA3			  = 12'h13C,
		P_IMG_CTRL4		= 12'h140,
		P_BA4_EXT		  = 12'h144,
		P_AM4			  = 12'h148,
		P_TA4			  = 12'h14C,
		P_IMG_CTRL5		= 12'h150,
		P_BA5_EXT		  = 12'h154,
		P_AM5			  = 12'h158,
		P_TA5			  = 12'h15C,
		
		// Error Registers
		P_ERR_CS		   = 12'h160,
		P_ERR_ADDR		 = 12'h164,
		P_ERR_DATA		 = 12'h168,
		
		// Wishbone Configuration Registers
		WB_CONF_SPC_BAR	= 12'h180,
		W_IMG_CTRL1		= 12'h184,
		W_BA1			  = 12'h188,
		W_AM1			  = 12'h18C,
		W_TA1			  = 12'h190,
		W_IMG_CTRL2		= 12'h194,
		W_BA2			  = 12'h198,
		W_AM2			  = 12'h19C,
		W_TA2			  = 12'h1A0,
		W_IMG_CTRL3		= 12'h1A4,
		W_BA3			  = 12'h1A8,
		W_AM3			  = 12'h1AC,
		W_TA3			  = 12'h1B0,
		W_IMG_CTRL4		= 12'h1B4,
		W_BA4			  = 12'h1B8,
		W_AM4			  = 12'h1BC,
		W_TA4			  = 12'h1C0,
		W_IMG_CTRL5		= 12'h1C4,
		W_BA5			  = 12'h1C8,
		W_AM5			  = 12'h1CC,
		W_TA5			  = 12'h1D0,
		
		// Wishbone Error Registers
		W_ERR_CS		   = 12'h1D4,
		W_ERR_ADDR		 = 12'h1D8,
		W_ERR_DATA		 = 12'h1DC,
		
		// Configuration and Interrupt Registers
		CNF_ADDR		   = 12'h1E0,
		CNF_DATA		   = 12'h1E4,
		INT_ACK			= 12'h1E8,
		ICR				= 12'h1EC,
		ISR				= 12'h1F0
	} config_reg_addr_t;

	// Access type definitions
	typedef enum bit [1:0] {
		ACCESS_RO = 2'b01,  // Read Only
		ACCESS_RW = 2'b11   // Read/Write
	} reg_access_t;

	// Function to get register access type
	function automatic reg_access_t get_reg_access_type(config_reg_addr_t addr);
		case (addr)
			P_ERR_ADDR,
			P_ERR_DATA,
			WB_CONF_SPC_BAR,
			W_ERR_ADDR,
			W_ERR_DATA,
			INT_ACK:		return ACCESS_RO;
			default:		return ACCESS_RW;
		endcase
	endfunction

endpackage

`endif