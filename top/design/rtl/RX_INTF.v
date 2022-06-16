module RX_INTF #(
    parameter NOC_WID = 16
) (
    input                   clk,
    input                   rst,

    input [NOC_WID-1:0]     rx,
    input [7:0]             rx_bits,
    input                   rx_toggle,

    // NoC ports
    output wire             rx_req,
    output wire [1:0]       rx_d,
    input                   rx_ack
);

    localparam [2:0]
        IDLE = 3'b000,
        REQ_HI = 3'b001,
        DATA_HI = 3'b010,
        DATA_LO = 3'b011,
        WAIT_ACK = 3'b100;

    reg [2:0]           state;
    reg [NOC_WID-1:0]   rx_sr;
    reg [7:0]           bits_left;
    reg                 toggle_last;


    assign rx_req = (state != IDLE) ? 1 : 0;
    assign rx_d[0] = (state == DATA_HI && rx_sr[NOC_WID-1] == 0) ? 1 : 0;
    assign rx_d[1] = (state == DATA_HI && rx_sr[NOC_WID-1] == 1) ? 1 : 0;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            rx_sr <= 0;
            bits_left <= 0;
            toggle_last <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (rx_toggle != toggle_last) begin
                        state <= REQ_HI;
                        rx_sr <= rx;
                        bits_left <= rx_bits;
                        toggle_last <= rx_toggle;
                    end
                end
                REQ_HI: begin
                    if (rx_ack) begin
                        state <= DATA_HI;
                    end
                end
                DATA_HI: begin
                    if (~rx_ack) begin
                        state <= DATA_LO;
                    end
                end
                DATA_LO: begin
                    state <= WAIT_ACK;
                    rx_sr <= (rx_sr << 1);
                    bits_left <= bits_left - 1;
                end
                WAIT_ACK: begin
                    if (rx_ack) begin
                        if (bits_left == 0) begin
                            state <= IDLE;
                        end else begin
                            state <= DATA_HI;
                        end
                    end
                end
            endcase
        end
    end

endmodule


// module tb;

//     reg         clk, rst;
//     reg [15:0]  rx;
//     reg [7:0]   rx_bits;
//     reg         rx_toggle;

//     wire        rx_req;
//     wire [1:0]  rx_d;
//     wire        rx_ack;

//     RX_INTF i_RX_INTF (
//         .clk      (clk      ),
//         .rst      (rst      ),
//         .rx       (rx       ),
//         .rx_bits  (rx_bits  ),
//         .rx_toggle(rx_toggle),
//         .rx_req   (rx_req   ),
//         .rx_d     (rx_d     ),
//         .rx_ack   (rx_ack   )
//     );

//     always #5 clk = ~clk;

//     localparam [1:0]
//         IDLE = 2'b00,
//         ACK_HI = 2'b01,
//         ACK_LO = 2'b10;

//     reg [1:0] state;

//     wire rx_valid;

//     assign rx_valid = rx_d[0] | rx_d[1];
//     assign rx_ack = (state == ACK_HI) ? 1 : 0;

//     always @(posedge clk) begin
//         case (state)
//             IDLE: begin
//                 if (rx_req) begin
//                     state <= ACK_HI;
//                 end
//             end
//             ACK_HI: begin
//                 if (rx_valid) begin
//                     state <= ACK_LO;
//                 end else if (~rx_req) begin
//                     state <= IDLE;
//                 end
//             end
//             ACK_LO: begin
//                 if (~rx_valid) begin
//                     state <= ACK_HI;
//                 end
//             end
//         endcase
//     end

//     initial begin
//         $dumpfile("dump.vcd");
//         $dumpvars(0, tb);

//         clk = 0;
//         rst = 1;

//         state = IDLE;

//         rx = 0;
//         rx_bits = 0;
//         rx_toggle = 0;
//         #21;

//         rst = 0;
//         rx = 16'b1100_1010_0000_0000;
//         rx_bits = 8;
//         rx_toggle = ~rx_toggle;
//         #400;

//         #200;
//         $finish;
//     end
// endmodule
