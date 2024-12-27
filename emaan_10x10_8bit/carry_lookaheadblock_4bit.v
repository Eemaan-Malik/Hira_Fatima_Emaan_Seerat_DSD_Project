`timescale 1ns / 1ps

module carry_lookaheadblock_4bit(
  input  wire        cin,        // Carry-in input
  input  wire [3:0]  p, g,       // Propagate and Generate inputs
  output wire [3:0]  c,          // Carry outputs
  output wire        cout        // Carry-out output
);

  // Combinational logic for carry outputs
  assign c[0] = cin;
  assign c[1] = g[0] | (p[0] & c[0]);
  assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
  assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
  
  // Combinational logic for carry-out
  assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

endmodule
