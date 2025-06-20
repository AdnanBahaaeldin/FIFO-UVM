# FIFO-UVM
This repository provides a comprehensive SystemVerilog UVM (Universal Verification Methodology) testbench for verifying a parameterized FIFO (First-In-First-Out) design. It includes the RTL design, UVM environment, test sequences, scoreboard, coverage metrics, and formal assertions.

#How to Run
1. Requirements
  1.1 QuestaSim or ModelSim simulator
  1.2 SystemVerilog and UVM support

2. Simulation
  2.1 Open a terminal in the project directory.
  2.2 Run the following command to start the simulation:
      vsim -do run.do
  2.3 This will compile all sources, run the UVM testbench, and generate coverage data.

3. Waveform and Coverage
  3.1 The simulation script adds all interface signals to the waveform window.
  3.2 Coverage results are saved in FIFO.ucdb.

#Project Features
1. RTL FIFO: Parameterized, synthesizable FIFO design.
2. UVM Testbench: Modular environment with agent, driver, monitor, sequencer, scoreboard, and coverage.
3. Sequences: Includes read-only, write-only, mixed, and reset sequences.
4. Assertions: SystemVerilog Assertions (SVA) for protocol and functional checks.
5. Coverage: Functional coverage for key FIFO scenarios and illegal conditions.
6. Scoreboard: Reference model for data checking and error reporting.

#Authors
1. Adnan Bahaaeldin (Project)
2. Kareem Waseem (RTL Author)
