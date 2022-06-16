module MAC #(
    parameter NOC_WID = 16,
    parameter REGIONAL_ADDR_WID = 11
)(
    input                       clk,
    input                       rst,

    // Custom bus (translated from Wishbone)
    input [NOC_WID-1:0]                 cfg_dat,
    input [REGIONAL_ADDR_WID-1:0]       cfg_adr,

    // Address selector
    input [REGIONAL_ADDR_WID-1:0]       slv_addr,


    // Async NoC ports
    input                       xr,
    input [1:0]                 xd,             // one-hot encoding
    output wire                 xa,

    input [2*(NOC_WID+1)-1:0]   ad,             // one-hot encoding
    output wire                 aa,

    output wire [2*NOC_WID-1:0] fd,             // one-hot encoding
    input                       fa
);

    // Config: slow clock, 1-cycle write (no acknowledge)
    //  --------------------
    // | Reg name  | Offset |
    // |-----------+--------|
    // | bits_peek | 0      |
    // | xmid      | 4      |
    // | m         | 8      |
    //  --------------------

    reg [NOC_WID-1:0]   bits_peek, xmid, m;

    always @(posedge clk) begin
        if (rst) begin
            bits_peek <= 0;
            xmid <= 0;
            m <= 0;
        end else begin
            if (cfg_adr == slv_addr) begin
                bits_peek <= cfg_dat;
            end else if (cfg_adr == slv_addr+4) begin
                xmid <= cfg_dat;
            end else if (cfg_adr == slv_addr+8) begin
                m <= cfg_dat;
            end
        end
    end


    // RX: receive x 1-bit-at-a-time
    localparam [1:0]
        RX_IDLE     = 2'b00,
        RX_ACK_HI   = 2'b01,
        RX_ACK_LO   = 2'b10;

    reg [1:0]                   rx_state;
    reg [NOC_WID-1:0]           x;
    reg [$clog2(NOC_WID):0]     bits_recvd;
    wire                        xd_arrived;

    assign xd_arrived = xd[0] || xd[1];
    assign xa = (rx_state == RX_ACK_HI);

    always @(posedge clk) begin
        if (rst) begin
            rx_state <= RX_IDLE;
            x <= 0;
            bits_recvd <= 0;
        end else begin
            case (rx_state)
                RX_IDLE: begin
                    if (xr) begin
                        rx_state <= RX_ACK_HI;
                        x <= 0;
                        bits_recvd <= 0;
                    end
                end
                RX_ACK_HI: begin
                    if (xd_arrived) begin
                        rx_state <= RX_ACK_LO;
                        if (bits_recvd < bits_peek) begin
                            x <= (x << 1) | xd[1];
                            bits_recvd <= bits_recvd + 1;
                        end
                    end else if (~xr) begin
                        rx_state <= RX_IDLE;
                    end
                end
                RX_ACK_LO: begin
                    if (~xd_arrived) rx_state <= RX_ACK_HI;
                end
                default: begin
                    rx_state <= RX_IDLE;
                    x <= 0;
                    bits_recvd <= 0;
                end
            endcase
        end
    end

    // TX: choose and provide accumulated value

    wire [NOC_WID:0]    a_sync;
    wire                a_sync_rdy;
    dr_rx #(
        .N(NOC_WID+1)
    ) i_dr_rx (
        .clk(clk),
        .rst(rst),
        .in(ad),
        .out(a_sync),
        .out_rdy(a_sync_rdy)
    );

    wire                a_MSb;
    wire [NOC_WID-1:0]  b;
    assign a_MSb = a_sync[NOC_WID];
    assign b = a_sync[NOC_WID-1:0];

    wire [NOC_WID-1:0]  s_left, s_right;
    assign s_left = m*x;
    assign s_right = m*(xmid-x);

    wire [NOC_WID-1:0]  f_sync;
    reg                 f_sync_rdy;

    assign f_sync = a_MSb ? s_right : s_left;

    dr_tx #(
        .N(NOC_WID)
    ) i_dr_tx (
        .in(f_sync),
        .in_rdy(f_sync_rdy),
        .out(fd)
    );

    always @(posedge clk) begin
        if (rst) begin
            f_sync_rdy <= 0;
        end else begin
            f_sync_rdy <= a_sync_rdy;
        end
    end


    assign aa = fa;     // feedback/acknowledge: no need to synchronize




endmodule
