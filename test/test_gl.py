import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
import random
from cocotb.result import TestFailure

clocks_per_phase = 10

async def reset(dut):
    dut.rst_n.value   = 1
    dut.rst_n.value   = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1;
    await ClockCycles(dut.clk, 5) # how long to wait for the debouncers to clear

@cocotb.test()
async def test_all(dut):

    clock = Clock(dut.clk, 10, units="ns")
    
    dut.VGND.value = 0
    dut.VPWR.value = 1

    cocotb.start_soon(clock.start())
    
    # Reset the DUT
    dut.rst_n.value = 0

    await FallingEdge(dut.clk)
    dut.rst_n.value = 1

    await Timer(10, units="ns") 

    # Test write operation
    dut.ena.value = 1
    dut.ui_in.value = 0xAA

    # Wait for less than the timeout period
    await Timer(200, units="ns")  

    dut.ui_in.value = 0xBB
    
    # Check if the watchdog is expired
    #assert dut.watchdog_expired == 1, "Watchdog expired as expected"
        
    
    await Timer(250, units="ns")
    #assert dut.watchdog_expired != 0, "Watchdog is not running as expected"  
    
