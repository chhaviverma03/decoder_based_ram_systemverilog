`include "ram_transaction.sv"
//driver
class ram_wr_driver;
  virtual ram_if vif;
  mailbox#(ram_transaction) wr_mbx;
  mailbox#(bit) wr_done_mbox;
  int unsigned txn_count;
  function new(virtual ram_if.WRITE_DRV vif ,
 mailbox #(ram_transaction) wr_mbx,
 mailbox #(bit) wr_done_mbox
,int unsigned txn_count=0);
    this.vif=vif;
    this.wr_mbx=wr_mbx;
    this.wr_done_mbox=wr_done_mbox;
    this.txn_count=txn_count;
  endfunction
 task reset(int cycles=4);
    $display("applying reset task");
    vif.rst_n <= 1'b0;
    vif.wr_cb.we    <= 1'b0;
    vif.re    <=1'b0;
    vif.addr  <= 0;
    vif.wdata <= 0;
    repeat(cycles)
      @(vif.wr_cb);           //  Wait for cycles number of clocking-block events.
                             //set the signals to reset values once, then wait 4 clocks.
    vif.rst_n <= 1'b1;
    $display("reset deasserted");
endtask
  //drive data to dut
  task drive(ram_transaction txn);
    @(vif.wr_cb);
    vif.wr_cb.we<=1'b1;
    vif.wr_cb.addr<=txn.addr;
    vif.wr_cb.wdata<=txn.wdata;
    @(vif.wr_cb);
    $display("we=%0d",vif.wr_cb.we);
    $display("addr=%0d",vif.wr_cb.addr);
    $display("wdata=%0d",vif.wr_cb.wdata);
    vif.wr_cb.we    <= 1'b0;
    vif.wr_cb.addr  <= 7'h00;
    vif.wr_cb.wdata <= 8'h00;
  endtask
  task run; //this will be called by env
    ram_transaction txn;
    forever begin
      wr_mbx.get(txn);
      drive(txn);
      txn_count++;
      wr_done_mbox.put(1'b1); // to genrator
    end
  endtask
endclass

