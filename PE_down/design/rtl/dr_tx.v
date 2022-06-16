module dr_tx #(
    parameter N = 16
) (
    input [N-1:0]           in,             // Sync input
    input                   in_rdy,
    output wire [2*N-1:0]   out             // Async output; stable
);

    genvar i;
    generate
    for (i = 0; i < N; i = i+1) begin
        assign out[i*2] = in_rdy ? (~in[i]) : 0;
        assign out[i*2+1] = in_rdy ? (in[i]) : 0;
    end
    endgenerate

endmodule
