package FIFO_Driver_pkg;
import uvm_pkg::*;
import FIFO_Sequence_Item_pkg::*;
`include "uvm_macros.svh"





class FIFO_Driver extends uvm_driver #(FIFO_Sequence_Item);
`uvm_component_utils(FIFO_Driver)

virtual FIFO_IF fifo_driver_vif; // Declare a virtual interface to be used in the driver
FIFO_Sequence_Item fifo_sequence_item; // Declare a sequence item to be used in the driver

function new(string name = "FIFO_Driver", uvm_component parent = null);
    super.new(name,parent);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
   forever begin 
        fifo_sequence_item = FIFO_Sequence_Item::type_id::create("fifo_sequence_item", this); // Create a sequence item
        seq_item_port.get_next_item(fifo_sequence_item); // Get the next item from the sequencer

        fifo_driver_vif.data_in = fifo_sequence_item.data_in;
        fifo_driver_vif.rst_n = fifo_sequence_item.rst_n;
        fifo_driver_vif.wr_en = fifo_sequence_item.wr_en;
        fifo_driver_vif.rd_en = fifo_sequence_item.rd_en;

        @(negedge fifo_driver_vif.clk);
        seq_item_port.item_done(); // Indicate that the item is done
        `uvm_info("run_phase",fifo_sequence_item.convert2string(),UVM_HIGH); // Display the sequence item values
    end

endtask

endclass
endpackage