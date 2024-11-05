/*
 * Stephen Xu
 * November 3rd, 2024
 * stxu@g.hmc.edu
 * This is the mixcolumns module
 * Performs mixcolumns as specified in AES manual
 */

/////////////////////////////////////////////
// mixcolumns
//   Even funkier action on columns
//   Section 5.1.3, Figure 9
//   Same operation performed on each of four columns
/////////////////////////////////////////////

module mixcolumns (
    input logic [127:0] a,
    input logic en,
    output logic [127:0] y
);

  logic [127:0] temp_out;
  mixcolumn mc0 (
      .a(a[127:96]),
      .y(temp_out[127:96])
  );
  mixcolumn mc1 (
      .a(a[95:64]),
      .y(temp_out[95:64])
  );
  mixcolumn mc2 (
      .a(a[63:32]),
      .y(temp_out[63:32])
  );
  mixcolumn mc3 (
      .a(a[31:0]),
      .y(temp_out[31:0])
  );

  assign y = en ? temp_out : a;

endmodule

/////////////////////////////////////////////
// mixcolumn
//   Perform Galois field operations on bytes in a column
//   See EQ(4) from E. Ahmed et al, Lightweight Mix Columns Implementation for AES, AIC09
//   for this hardware implementation
/////////////////////////////////////////////

module mixcolumn (
    input  logic [31:0] a,
    output logic [31:0] y
);

  logic [7:0] a0, a1, a2, a3, y0, y1, y2, y3, t0, t1, t2, t3, tmp;

  assign {a0, a1, a2, a3} = a;
  assign tmp = a0 ^ a1 ^ a2 ^ a3;

  galoismult gm0 (
      .a(a0 ^ a1),
      .y(t0)
  );
  galoismult gm1 (
      .a(a1 ^ a2),
      .y(t1)
  );
  galoismult gm2 (
      .a(a2 ^ a3),
      .y(t2)
  );
  galoismult gm3 (
      .a(a3 ^ a0),
      .y(t3)
  );

  assign y0 = a0 ^ tmp ^ t0;
  assign y1 = a1 ^ tmp ^ t1;
  assign y2 = a2 ^ tmp ^ t2;
  assign y3 = a3 ^ tmp ^ t3;
  assign y  = {y0, y1, y2, y3};
endmodule
