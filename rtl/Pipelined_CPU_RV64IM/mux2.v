module mux2 (
    input  [63:0] a,
    input  [63:0] b,
    input         sel,
    output [63:0] y
);
    assign y = sel ? b : a;
endmodule
