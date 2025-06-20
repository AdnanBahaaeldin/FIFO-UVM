# FIFO Design Verification using SystemVerilog UVM

This repository provides a comprehensive **SystemVerilog UVM (Universal Verification Methodology)** testbench for verifying a **parameterized FIFO (First-In-First-Out)** design. It includes the RTL design, UVM environment, test sequences, scoreboard, functional coverage, and formal assertions.

---

## 🔧 How to Run

### Requirements
- **QuestaSim** or **ModelSim** simulator  
- **SystemVerilog** and **UVM** support

### Simulation Steps
1. Open a terminal in the project directory.
2. Run the following command to start the simulation:
   ```bash
   vsim -do run.do
3. This will compile all source files, execute the UVM testbench, and generate coverage data.

### 📊 Waveform and Coverage

- All interface signals are automatically added to the waveform window by the simulation script.  
- Coverage results are saved in `FIFO.ucdb`.

---

## 🚀 Project Features

- **RTL FIFO**: Parameterized, synthesizable FIFO design  
- **UVM Testbench**: Modular architecture with agent, driver, monitor, sequencer, scoreboard, and coverage components  
- **Sequences**: Includes write-only, read-only, mixed operation, and reset sequences  
- **Assertions**: SystemVerilog Assertions (SVA) for protocol and functional validation  
- **Coverage**: Functional coverage targeting key FIFO operations and illegal scenarios  
- **Scoreboard**: Reference model to validate DUT output and report mismatches  

---

## 👥 Authors

- **Adnan Bahaaeldin** – UVM Project  
- **Kareem Waseem** – RTL Design Author  



