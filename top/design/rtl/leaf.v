module leaf #(
    parameter NOC_WID = 16,
    parameter INIT_MSG = 32'b01010101010101010101010101010101
)(
    input       clk,
    input       rst,

    input                       rx_pr,
    input [1:0]                 rx_pd,
    output wire                 rx_pa,

    output wire [2*NOC_WID-1:0] tx_pd,
    input                       tx_pa
);


    localparam [1:0]
        RX_IDLE = 2'b00,
        RX_ACK_HI = 2'b01,
        RX_ACK_LO = 2'b10;

    reg [1:0] rx_state;

    wire rx_valid;

    assign rx_pa = (rx_state == RX_ACK_HI) ? 1 : 0;
    assign rx_valid = rx_pd[0] || rx_pd[1];

    always @(posedge clk) begin
        if (rst) begin
            rx_state <= RX_IDLE;
        end else begin
            case (rx_state)
                RX_IDLE: begin
                    if (rx_pr) begin
                        rx_state <= RX_ACK_HI;
                    end
                end
                RX_ACK_HI: begin
                    if (~rx_pr) begin
                        rx_state <= RX_IDLE;
                    end else if (rx_valid) begin
                        rx_state <= RX_ACK_LO;
                    end
                end
                RX_ACK_LO: begin
                    if (~rx_valid) begin
                        rx_state <= RX_ACK_HI;
                    end
                end
            endcase
        end
    end

    localparam [1:0]
        TX_IDLE = 2'b00,
        TX_SEND = 2'b01,
        TX_NOSEND = 2'b10;

    reg [1:0] tx_state;

    assign tx_pd = (tx_state == TX_SEND) ? INIT_MSG : 0;

    always @(posedge clk) begin
        if (rst) begin
            tx_state <= TX_IDLE;
        end else begin
            case (tx_state)
                TX_IDLE: begin
                    if (rx_state == RX_ACK_HI) begin
                        tx_state <= TX_SEND;
                    end
                end
                TX_SEND: begin
                    if (tx_pa) begin
                        tx_state <= TX_NOSEND;
                    end
                end
                TX_NOSEND: begin
                    if (rx_state == RX_IDLE) begin
                        tx_state <= TX_IDLE;
                    end
                end
            endcase
        end
    end


endmodule
