`ifndef RAM_TRANSACTION_SV
`define RAM_TRANSACTION_SV
//ram_transaction
class ram_transaction;
  typedef enum{WRITE,READ} op_t;  //which type of operation we can have => read and write
  rand op_t op;
  rand logic [6:0]addr;
  rand logic [7:0]wdata;
  logic [7:0]rdata;
  logic valid;
  function new();
    op=WRITE;
    addr=7'h00;
    wdata=8'h0;
    rdata=8'h00;
    valid=1'b0;
  endfunction
  function void print(string tag="");
    $display("%0t : %s | op=%s | addr=%0h |wdata =%0h | rdata=%0h | valid=%0b "
,$time,tag,op,addr,wdata,rdata,valid);
  endfunction
endclass
 
`endif