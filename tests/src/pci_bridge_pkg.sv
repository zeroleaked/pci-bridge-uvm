`ifndef PCI_BRIDGE_PKG
`define PCI_BRIDGE_PKG

package pci_bridge_pkg;

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
	
endpackage

`endif
