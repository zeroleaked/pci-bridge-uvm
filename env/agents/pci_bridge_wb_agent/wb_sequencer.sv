`ifndef WB_SEQUENCER
`define WB_SEQUENCER

class wb_sequencer extends uvm_sequencer#(wb_transaction);
 
  `uvm_component_utils(wb_sequencer)
 
  ///////////////////////////////////////////////////////////////////////////////
  //constructor
  ///////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
endclass

`endif




