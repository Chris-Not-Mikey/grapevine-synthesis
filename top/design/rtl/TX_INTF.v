module TX_INTF #(
    parameter NOC_WID = 16
) (
    input                       clk,
    input                       rst,

    output reg [NOC_WID-1:0]    tx,

    // NoC ports
    input [2*NOC_WID-1:0]       tx_d,
    output wire                 tx_ack
);

    localparam [1:0]
        IDLE = 2'b00,
        DATA_LOAD = 2'b01,
        ACK_HI = 2'b10;

    reg [2:0]           state;

    wire [NOC_WID-1:0]  tx_valid_bitwise;
    wire                tx_valid;
    wire                tx_empty;

    genvar i;
    generate
        for (i = 0; i < NOC_WID; i = i+1) begin
            assign tx_valid_bitwise[i] = (tx_d[2*i] | tx_d[2*i+1]);
        end
    endgenerate

    assign tx_valid = &tx_valid_bitwise;
    assign tx_empty = ~(|tx_valid_bitwise);

    assign tx_ack = (state == ACK_HI) ? 1 : 0;

    integer j;
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            tx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_valid) begin
                        state <= DATA_LOAD;
                        for (j = 0; j < NOC_WID; j = j+1) begin
                            tx[j] <= tx_d[2*j+1];
                        end
                    end
                end
                DATA_LOAD: begin
                    state <= ACK_HI;
                end
                ACK_HI: begin
                    if (tx_empty) begin
                        state <= IDLE;
                    end
                end

            endcase

        end
    end
endmodule


// module tb;

//     reg         clk, rst;
//     wire [3:0]  tx;
//     reg [7:0]   tx_d;
//     wire        tx_ack;

//     TX_INTF #(
//         .NOC_WID(4)
//     ) i_TX_INTF (
//         .clk(clk),
//         .rst(rst),
//         .tx(tx),
//         .tx_d(tx_d),
//         .tx_ack(tx_ack)
//     );

//     always #5 clk = ~clk;

//     initial begin
//         $dumpfile("dump.vcd");
//         $dumpvars(0, tb);

//         clk = 0;
//         rst = 1;

//         tx_d = 0;
//         #21;

//         rst = 0;
//         tx_d = 8'b10100101;
//         #400;
//         tx_d = 0;

//         #200;
//         $finish;

//     end


// endmodule
