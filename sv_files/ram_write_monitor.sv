`include "ram_transaction.sv"
//wr_monitor
class ram_write_monitor;
  virtual ram_if.WRITE_MON vif;
  mailbox #(ram_transaction) sb_wr_mbox;
  mailbox #(ram_transaction) rm_wr_mbox;
  int unsigned observed_count;
  function new(virtual ram_if.WRITE_MON vif, mailbox #(ram_transaction) sb_wr_mbox , mailbox #(ram_transaction) rm_wr_mbox);
    this.vif=vif;
    this.sb_wr_mbox=sb_wr_mbox;
    this.rm_wr_mbox=rm_wr_mbox;
  endfunction
  task run();
    ram_transaction txn;
    $display("WR_MON started");
    forever begin
      @(vif.mon_cb)            //waiting for clocking block
      if(vif.mon_cb.we==1)
        begin
          txn=new();
          txn.op=ram_transaction::WRITE;
          txn.addr=vif.mon_cb.addr;
          txn.wdata=vif.mon_cb.wdata;
          txn.valid=1'b0;
          observed_count ++;
          txn.print("wr_mon");
          //sending to sb and rm
          sb_wr_mbox.put(txn);
          rm_wr_mbox.put(txn);
        end
      end
      endtask
 endclass

