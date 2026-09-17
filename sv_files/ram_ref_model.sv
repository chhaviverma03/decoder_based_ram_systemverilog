`include "ram_transaction.sv"
//ref model
class ram_ref_model;
  logic [7:0]mem[0:127];
  mailbox #(ram_transaction) rm_wr_mbox;
  mailbox #(ram_transaction) rm_rd_mbox;
  mailbox #(ram_transaction) sb_exp_mbox;
  int unsigned wr_processed;
  int unsigned rd_processed;
  function new(  mailbox #(ram_transaction) rm_wr_mbox,
               mailbox #(ram_transaction) rm_rd_mbox,
               mailbox #(ram_transaction) sb_exp_mbox);
  this.rm_wr_mbox=rm_wr_mbox;
  this.rm_rd_mbox=rm_rd_mbox;
  this.sb_exp_mbox=sb_exp_mbox;
  endfunction
  //this task write the data into the ref model
  task run_writes();
  ram_transaction txn;
    $display("Write task [ ref model] started");
    forever begin
      rm_wr_mbox.get(txn); //trying to get the data from wr_mon
      mem[txn.addr]=txn.wdata;
      wr_processed++;
      $display("[RM] write_addr=%0h , data =%0h , block=%0d ", txn.addr,txn.wdata, txn.addr[6:5]);
    end
  endtask
    //this task read the data into the ref model
  task run_reads();
    ram_transaction txn;
    $display("[RM] READ TASK STARTED");
    forever begin
      rm_rd_mbox.get(txn);
      txn.rdata=mem[txn.addr];
      txn.valid=1'b1;
      rd_processed++;
    end
  endtask
endclass

