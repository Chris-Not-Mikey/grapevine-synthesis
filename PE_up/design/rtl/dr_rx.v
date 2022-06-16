module dr_rx #(
    parameter N = 16
) (
    input               clk,
    input               rst,
    input [2*N-1:0]     in,             // Async input; stable and non-interfering
    output reg [N-1:0]  out,            // Sync output
    output reg          out_rdy
);

    genvar i;
    integer j;
    wire [N-1:0]    in_rdy;
    wire            in_all_rdy;

    generate
    for (i = 0; i < N; i = i+1) begin
        assign in_rdy[i] = in[i*2] | in[(i*2)+1];   // Stable
    end
    endgenerate

    assign in_all_rdy = &in_rdy;    // Stable


    // TODO: do we need a clock here?
    always @(posedge clk) begin
        if (rst) begin
            out <= 0;
            out_rdy <= 0;
        end else begin
            for (j = 0; j < N; j = j+1) begin
                out[j] <= in[(j*2)+1];
            end
            out_rdy <= in_all_rdy;
        end
    end

endmodule
