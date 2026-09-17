`include "ram_transaction.sv"
//read driver
  class ram_read_driver;
    virtual ram_if vif;
    mailbox #(ram_transaction) rd_mbox;
    int unsigned txn_count;
    function new(virtual ram_if.READ_DRV vif,
mailbox #(ram_transaction) rd_mbox);
      this.vif=vif;
      this.rd_mbox=rd_mbox;
    endfunction
    task drive(ram_transaction txn);
      @(vif.rd_cb)   //waiting for read clocking block and if it happens
      vif.rd_cb.re<=1'b1;    //re=1
      vif.rd_cb.addr<=txn.addr;    //whatever the randomized txn present will be given to interface and via that to design
      @(vif.rd_cb)
      vif.rd_cb.re<=0;
      vif.rd_cb.addr<=7'h00;
      endtask
    task run();
      ram_transaction txn;
      forever begin
        rd_mbox.get(txn);   //from generator , txn instance to read driver
        drive(txn);
        txn_count++;
        //  rd_done_mbox.put(1'b1);  //to what idk
      end
    endtask
  endclass

