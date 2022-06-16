module TX_NODE #(
    parameter N = 16
)(
    input                       rstn,
    input [2*N-1:0]             c0d,
    output reg                  c0a,

    input [2*N-1:0]             c1d,
    output reg                  c1a,

    output wire [2*N-1:0]       pd,
    input                       pa,

    output wire [2*(N+1)-1:0]   ad,
    input                       aa,

    input [2*N-1:0]             fd,
    output wire                 fa
);


    genvar i;

    generate
    for (i = 0; i < N; i = i+1) begin
        assign ad[i*2] = c0d[i*2] | c1d[i*2];
        assign ad[i*2+1] = c0d[i*2+1] | c1d[i*2+1];
    end
    endgenerate

    assign ad[2*N] = c0d[0] | c0d[1];
    assign ad[2*N+1] = c1d[0] | c1d[1];

    assign pd = fd;
    assign fa = pa;

    always @(*) begin
        // C-element
        if (rstn & (aa & ad[2*N])) begin
            c0a = 1;
        end else if (~rstn | (~aa & ~ad[2*N])) begin
            c0a = 0;
        end

        // C-element
        if (rstn & (aa & ad[2*N+1])) begin
            c1a = 1;
        end else if (~rstn | (~aa & ~ad[2*N+1])) begin
            c1a = 0;
        end
    end


endmodule
