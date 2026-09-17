`timescale 1ns/1ps
`include "ram_test.sv"

module ram_tb_top;

//-----------------------------------------------
//clock
logic clk;
initial begin
clk=0;
forever #5 clk=~clk;
end

//-----------------------------------------------
//INTERFACE
ram_if ramif(clk);

//-----------------------------------------------
//DUT
decoder_ram dut(
.clk(clk),
.rst_n(ramif.rst_n),
.we(ramif.we),
.re(ramif.re),
.addr(ramif.addr),
.wdata(ramif.wdata),
.rdata(ramif.rdata),
.valid(ramif.valid)
);

//-----------------------------------------------
//TEST HANDLE
string testname;
ram_base_test test;

//-----------------------------------------------
//TEST SELECTION
initial begin

//-----------------------------------------------
//GET TESTNAME
if(!$value$plusargs("TESTNAME=%s",testname)) begin
$display("\n==================================================");
$display("[TOP] ERROR : TESTNAME NOT PROVIDED");
$display("==================================================");
$display("\nUsage Example:");
$display("vsim work.ram_tb_top +TESTNAME=ram_random_test");
$finish;
end

//-----------------------------------------------
//DISPLAY TESTNAME
$display("\n==================================================");
$display("[TOP] RUNNING TEST : %s",testname);
$display("==================================================\n");

//-----------------------------------------------
//CREATE TEST
case(testname)

//==============================================================
// TEST 1 - RANDOM R/W
//==============================================================
"ram_random_test":
test=ram_random_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 2 - BLOCK BOUNDARY TEST
//==============================================================
"ram_block_boundary_test":
test=ram_block_boundary_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 3 - FULL ADDRESS SWEEP
//==============================================================
"ram_full_sweep_test":
test=ram_full_sweep_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 4 - WALKING 1s ON DATA BUS
//==============================================================
"ram_walking1_data_test":
test=ram_walking1_data_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 5 - WALKING 0s ON DATA BUS
//==============================================================
"ram_walking0_data_test":
test=ram_walking0_data_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 6 - WALKING 1s ON ADDRESS BUS
//==============================================================
"ram_walking1_addr_test":
test=ram_walking1_addr_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 7 - WALKING 0s ON ADDRESS BUS
//==============================================================
"ram_walking0_addr_test":
test=ram_walking0_addr_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 8 - SAME ADDRESS BACK-TO-BACK OVERWRITE
//==============================================================
"ram_same_addr_overwrite_test":
test=ram_same_addr_overwrite_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 9 - TOGGLE SAME ADDRESS
//==============================================================
"ram_toggle_addr_test":
test=ram_toggle_addr_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 10 - CHECKERBOARD PATTERN
//==============================================================
"ram_checkerboard_test":
test=ram_checkerboard_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 11 - BLOCK ISOLATION
//==============================================================
"ram_block_isolation_test":
test=ram_block_isolation_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 12 - ALL ZEROS
//==============================================================
"ram_allzero_test":
test=ram_allzero_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 13 - ALL ONES
//==============================================================
"ram_allone_test":
test=ram_allone_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 14 - READ BEFORE WRITE
//==============================================================
"ram_read_before_write_test":
test=ram_read_before_write_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// TEST 15 - CONSTRAINED WEIGHTED TEST
//==============================================================
"ram_constrained_weighted_test":
test=ram_constrained_weighted_test::new(
ramif,
ramif,
ramif,
ramif
);

//==============================================================
// DEFAULT
//==============================================================
default: begin
$display("\n==================================================");
$display("[TOP] ERROR : UNKNOWN TEST");
$display("[TOP] TESTNAME = %s",testname);
$display("==================================================");
$finish;
end

endcase

//-----------------------------------------------
//RUN TEST
test.run();

//-----------------------------------------------
//FINISH
$display("\n==================================================");
$display("[TOP] TEST COMPLETED : %s",testname);
$display("==================================================\n");

#20;

$display("all tests completed");

end

endmodule
