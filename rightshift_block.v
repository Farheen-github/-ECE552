
module rightshift_block( Inp,Out,ShAmt,en);        

  input  [15:0] Inp; 
  output  [15:0] Out; 
  input [3:0]   ShAmt;
  input en;
  wire [15:0]    R1,R2,R3;

	// Signals for clkrst module
    wire clk;
    wire rst;
    wire err;
    assign err = 1'b0;

	clkrst c0(.clk(clk),
              .rst(rst),
              .err(err));

  wire firststage_in;
  assign firststage_in=(~en & Inp[0]);

mux2to1 m0 (R1[0], Inp[1],  Inp[0], ShAmt[0]); 
mux2to1 m1 (R1[1], Inp[2], Inp[1], ShAmt[0]); 
mux2to1 m2 (R1[2], Inp[3], Inp[2], ShAmt[0]); 
mux2to1 m3 (R1[3], Inp[4], Inp[3], ShAmt[0]); 
mux2to1 m4 (R1[4], Inp[5], Inp[4], ShAmt[0]); 
mux2to1 m5 (R1[5], Inp[6], Inp[5], ShAmt[0]); 
mux2to1 m6 (R1[6], Inp[7], Inp[6], ShAmt[0]); 
mux2to1 m7 (R1[7], Inp[8], Inp[7], ShAmt[0]); 
mux2to1 m8 (R1[8], Inp[9], Inp[8], ShAmt[0]); 
mux2to1 m9 (R1[9], Inp[10], Inp[9], ShAmt[0]); 
mux2to1 mA (R1[10], Inp[11], Inp[10], ShAmt[0]); 
mux2to1 mB (R1[11], Inp[12], Inp[11], ShAmt[0]); 
mux2to1 mC (R1[12], Inp[13], Inp[12], ShAmt[0]); 
mux2to1 mD (R1[13], Inp[14], Inp[13], ShAmt[0]); 
mux2to1 mE (R1[14], Inp[15], Inp[14], ShAmt[0]); 
mux2to1 mF (R1[15], firststage_in, Inp[15], ShAmt[0]); 


  wire [1:0] secondstage_in;
  assign secondstage_in[0]=(~en & R1[0]);
  assign secondstage_in[1]=(~en & R1[1]);

mux2to1 m00 (R2[0], R1[2],  R1[0], ShAmt[1]); 
mux2to1 m11 (R2[1], R1[3],  R1[1], ShAmt[1]); 
mux2to1 m22 (R2[2], R1[4], R1[2], ShAmt[1]); 
mux2to1 m33 (R2[3], R1[5], R1[3], ShAmt[1]); 
mux2to1 m44 (R2[4], R1[6], R1[4], ShAmt[1]); 
mux2to1 m55 (R2[5], R1[7], R1[5], ShAmt[1]); 
mux2to1 m66 (R2[6], R1[8], R1[6], ShAmt[1]); 
mux2to1 m77 (R2[7], R1[9], R1[7], ShAmt[1]); 
mux2to1 m88 (R2[8], R1[10], R1[8], ShAmt[1]); 
mux2to1 m99 (R2[9], R1[11], R1[9], ShAmt[1]); 
mux2to1 mAA (R2[10], R1[12], R1[10], ShAmt[1]); 
mux2to1 mBB (R2[11], R1[13], R1[11], ShAmt[1]); 
mux2to1 mCC (R2[12], R1[14], R1[12], ShAmt[1]); 
mux2to1 mDD (R2[13], R1[15], R1[13], ShAmt[1]); 
mux2to1 mEE (R2[14], secondstage_in[0], R1[14], ShAmt[1]); 
mux2to1 mFF (R2[15], secondstage_in[1], R1[15], ShAmt[1]); 


  wire [3:0] thirdstage_in;
  assign thirdstage_in[0]=(~en & R2[0]);
  assign thirdstage_in[1]=(~en & R2[1]);
  assign thirdstage_in[2]=(~en & R2[2]);
  assign thirdstage_in[3]=(~en & R2[3]);

mux2to1 m000 (R3[0], R2[4],  R2[0], ShAmt[2]); 
mux2to1 m111 (R3[1], R2[5],  R2[1], ShAmt[2]); 
mux2to1 m222 (R3[2], R2[6],  R2[2], ShAmt[2]); 
mux2to1 m333 (R3[3], R2[7],  R2[3], ShAmt[2]);
mux2to1 m444 (R3[4], R2[8], R2[4], ShAmt[2]);  
mux2to1 m555 (R3[5], R2[9], R2[5], ShAmt[2]);  
mux2to1 m666 (R3[6], R2[10], R2[6], ShAmt[2]);  
mux2to1 m777 (R3[7], R2[11], R2[7], ShAmt[2]);  
mux2to1 m888 (R3[8], R2[12], R2[8], ShAmt[2]);  
mux2to1 m999 (R3[9], R2[13], R2[9], ShAmt[2]);  
mux2to1 mAAA (R3[10], R2[14], R2[10], ShAmt[2]);  
mux2to1 mBBB (R3[11], R2[15], R2[11], ShAmt[2]);  
mux2to1 mCCC (R3[12], thirdstage_in[0], R2[12], ShAmt[2]);  
mux2to1 mDDD (R3[13], thirdstage_in[1], R2[13], ShAmt[2]);  
mux2to1 mEEE (R3[14], thirdstage_in[2], R2[14], ShAmt[2]);  
mux2to1 mFFF (R3[15], thirdstage_in[3], R2[15], ShAmt[2]);  
 

  wire [8:0] fourthstage_in;
  assign fourthstage_in[0]=(~en & R3[0]);
  assign fourthstage_in[1]=(~en & R3[1]);
  assign fourthstage_in[2]=(~en & R3[2]);
  assign fourthstage_in[3]=(~en & R3[3]);
  assign fourthstage_in[4]=(~en & R3[4]);
  assign fourthstage_in[5]=(~en & R3[5]);
  assign fourthstage_in[6]=(~en & R3[6]);
  assign fourthstage_in[7]=(~en & R3[7]);


mux2to1 m0000 (Out[0], R3[8],  R3[0], ShAmt[3]); 
mux2to1 m1111 (Out[1], R3[9],  R3[1], ShAmt[3]); 
mux2to1 m2222 (Out[2], R3[10],  R3[2], ShAmt[3]); 
mux2to1 m3333 (Out[3], R3[11],  R3[3], ShAmt[3]); 
mux2to1 m4444 (Out[4], R3[12],  R3[4], ShAmt[3]); 
mux2to1 m5555 (Out[5], R3[13],  R3[5], ShAmt[3]); 
mux2to1 m6666 (Out[6], R3[14],  R3[6], ShAmt[3]); 
mux2to1 m7777 (Out[7], R3[15],  R3[7], ShAmt[3]); 
mux2to1 m8888 (Out[8], fourthstage_in[0],  R3[8], ShAmt[3]); 
mux2to1 m9999 (Out[9], fourthstage_in[1],  R3[9], ShAmt[3]); 
mux2to1 mAAAA (Out[10], fourthstage_in[2],  R3[10], ShAmt[3]); 
mux2to1 mBBBB (Out[11], fourthstage_in[3],  R3[11], ShAmt[3]); 
mux2to1 mCCCC (Out[12], fourthstage_in[4],  R3[12], ShAmt[3]); 
mux2to1 mDDDD (Out[13], fourthstage_in[5],  R3[13], ShAmt[3]); 
mux2to1 mEEEE (Out[14], fourthstage_in[6],  R3[14], ShAmt[3]); 
mux2to1 mFFFF (Out[15], fourthstage_in[7],  R3[15], ShAmt[3]); 



endmodule
