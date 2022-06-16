module PE_right (
    input                       clk,
    input                       rst,

    // Custom bus (translated from Wishbone)
    input [16-1:0]              cfg_dat,
    input [11-1:0]              cfg_adr,

    // Address selector
    input [11-1:0]              slv_addr,

    // Rx NoC ports
    input                       rx_pr,
    input [1:0]                 rx_pd,
    output wire                 rx_pa,

    output wire                 rx_c0r,
    output wire [1:0]           rx_c0d,
    input                       rx_c0a,

    output wire                 rx_c1r,
    output wire [1:0]           rx_c1d,
    input                       rx_c1a,

    // Tx NoC ports
    input [2*16-1:0]            tx_c0d,
    output wire                 tx_c0a,

    input [2*16-1:0]            tx_c1d,
    output wire                 tx_c1a,

    output wire [2*16-1:0]      tx_pd,
    input                       tx_pa
);

    localparam NOC_WID = 16;
    localparam REGIONAL_ADDR_WID = 11;

    wire xr;
    wire [1:0] xd;
    wire xa;

    wire [2*(NOC_WID+1)-1:0] ad;
    wire aa;

    wire [2*NOC_WID-1:0] fd;
    wire fa;

    RX_NODE #(
        .N(NOC_WID)
    ) i_RX_NODE (
        .rstn(~rst   ),
        .pr  (rx_pr  ),
        .pd  (rx_pd  ),
        .pa  (rx_pa  ),
        .c0r (rx_c0r ),
        .c0d (rx_c0d ),
        .c0a (rx_c0a ),
        .c1r (rx_c1r ),
        .c1d (rx_c1d ),
        .c1a (rx_c1a ),
        .xr  (xr     ),
        .xd  (xd     ),
        .xa  (xa     )
    );

    MAC #(
        .NOC_WID(NOC_WID),
        .REGIONAL_ADDR_WID(REGIONAL_ADDR_WID)
    ) i_MAC (
        .clk     (clk     ),
        .rst     (rst     ),
        .cfg_dat (cfg_dat ),
        .cfg_adr (cfg_adr ),
        .slv_addr(slv_addr),
        .xr      (xr      ),
        .xd      (xd      ),
        .xa      (xa      ),
        .ad      (ad      ),
        .aa      (aa      ),
        .fd      (fd      ),
        .fa      (fa      )
    );

    TX_NODE #(
        .N(NOC_WID)
    ) i_TX_NODE (
        .rstn(~rst  ),
        .c0d (tx_c0d),
        .c0a (tx_c0a),
        .c1d (tx_c1d),
        .c1a (tx_c1a),
        .pd  (tx_pd ),
        .pa  (rx_pa ),
        .ad  (ad    ),
        .aa  (aa    ),
        .fd  (fd    ),
        .fa  (fa    )
    );



endmodule
