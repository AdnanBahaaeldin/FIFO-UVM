////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////

import FIFO_Shared_pkg::*; // Importing shared parameters

module FIFO(FIFO_IF.DUT fifo_if);

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr =0, rd_ptr=0;
reg [max_fifo_addr:0] count=0; 

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.overflow <= 0;
		fifo_if.wr_ack <= 0; 
	end
	else if (fifo_if.wr_en && !fifo_if.rd_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifo_if.overflow <= 0;
	end
	else begin 
		if (fifo_if.full && fifo_if.wr_en) begin
			fifo_if.wr_ack <= 0; 
			fifo_if.overflow <= 1;
		end
		else begin
			fifo_if.overflow <= 0;
		end
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
	end
	else if (fifo_if.rd_en && !fifo_if.wr_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1; 
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full) 
			count <= count + 1;
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)
			count <= count - 1;
	end
end

//handle case where both wr_en and rd_en are high
always @(posedge fifo_if.clk) begin
	if(fifo_if.wr_en && fifo_if.rd_en) begin 

            //If FIFO is empty, only write is allowed
            if(count == 0) begin 
                mem[wr_ptr] = fifo_if.data_in;
                fifo_if.wr_ack = 1;
                wr_ptr = wr_ptr +1;
                count++;
            end

            //If FIFO is full, only read is allowed
            else if(count >= FIFO_DEPTH) begin 
                fifo_if.data_out = mem[rd_ptr];
                rd_ptr = rd_ptr +1;
                count--;
            end
			
			//Read and write 
			else begin
				mem[wr_ptr] = fifo_if.data_in;
  				fifo_if.wr_ack = 1;
				wr_ptr = wr_ptr +1;
				fifo_if.data_out = mem[rd_ptr];
                rd_ptr = rd_ptr + 1;
			end
	end
end


assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.underflow = (fifo_if.empty && fifo_if.rd_en)? 1 : 0; 

assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0;

assign fifo_if.almostempty = (count == 1)? 1 : 0;

endmodule