import FIFO_Shared_pkg::*; // Import the shared package

interface FIFO_IF(clk);

input bit clk;

//Define the FIFO signals
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
 

//Define modports for each of DUT, TB and Monitor respictively and drive the I/O signals
modport DUT(input data_in, clk, rst_n, wr_en, rd_en, output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
modport TEST(input data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, output data_in, clk, rst_n, wr_en, rd_en);
modport MONITOR(input data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, clk, rst_n, data_in, wr_en, rd_en);

endinterface