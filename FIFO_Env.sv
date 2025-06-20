package FIFO_Env_pkg;

import uvm_pkg::*;
import FIFO_Agent_pkg::*;
import FIFO_Coverage_pkg::*;
import FIFO_Scoreboard_pkg::*;

`include "uvm_macros.svh"

class FIFO_Env extends uvm_env;

`uvm_component_utils(FIFO_Env)

FIFO_Agent agent; // Declare the agent
FIFO_Coverage coverage; //Declare the coverage 
FIFO_Scoreboard scoreboard; //Declare the Scoreboard

function new(string name = "FIFO_Env", uvm_component parent = null);
    super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = FIFO_Agent::type_id::create("agent",this); // Create the agent
    coverage = FIFO_Coverage::type_id::create("coverage",this); // Create the coverage object
    scoreboard = FIFO_Scoreboard::type_id::create("scoreboard",this); // Create the scoreboard
endfunction

function void connect_phase(uvm_phase phase);
    agent.agt_ap.connect(scoreboard.sb_export); // Connect the agent's analysis port to the scoreboard
    agent.agt_ap.connect(coverage.cov_export); // Connect the agent's analysis port to the coverage object
endfunction

endclass

endpackage