`include "ram_transaction.sv"
//scoreboard
class ram_scoreboard;
  mailbox #(ram_transaction) sb_rd_mbox;  //rd_mon //dut
  mailbox #(ram_transaction) sb_exp_mbox;  //getting from RM //refm
  mailbox #(ram_transaction) sb_wr_mbox; //wr_mon //dut
  int unsigned pass_count;
  int unsigned fail_count;
  int unsigned wr_count;
  function new(mailbox #(ram_transaction) sb_rd_mbox,
               mailbox #(ram_transaction) sb_exp_mbox,
               mailbox #(ram_transaction) sb_wr_mbox);
      this.sb_rd_mbox= sb_rd_mbox;
      this.sb_exp_mbox= sb_exp_mbox;
      this.sb_wr_mbox= sb_wr_mbox;
  endfunction
  //check the txn
  task run_check;
    ram_transaction actual,expected;
    $display("SB started");
    forever begin
      sb_rd_mbox.get(actual);  //actual data i am getting from dut via rd_mon
      sb_exp_mbox.get(expected);
      check(actual,expected);  //check if 2 are equal or not
    end
  endtask
  function void check(ram_transaction actual,
                      ram_transaction expected);
    bit addr_match;
    bit data_match;
    bit valid_match;
    addr_match= (actual.addr==expected.addr);  //addr_match=1 if both are equal
    data_match=(actual.rdata==expected.rdata);
    valid_match=(actual.valid==expected.valid);
    if(addr_match  && data_match && valid_match)begin
      pass_count++;
      $display("sb passed addr=%0d, data=%0d"
                     ,actual.addr,actual.rdata);
    end
    else begin
      fail_count++;
      if(!addr_match)
        $display("address  mismatch ");
      else if(!data_match)
        $display("data  mismatch ");
      else if(!valid_match)
        $display("valid  mismatch ");
    end
  endfunction
  // --------------------------------------------------
// report()
// Print final scoreboard results
// --------------------------------------------------
function void report();
  $display("----------------------------------------");
  $display("          RAM SCOREBOARD REPORT         ");
  $display("----------------------------------------");
  $display("Total writes : %0d", wr_count);
  $display("Total passed : %0d", pass_count);
  $display("Total failed : %0d", fail_count);
  if (fail_count == 0)
    $display("RESULT       : PASS");
  else
    $display("RESULT       : FAIL");
  $display("----------------------------------------");
endfunction
endclass
