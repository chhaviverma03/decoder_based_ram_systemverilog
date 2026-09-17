interface ram_if(input clk);
  timeunit 1ns;
  timeprecision 1ps;
  logic rst_n;
  logic we;
  logic re;
  logic [6:0] addr;
  logic [7:0] wdata;
  logic [7:0] rdata;
  logic valid;

  // WRITE DRIVER CLOCKING BLOCK
  clocking wr_cb @(posedge clk);
    default input #1 output #1;

    output we;
    output addr;
    output wdata;

    input rdata;
    input valid;
  endclocking


  // READ DRIVER CLOCKING BLOCK
  clocking rd_cb @(posedge clk);
    default input #1 output #1;

    output re;
    output addr;

    input rdata;
    input valid;
  endclocking


  // MONITOR CLOCKING BLOCK
  clocking mon_cb @(posedge clk);
    default input #1;

    input we;
    input re;
    input addr;
    input wdata;
    input rdata;
    input valid;
  endclocking


  // MODPORTS
  modport WRITE_DRV (
    clocking wr_cb,
    input clk
  );

  modport READ_DRV (
    clocking rd_cb,
    input clk
  );

  modport WRITE_MON (
    clocking mon_cb,
    input clk
  );

  modport READ_MON (
    clocking mon_cb,
    input clk
  );

endinterface
