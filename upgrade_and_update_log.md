# Pipelined Datapath Upgrade & Bug Fix Log

This document records all **architectural upgrades and RTL bug fixes** applied to processor.

---
Date - 29-12-2025

## Affected File

# 1) `pipelined_datapath.v`

---

## Objective of the Upgrade

- Make the datapath **FPGA-safe**
- Eliminate simulation-only clocking behavior
- Fix branch and hazard-related functional bugs
- Ensure correct stall and flush propagation
- Align implementation with a textbook 5-stage RISC-V pipeline

---

## 1. Clocking Model Correction

### Previous Behavior
Multiple submodules were driven using an **inverted clock (`~clk`)**. Created implicit half-cycle timing paths.

### Updated Behavior
All submodules now operate on a **single, non-inverted system clock**.

#### Changes Applied
```verilog
// Before
.clk(~clk)
.clka(~clk)

// After
.clk(clk)
.clka(clk)

```

 **Reason** -
Clock inversion in RTL is unsafe for FPGA synthesis and leads to race conditions, inaccurate timing analysis, and non-deterministic behavior. The design now uses a single synchronous clock domain.
---
## 2. Instruction Memory Stall Handling Fix

### Previous Behavior
Instruction memory always enabled. Instructions could advance while IF stage was stalled.

### Updated Behavior

#### Changes applied

```verilog
//before
.ena(1b'1)

//after
.ena(~StallF)
```

 **Reason** -
Prevents instruction fetch from advancing during IF-stage stalls, avoiding lose of an instruction due to dmem stall.
---
## 3. Branch Forwarding Source Correction
### Previous Behavior
Branch comparator used alu_result from the current EX stage.

### Updated Behavior
Branch comparator forwards data only from:

EX/MEM stage

WB stage

#### Corrected Connections
```verilog
.b(write_data)
.c(ex_mem_alu_result_out)
```

**Reason** -
Branch decisions occur in the ID stage. Forwarding EX-stage results into ID causes time-travel errors and incorrect branch resolution.
---
## 4. Pipeline Flush Semantics on Branch/Jump
### Previous Behavior
EX stage not reliably flushed on taken branch or jump.

### Updated Behavior

#### Corrected Connections
```verilog
assign PcSrc = Jump || (Branch && branch_D);
assign FlushD = PcSrc;

.FlushE((FlushE | PcSrc) & ~StallE)
```

**Reason** -
Ensures all wrong-path instructions in IF, ID, and EX are flushed when control flow changes, even under stall conditions.
---
# 5. Hazard Unit Decode Awareness
### Previous Behavior
Decode-stage opcode not provided to hazard unit.

### Updated Behavior

#### Corrected Connections
```verilog
.opcode_D(opcode)
```

**Reason** -
Opcode visibility in the decode stage is required for correct hazard classification, particularly for branch and load-use hazards.
---
## 6. MEM/WB Stall Propagation
### Previous Behavior
WB stage could advance during memory stalls.

### added port
```verilog
.StallW(StallM)
```

**Reason**
Prevents register write-back when memory operations are stalled, ensuring architectural state correctness.
---
 ## 7. Divider and Memory Stall Synchronization
### Previous Behavior
Divider and memory stall logic partially clocked using inverted clocks along with asynchrous i/o to the flipflops.

### Updated Behavior
Stall signals synchronized with the main pipeline clock.

**Reason** -
Guarantees deterministic stall behavior and prevents asynchronous pipeline freezes.
---
# 2) `DivStaller.v`

## Stall length aligned with divider IP timing
   - Signed division  : 70 cycles (clock-per-division = 4)
   - Unsigned division: 68 cycles (clock-per-division = 4)
---
# 3) `dmemstaller.v`

## CHANGE SUMMARY:
 1. Added synchronous reset support
 2. Removed asynchronous sensitivity to MemRead/MemWrite
 3. Converted stall generation to edge-detected, clocked logic
 4. Ensures single-cycle MemStall pulse per memory operation
 5. Eliminates race conditions and latch-like behavior

### OLD ISSUES FIXED:
 - Asynchronous sensitivity to `isMem` caused glitches
 - MemStall could assert unpredictably under timing variations
 - No reset path for MemStall

### NEW BEHAVIOR:
 - MemStall asserted for exactly one clock cycle
 - Triggered only when a new memory operation enters MEM stage
 - Fully synchronous and FPGA-safe
---
# 4) `ex_mem_reg.v`

## CHANGE SUMMARY:
 1. Removed Branch control signal from EX/MEM pipeline register
 2. Branch decision is no longer propagated beyond EX stage
 3. EX/MEM register now carries only MEM- and WB-relevant signals
 4. Stall handling remains unchanged and fully synchronous

### OLD ISSUES FIXED:
 - Branch control propagated into MEM stage even though it is unused
 - Redundant Branch signal increased pipeline complexity
 - Branch information already resolved earlier in the pipeline

### NEW BEHAVIOR:
 - Branch resolution is completed before MEM stage
 - EX/MEM register is simplified to essential signals only
 - Cleaner separation of control-flow and memory stages
---
# 5) `mem_wb_reg.v`

## CHANGE SUMMARY:
 1. Added explicit StallW input to support write-back stage stalling
 2. MEM/WB pipeline register now holds state during memory stalls
 3. Prevents incorrect register write-back when MEM stage is stalled
 4. Fully synchronous, single-clock pipeline behavior

### OLD ISSUES FIXED:
 - WB stage always advanced, even when MEM was stalled
 - Register file could receive invalid or premature data
 - No backpressure propagation from MEM to WB stage

### NEW BEHAVIOR:
 - MEM/WB register freezes when StallW is asserted
 - Write-back occurs only when data is architecturally valid
---
# 5) `HazardDetection.v`

## CHANGE SUMMARY:
 1. Added opcode_D input to explicitly detect branch instructions in Decode
 2. Separated branch hazard detection from generic load-use hazard logic
 3. Corrected branch forwarding sources to use MEM/WB stages only
 4. Removed unsafe EX-stage branch forwarding
 5. Added precise branch-dependent stall conditions
 6. Preserved divider and memory stall priority

### OLD ISSUES FIXED:
 - Branch hazards were detected implicitly without decode opcode awareness
 - EX-stage values were forwarded into ID stage for branch comparison
 - Over-stalling and incorrect branch resolution occurred
 - Branch stall logic mixed with generic forwarding logic

### NEW BEHAVIOR:
 - Branch hazards handled only when Decode instruction is actually a branch
 - Branch forwarding limited to architecturally valid stages
 - Cleaner separation of data, branch, memory, and divider hazards

 ## Some minor fixes here and there are also present, these are the major ones

 # Outcomes 

- The load/store bugs were fixed
- Some hazards and forwading issues were solved
- The processor now runs stably at 30MHz, with the extreme limit of 35-40 Mhz 

 
