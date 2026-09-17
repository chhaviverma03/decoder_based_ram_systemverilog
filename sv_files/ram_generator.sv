`include "ram_transaction.sv"
class ram_generator;
  local mailbox #(ram_transaction) wr_mbx;
  local mailbox #(ram_transaction) rd_mbx;
  local mailbox #(bit) wr_done_mbox;
  // Constructor
  function new(
    mailbox #(ram_transaction) wr_mbx,
    mailbox #(ram_transaction) rd_mbx,
    mailbox #(bit) wr_done_mbox
  );
    this.wr_mbx      = wr_mbx;
    this.rd_mbx     = rd_mbx;
    this.wr_done_mbox = wr_done_mbox;
  endfunction
  // Internal API, only run() calls these
  local task send_write(
    input logic [6:0] addr,
    input logic [7:0] data
  );
    ram_transaction txn = new();
    txn.op    = ram_transaction::WRITE;
    txn.addr  = addr;
    txn.wdata = data;
    txn.print("[GENERATOR-WRITE]");
    wr_mbx.put(txn);  // sent to write driver
  endtask
  local task wait_writes_done(input int unsigned n);
    bit tok;
    repeat(n)
      wr_done_mbox.get(tok);  // ACK from write driver
  endtask
  local task send_read(input logic [6:0] addr);
    ram_transaction txn = new();
    txn.op   = ram_transaction::READ;
    txn.addr = addr;
    txn.print("[GENERATOR-READ]");
    rd_mbx.put(txn);  // sent to read driver
  endtask
//run task generate the tracsactionns
  task run(
    input logic [6:0] wr_addrs [],
    input logic [7:0] wr_datas [],
    input int unsigned n_writes,
    input logic [6:0] rd_addrs [],
    input int unsigned n_reads,
    input bit randomize_txns = 0
  );
    // ---------------- WRITES ----------------
    $display("[GEN] sending %0d writes", n_writes);
    if (randomize_txns) begin
      for (int i = 0; i < n_writes; i++) begin
        ram_transaction txn = new();
        if (!txn.randomize() with { op == WRITE; })
          $fatal(1, "[GEN] randomize() failed for write %0d", i);
        send_write(txn.addr, txn.wdata);
      end
    end
    else begin
      for (int i = 0; i < n_writes; i++) begin
        send_write(wr_addrs[i], wr_datas[i]);
      end
    end
    // ---------------- WAIT FOR WRITES ----------------
    // Drain all writes before issuing reads
    wait_writes_done(n_writes);
    $display("[GEN] all writes done");
    // ---------------- READS ----------------
    $display("[GEN] SENDING %0d reads", n_reads);
    if (randomize_txns) begin
      for (int i = 0; i < n_reads; i++) begin
        ram_transaction txn = new();
        if (!txn.randomize() with { op == READ; })
          $fatal(1, "[GEN] randomize() failed for READ %0d", i);
        send_read(txn.addr);
      end
    end
    else begin
      for (int i = 0; i < n_reads; i++) begin
        send_read(rd_addrs[i]);
      end
    end
    $display("[GEN] done");
  endtask
endclass : ram_generator
