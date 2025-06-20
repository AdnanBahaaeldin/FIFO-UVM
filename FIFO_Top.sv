import uvm_pkg::*;
import FIFO_Test_pkg::*;
`include "uvm_macros.svh"

module top();

bit clk;
  // Clock generation
initial begin
    clk = 0;
    forever begin
    #1 clk = ~clk;
  end
end


//Instantiate the interface and the DUT 
FIFO_IF fifo_if(clk);
FIFO dut(fifo_if);

bind FIFO FIFO_Assertions fifo_inst (fifo_if); 

initial begin  
  uvm_config_db#(virtual FIFO_IF)::set(null, "uvm_test_top", "FIFO_IF", fifo_if); //Set the virtual interface in the configuration database
  run_test("FIFO_Test");
end

endmodule