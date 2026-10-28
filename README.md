# VHDL ATM Controller (FPGA)

ATM (cash machine) controller written in VHDL and synthesized with Quartus II for the Cyclone II DE1 board.

## Features

- 7-state Moore FSM: IDLE, CHECK_PIN, MENU, SHOW_BALANCE, WITHDRAW, ERROR_ST, BLOCKED
- 4-bit PIN check, card blocked after 3 wrong attempts
- Balance shown only in the SHOW_BALANCE state
- Rising-edge detection on the enter button
- Pin assignment for the DE1 switches and LEDs

## Files

- `atm.vhd`: VHDL source code
- `atm.qpf`, `atm.qsf`: Quartus II project and pin assignments
- `Waveform.vwf`: simulation waveform
- PDF report: RTL, FSM diagram, simulation results and pin planner table

## Authors

Amani Arouri, Rym Jlidi (IoT2, FST)
