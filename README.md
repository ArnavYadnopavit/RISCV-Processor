# 🖥️ 64-bit RISC-V Processor on FPGA (RV64I / RV64IM)

**Course:** CS2323 – Computer Architecture  
**Institute:** IIT Hyderabad  

**Authors:**  
- **Krishna H. Patil** (EE24BTECH11036)  
- **Arnav Yadnopavit** (EE24BTECH11007)

---

## 📌 Project Overview

This repository contains the complete RTL design, verification infrastructure, and FPGA implementation of a **64-bit RISC-V processor** based on the **RV64I** and **RV64IM** instruction set architectures.  
The processor was implemented in **Verilog**, synthesized using **Vivado**, and tested on the **Digilent Arty A7 (Artix-7 FPGA)**.

The project was developed incrementally, starting from a single-cycle baseline and progressing toward a fully pipelined RV64IM processor with hazard handling, forwarding, and multicycle execution support.

---

##  Implemented Features

###  Supported Architectures
- Single-cycle RV64I processor
- 5-stage pipelined RV64I processor
- 5-stage pipelined RV64IM processor

### Instruction Set Support
- Full RV64I base integer ISA
- RV64IM M-extension:
  - `MUL`, `MULH`, `MULHSU`, `MULHU`
  - `DIV`, `DIVU`, `REM`, `REMU`

### Microarchitectural Features
- 5-stage pipeline: IF, ID, EX, MEM, WB
- Early branch resolution in Decode stage
- Data forwarding from EX/MEM and MEM/WB
- Load-use hazard detection
- Multicycle division with pipeline stalling
- BRAM-based instruction and data memory
- FPGA-tested execution on Arty A7

---

##  Planned but Not Implemented

- Floating Point Unit (RV64F / RV64D)
- Cache hierarchy (I-cache / D-cache)
- Fully functional UART TX/RX
- External DDR3 memory interface

---

##  Processor Variants

### 1️⃣ Single-Cycle RV64I
- All instruction stages execute in one cycle
- Simple combinational datapath
- No hazards or pipeline control
- Used as a correctness reference

---

### 2️⃣ 5-Stage Pipelined RV64I
- Classic RISC pipeline (IF → ID → EX → MEM → WB)
- Hazard detection and forwarding logic
- Branch resolution in Decode stage
- Higher throughput and clock frequency

---

### 3️⃣ 5-Stage Pipelined RV64IM
- Hardware multiplication using DSP slices
- Multicycle division using Xilinx `div_gen` IP
- Dedicated `DivStaller` FSM
- Integrated memory stall handling
- Divider-aware forwarding and write-back

---

## Testing and Verification

### Simulation
- Instruction-level waveform inspection
- Regression testing after each architectural extension
- Dedicated all-instruction testbench

### Test Programs
- Bubble Sort
- GCD (Euclidean algorithm)
- Arithmetic and memory stress tests
- Software and hardware division routines

### FPGA Validation
- Tested on Arty A7 board
- LED-based register debug output
- Stable operation verified at multiple frequencies

---

## Performance Summary

| Design | Stable Frequency |
|------|------------------|
| Single-cycle RV64I | 25 MHz |
| Pipelined RV64I | 50 MHz |
| Pipelined RV64IM | 30–35 MHz |

> **Recommended:** Run RV64IM at **30 MHz** for guaranteed timing closure.

---

## FPGA Resource Utilization (Artix-7)

| Design | LUT | FF | BRAM | DSP |
|------|-----|----|------|-----|
| Single-cycle RV64I | ~3k | ~2k | 1–2 | 4 |
| Pipelined RV64I | ~3.4k | ~2.6k | 32 | 6 |
| Pipelined RV64IM | ~14k | ~13k | 32 | 54 |

---

## How to Run
- Step 1: Generate Machine Code

Use an online RISC-V assembler:

https://riscvasm.lucasteske.dev/

- Step 2: Prepare Instruction Memory

Paste generated hex instructions into:

instructions/instructions.py


Run:

python instructions.py


Copy output into:

inst.coe

- Step 3: Vivado Setup

Open Vivado

Create a new project

Add RTL sources from one of:

Single_Cycle/

Pipelined_CPU/

Pipelined_CPU_64IM/

Re-customize imem_ip and load updated inst.coe

Generate IP output products (Global mode)

Set testbench top (dump_reg_tb.v)

Run simulation or synthesize for FPGA

---

## Known Limitations

- No floating-point support

- No cache subsystem

- UART incomplete

- Divider introduces long pipeline stalls

---

## Future Work

- IEEE-754 compliant FPU (RV64IMF)

- L1 instruction and data caches

- Restore and optimize UART

- Higher clock frequencies (>50 MHz)

- Superscalar or multicore extensions

---

## References

- Patterson & Hennessy — Computer Organization and Design (RISC-V Edition)

- Harris & Harris — Digital Design and Computer Architecture

- RISC-V Instruction Set Manual

- Xilinx / Digilent Arty A7 Documentation
