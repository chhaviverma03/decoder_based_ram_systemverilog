module decoder_ram( input clk,rst_n,we,re,input [6:0] addr , input [7:0] wdata,
output reg [7:0] rdata , output reg valid  );

wire [3:0]cs; 
wire [4:0] word_addr;
integer i;

assign word_addr= addr[4:0];

//block selection logic
assign cs[0]=(addr[6:5]==2'b00); //cs=4'b0001
assign cs[1]=(addr[6:5]==2'b01); //cs=4'b0010
assign cs[2]=(addr[6:5]==2'b10); //cs=4'b0100
assign cs[3]=(addr[6:5]==2'b11); //cs=4'b1000


//4 m/m block
reg [7:0] mem_block0[0:31]; //block 1st
reg [7:0] mem_block1[0:31]; //block 2nd
reg [7:0] mem_block2[0:31]; //block 3rd
reg [7:0] mem_block3[0:31]; //block 4th

//main logic
always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
   for(i=0;i<31;i=i+1) begin
      mem_block0[i]=0;
      mem_block1[i]=0;
      mem_block2[i]=0;
      mem_block3[i]=0;
   end
  end
 else
    if(we) begin
      case(cs)
        4'b0001:mem_block0[word_addr]<=wdata;
        4'b0010:mem_block1[word_addr]<=wdata;
        4'b0100:mem_block2[word_addr]<=wdata;
        4'b1000:mem_block3[word_addr]<=wdata;
       endcase
     end
   end
   
//read logic
always@(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
    rdata=8'h0;
    valid=0;
    end
    
    else 
     if(re) begin
     case(cs)
        4'b0001:rdata<=mem_block0[word_addr];
        4'b0010:rdata<=mem_block1[word_addr];
        4'b0100:rdata<=mem_block2[word_addr];
        4'b1000:rdata<=mem_block3[word_addr];
        
        default:rdata<=0;
       endcase
       end
       end
 endmodule