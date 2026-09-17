
# Decoder-Based RAM Verification using SystemVerilog

A SystemVerilog-based verification project for a decoder-based RAM, developed and simulated using **Siemens QuestaSim 2024.1**.

The project implements a modular, transaction-based verification environment using SystemVerilog classes, mailboxes, virtual interfaces, drivers, monitors, a reference model, and a scoreboard.

The verification environment contains both **directed and constrained-random tests** covering normal operation, boundary conditions, address/data patterns, overwrite behavior, block isolation, and randomized accesses.

---

## 📌 Project Overview

The Design Under Test (DUT) is a **decoder-based RAM** with:

- **128 memory locations**
- **7-bit address**
- **8-bit data**
- Address range: **0x00 – 0x7F**
- Decoder-based memory organization

The objective of this project is to verify the functional correctness of the RAM across different operating conditions and corner cases.

The verification environment checks:

- Read operation
- Write operation
- Address decoding
- Data storage
- Data retrieval
- Memory block boundaries
- Block isolation
- Same-address overwrites
- Address patterns
- Data patterns
- Randomized accesses
- Constrained-random accesses
- Read-before-write behavior

---

## 🏗️ Verification Architecture

```text
                         ┌──────────────────────────┐
                         │          TEST            │
                         │      ram_test.sv         │
                         │                          │
                         │ • Creates environment    │
                         │ • Configures tests       │
                         │ • Starts sequences       │
                         │ • Controls simulation    │
                         └────────────┬─────────────┘
                                      │
                                      ▼
                         ┌──────────────────────────┐
                         │       ENVIRONMENT        │
                         │       ram_env.sv         │
                         │                          │
                         │ Builds and connects      │
                         │ verification components  │
                         └────────────┬─────────────┘
                                      │
                                      ▼
                         ┌──────────────────────────┐
                         │        GENERATOR         │
                         │    ram_generator.sv      │
                         │                          │
                         │ • Write transactions     │
                         │ • Read transactions      │
                         │ • Directed sequences     │
                         │ • Random sequences       │
                         │ • Corner cases           │
                         └───────────┬──────────────┘
                                     │
                    ┌────────────────┴────────────────┐
                    │                                 │
                    ▼                                 ▼
          ┌────────────────────┐           ┌────────────────────┐
          │    WRITE DRIVER    │           │     READ DRIVER    │
          │ ram_write_driver.sv│           │ ram_read_driver.sv│
          └─────────┬──────────┘           └─────────┬──────────┘
                    │                                │
                    │                                │
                    ▼                                ▼
          ┌────────────────────┐           ┌────────────────────┐
          │   WRITE MONITOR    │           │    READ MONITOR    │
          │ram_write_monitor.sv│           │ram_read_monitor.sv │
          └─────────┬──────────┘           └─────────┬──────────┘
                    │                                │
                    │                                │
                    └──────────────┬─────────────────┘
                                   │
                                   ▼
                         ┌──────────────────────────┐
                         │       SCOREBOARD         │
                         │    ram_scoreboard.sv     │
                         │                          │
                         │ • Expected vs Actual     │
                         │ • Detects mismatches     │
                         │ • Reports verification    │
                         │   results                │
                         └────────────▲─────────────┘
                                      │
                                      │ Expected
                                      │ transactions
                                      │
                         ┌────────────┴─────────────┐
                         │     REFERENCE MODEL      │
                         │     ram_ref_model.sv     │
                         │                          │
                         │ Maintains expected RAM   │
                         │ behavior                 │
                         └──────────────────────────┘


                         ┌──────────────────────────┐
                         │        INTERFACE         │
                         │        ram_if.sv         │
                         │                          │
                         │ clk, rst, we              │
                         │ addr, wdata, rdata        │
                         │ valid                     │
                         │                          │
                         │ Clocking blocks           │
                         │ Modports                  │
                         └────────────▲─────────────┘
                                      │
                                      ▼
                         ┌──────────────────────────┐
                         │           DUT            │
                         │       decoder_ram.sv     │
                         │                          │
                         │    DECODER-BASED RAM     │
                         └──────────────────────────┘
````

---

## 🔄 Verification Flow

```text
                         TEST
                           │
                           ▼
                      ENVIRONMENT
                           │
                           ▼
                       GENERATOR
                           │
                    Transactions
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼
       WRITE DRIVER                 READ DRIVER
             │                           │
             ▼                           ▼
            DUT                         DUT
             │                           │
             └─────────────┬─────────────┘
                           │
                           ▼
                        MONITORS
                           │
                           ▼
                      SCOREBOARD
                           ▲
                           │
                    REFERENCE MODEL
```

The **generator** creates transactions and sends them to the appropriate driver using mailboxes.

The **drivers** receive transactions and apply them to the DUT through the virtual interface.

The **monitors** observe DUT activity and collect actual transactions.

The **reference model** maintains the expected RAM state.

The **scoreboard** compares expected transactions from the reference model against actual transactions observed by the monitors.

This provides an automated mechanism for detecting functional mismatches.

---

# 🧩 Project Components

| Component         | File                   | Description                                       |
| ----------------- | ---------------------- | ------------------------------------------------- |
| DUT               | `decoder_ram.sv`       | Decoder-based RAM design                          |
| Interface         | `ram_if.sv`            | Connects testbench components with DUT            |
| Transaction       | `ram_transaction.sv`   | Defines RAM transaction object                    |
| Generator         | `ram_generator.sv`     | Generates stimulus                                |
| Write Driver      | `ram_write_driver.sv`  | Drives write transactions                         |
| Read Driver       | `ram_read_driver.sv`   | Drives read transactions                          |
| Write Monitor     | `ram_write_monitor.sv` | Monitors write operations                         |
| Read Monitor      | `ram_read_monitor.sv`  | Monitors read operations                          |
| Reference Model   | `ram_ref_model.sv`     | Produces expected RAM behavior                    |
| Scoreboard        | `ram_scoreboard.sv`    | Compares expected and actual results              |
| Environment       | `ram_env.sv`           | Instantiates and connects verification components |
| Test              | `ram_test.sv`          | Controls individual test scenarios                |
| Testbench Top     | `ram_tb_top.sv`        | Top-level simulation module                       |
| Regression Script | `regression.do`        | Automates complete regression                     |

---

# 📁 Project Structure

```text
decoder_based_ram_systemverilog/
│
├── sv_files/
│   ├── decoder_ram.sv
│   ├── ram_if.sv
│   ├── ram_transaction.sv
│   ├── ram_generator.sv
│   ├── ram_write_driver.sv
│   ├── ram_read_driver.sv
│   ├── ram_write_monitor.sv
│   ├── ram_read_monitor.sv
│   ├── ram_ref_model.sv
│   ├── ram_scoreboard.sv
│   ├── ram_env.sv
│   ├── ram_test.sv
│   └── ram_tb_top.sv
│
├── logs/
│   ├── ram_allzero_test.txt
│   ├── ram_allone_test.txt
│   ├── ram_full_sweep_test.txt
│   ├── ram_checkerboard_test.txt
│   ├── ram_random_test.txt
│   ├── ram_constrained_weighted_test.txt
│   ├── ram_block_boundary_test.txt
│   ├── ram_block_isolation_test.txt
│   ├── ram_same_addr_overwrite_test.txt
│   ├── ram_toggle_addr_test.txt
│   ├── ram_read_before_write_test.txt
│   ├── ram_walking0_addr_test.txt
│   ├── ram_walking1_addr_test.txt
│   ├── ram_walking0_data_test.txt
│   └── ram_walking1_data_test.txt
│
├── block_diagram.png
├── transcript_report.png
├── regression.do
└── README.md
```

---

# 🧪 Test Suite

The regression contains **15 test scenarios** designed to verify different aspects of RAM functionality.

| #  | Test                            | Purpose                                    |
| -- | ------------------------------- | ------------------------------------------ |
| 1  | `ram_allzero_test`              | Tests all-zero data pattern                |
| 2  | `ram_allone_test`               | Tests all-one data pattern                 |
| 3  | `ram_full_sweep_test`           | Exercises the complete address space       |
| 4  | `ram_checkerboard_test`         | Tests alternating data patterns            |
| 5  | `ram_random_test`               | Tests randomized addresses and data        |
| 6  | `ram_constrained_weighted_test` | Tests constrained-random stimulus          |
| 7  | `ram_block_boundary_test`       | Tests memory block boundaries              |
| 8  | `ram_block_isolation_test`      | Tests isolation between memory blocks      |
| 9  | `ram_same_addr_overwrite_test`  | Tests repeated writes to the same address  |
| 10 | `ram_toggle_addr_test`          | Tests repeated address transitions         |
| 11 | `ram_read_before_write_test`    | Tests read behavior before explicit writes |
| 12 | `ram_walking0_addr_test`        | Tests walking-0 address patterns           |
| 13 | `ram_walking1_addr_test`        | Tests walking-1 address patterns           |
| 14 | `ram_walking0_data_test`        | Tests walking-0 data patterns              |
| 15 | `ram_walking1_data_test`        | Tests walking-1 data patterns              |

---

# 🔬 Test Categories

## 1. All-Zero Test

Writes:

```text
0x00
```

across the memory address space and verifies the stored values.

---

## 2. All-One Test

Writes:

```text
0xFF
```

across the memory address space and verifies the stored values.

---

## 3. Full Address Sweep

Exercises the complete RAM address range:

```text
0x00 → 0x7F
```

This ensures that every memory address is accessed.

---

## 4. Checkerboard Test

Uses alternating data patterns:

```text
0xAA
0x55
0xAA
0x55
...
```

This tests alternating bit patterns in the memory.

---

## 5. Random Test

Generates randomized address and data combinations.

This helps exercise combinations that may not be explicitly covered by directed tests.

---

## 6. Constrained-Weighted Random Test

Uses SystemVerilog constraints and weighted randomization to control the generated stimulus.

This allows specific address/data regions to be exercised with controlled probability.

---

## 7. Block Boundary Test

Tests addresses located around memory block boundaries.

Example:

```text
0x00
0x1F
0x20
0x3F
0x40
0x5F
0x60
0x7F
```

This helps verify correct decoder operation when transitioning between memory blocks.

---

## 8. Block Isolation Test

Verifies that writing to one memory block does not unintentionally modify data stored in another block.

---

## 9. Same Address Overwrite Test

Writes multiple values to the same address.

Example:

```text
Address = 0x00
Write   = 0xAA

Address = 0x00
Write   = 0x55

Read    = 0x00
```

This verifies overwrite behavior.

---

## 10. Toggle Address Test

Repeatedly accesses selected addresses to verify correct behavior during address transitions.

---

## 11. Read-Before-Write Test

Performs read operations before explicit writes to selected addresses.

This checks the behavior of the RAM when locations have not yet been explicitly initialized by the test.

---

## 12. Walking-0 Address Test

Exercises an address pattern where a zero bit moves through the address field.

Example:

```text
0x7E
0x7D
0x7B
0x77
0x6F
0x5F
0x3F
0x7F
```

---

## 13. Walking-1 Address Test

Exercises a walking-1 address pattern.

Example:

```text
0x01
0x02
0x04
0x08
0x10
0x20
0x40
0x00
```

---

## 14. Walking-0 Data Test

Exercises walking-0 data patterns.

Example:

```text
0xFE
0xFD
0xFB
0xF7
0xEF
0xDF
0xBF
0x7F
```

---

## 15. Walking-1 Data Test

Exercises walking-1 data patterns.

Example:

```text
0x01
0x02
0x04
0x08
0x10
0x20
0x40
0x80
```

---

# 📊 Regression Results

The completed regression contains:

```text
==============================================
             REGRESSION SUMMARY
==============================================

PASSED : 15
FAILED : 0
TOTAL  : 15
==============================================
```

### Final Regression Status

**15 / 15 tests passed**

```text
PASS RATE = 100%
```

The regression was executed using the automated `regression.do` script.

---

# 📈 Transaction Statistics

The regression logs contain transaction-level information generated by the verification environment.

Current collected regression statistics:

```text
Write Transactions : 912
Read Transactions  : 797
Total Transactions : 1709
```

These transactions were generated across the different directed and randomized test scenarios.

---

# 🛠️ SystemVerilog Verification Features Used

This project demonstrates several important SystemVerilog verification concepts:

* Classes
* Object-oriented programming
* Constructors
* Transaction-based verification
* Randomization
* Constraints
* Weighted randomization
* Mailboxes
* Virtual interfaces
* Clocking blocks
* Modports
* Drivers
* Monitors
* Reference model
* Scoreboard
* Directed testing
* Constrained-random testing
* Regression testing
* Functional coverage
* UCDB coverage database

---

# 📦 Transaction Architecture

The `ram_transaction` class represents a single RAM operation.

A transaction contains:

```text
Operation
Address
Write Data
Read Data
Valid
```

Conceptually:

```text
             RAM TRANSACTION
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
      OP         ADDRESS      DATA
   READ/WRITE     [6:0]       [7:0]
```

The generator creates transaction objects which are passed through mailboxes to the appropriate driver.

---

# 📬 Mailbox Communication

Mailboxes are used for communication between verification components.

```text
Generator
    │
    │ Write Mailbox
    ▼
Write Driver
```

and

```text
Generator
    │
    │ Read Mailbox
    ▼
Read Driver
```

The mailbox-based architecture decouples stimulus generation from transaction driving.

---

# 🔌 Virtual Interface

The verification components communicate with the DUT through a virtual interface.

The interface contains signals such as:

```text
clk
rst
we
addr
wdata
rdata
valid
```

Clocking blocks are used to organize signal sampling and driving with respect to the clock.

---

# 🧠 Reference Model

The reference model represents the expected behavior of the RAM.

When a write transaction occurs:

```text
Expected Memory[Address] = Write Data
```

For a read:

```text
Expected Read Data = Expected Memory[Address]
```

The expected transaction is then provided to the scoreboard.

---

# 🧮 Scoreboard

The scoreboard performs automated checking.

```text
              ┌─────────────────┐
Expected ────►│                 │
              │    SCOREBOARD   │───► PASS / MISMATCH
Actual ──────►│                 │
              └─────────────────┘
```

The scoreboard compares:

```text
Expected Data
      vs
Actual Data
```

This eliminates the need for manual waveform-based checking for every transaction.

---

# ▶️ Running the Project

## Run an Individual Test

From QuestaSim:

```tcl
vsim -c work.ram_tb_top "+TESTNAME=ram_random_test"
run -all
```

Replace the test name with any test from the test suite.

For example:

```tcl
vsim -c work.ram_tb_top "+TESTNAME=ram_allzero_test"
run -all
```

---

# 🔁 Run Complete Regression

The complete regression can be launched using:

```tcl
do regression.do
```

The regression script:

1. Compiles the required SystemVerilog files.
2. Runs the defined test cases.
3. Generates individual log files.
4. Reports the test results.
5. Produces a final regression summary.

---

# 📋 Simulation Logs

Individual test results are stored in the `logs/` directory.

Example:

```text
logs/
├── ram_allzero_test.txt
├── ram_allone_test.txt
├── ram_random_test.txt
├── ram_checkerboard_test.txt
└── ...
```

These logs contain transaction-level simulation output and are useful for debugging individual tests.


# 📷 Project Documentation

The repository also contains:

```text
block_diagram.png
```

This image shows the complete verification architecture and interaction between the DUT, interface, generator, drivers, monitors, reference model, scoreboard, environment, and test.

The repository also contains:

```text
transcript_report.png
```

which provides a visual record of the QuestaSim regression output.

---

# 🎯 What This Project Demonstrates

This project demonstrates how a reusable SystemVerilog verification environment can be constructed around a RAM design.

Instead of directly driving DUT signals from a single testbench, the verification environment separates responsibilities into dedicated components:

```text
Test
  ↓
Environment
  ↓
Generator
  ↓
Drivers
  ↓
DUT
  ↓
Monitors
  ↓
Scoreboard
  ↑
Reference Model
```

This makes the environment easier to extend with additional tests and verification features.

---

# 🚀 Future Improvements

Possible extensions to this project include:

* More functional coverage points
* Cross coverage
* SystemVerilog Assertions (SVA)
* Additional constrained-random scenarios
* Coverage-driven stimulus generation
* Coverage merging across multiple regressions
* Automated coverage closure
* Larger random regressions
* Continuous Integration (CI)
* Automated regression execution
* Additional protocol and timing checks

---

# 🧰 Tools Used

| Tool                 | Purpose                                    |
| -------------------- | ------------------------------------------ |
| **SystemVerilog**    | RTL verification and testbench development |
| **QuestaSim 2024.1** | Compilation and simulation                 |
| **UCDB**             | Coverage database                          |
| **vcover**           | Coverage report generation                 |
| **Git**              | Version control                            |
| **GitHub**           | Project repository and documentation       |

---

# 📌 Key Project Highlights

* Designed a modular **SystemVerilog verification environment**
* Implemented a **decoder-based RAM DUT**
* Developed transaction-based stimulus generation
* Used **mailbox-based communication**
* Implemented **virtual interface and clocking block** based communication
* Developed independent read/write drivers
* Developed independent read/write monitors
* Implemented a RAM reference model
* Implemented automated scoreboard checking
* Added directed testing
* Added random testing
* Added constrained-weighted random testing
* Added boundary testing
* Added block-isolation testing
* Added overwrite testing
* Added walking-0 and walking-1 patterns
* Automated a **15-test regression**
* Achieved **15/15 passing tests**
* Generated individual simulation logs
* Added UCDB-based coverage reporting

---

# 📚 Learning Outcomes

Through this project, the following SystemVerilog verification concepts were implemented in a practical design:

```text
SystemVerilog Classes
        ↓
Transactions
        ↓
Randomization & Constraints
        ↓
Mailboxes
        ↓
Drivers & Monitors
        ↓
Virtual Interfaces
        ↓
Reference Model
        ↓
Scoreboard
        ↓
Regression
        ↓
Coverage
```

The project provides practical exposure to the structure and workflow used in modular functional verification environments.

---

# 👩‍💻 Author

**Chhavi Verma**

B.Tech – Electronics & Communication Engineering

**Areas of Interest:**

* VLSI
* RTL Design
* Functional Verification
* SystemVerilog
* Digital Design

