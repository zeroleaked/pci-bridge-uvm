`ifndef PCI_BRIDGE_PCI_DEFINES_SVH
`define PCI_BRIDGE_PCI_DEFINES_SVH

// Command type encoding
typedef enum bit [3:0] {
    CFG_READ  = 4'b1010,  // Configuration Read
    CFG_WRITE = 4'b1011,  // Configuration Write
    MEM_READ  = 4'b0110,  // Memory Read
    MEM_WRITE = 4'b0111,   // Memory Write
	IO_READ = 4'b0010,
	IO_WRITE = 4'b0011
} pci_cmd_t;

typedef enum {
	PCI_INITIATOR, // testbench acting as PCI initiator
	PCI_TARGET // testbench acting as PCI target
} pci_role_t;

`endif // PCI_BRIDGE_PCI_DEFINES_SVH