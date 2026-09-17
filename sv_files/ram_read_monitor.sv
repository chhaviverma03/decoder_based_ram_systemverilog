
`include "ram_transaction.sv"

//read monitor`
class ram_read_monitor;
  virtual ram_if.READ_MON vif;
  mailbox #(ram_transaction) sb_rd_mbox;
  mailbox #(ram_transaction) rm_rd_mbox;
  int unsigned observed_count;
  function new(
    virtual ram_if.READ_MON vif,
    mailbox #(ram_transaction) sb_rd_mbox,
    mailbox #(ram_transaction) rm_rd_mbox
  );
    this.vif = vif;
    this.sb_rd_mbox = sb_rd_mbox;
    this.rm_rd_mbox = rm_rd_mbox;
  endfunction
  task run();
    ram_transaction txn;
    $display("READ_MON STARTED");
    forever begin
      @(vif.mon_cb);
      if(vif.mon_cb.re == 1) begin
        #2;
        txn = new();
        txn.op=ram_transaction::READ;
        txn.addr  = vif.mon_cb.addr;
        txn.rdata = vif.mon_cb.rdata;
        txn.valid = vif.mon_cb.valid;
        if(txn.valid == 0)
          $display("valid not generated, waiting for valid");
        observed_count++;
        txn.print("read_mon");
        sb_rd_mbox.put(txn);
        rm_rd_mbox.put(txn);
      end
    end
  endtask
endclass

