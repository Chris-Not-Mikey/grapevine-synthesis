module WB_INTF #(
    parameter WB_WID = 32,
    parameter NOC_WID = 16
) (

    input                       en,             // mux enabled

    input                       wb_clk_i,
    input                       wb_rst_i,
    input                       wbs_stb_i,
    input                       wbs_cyc_i,
    input                       wbs_we_i,
    input [(WB_WID/8)-1:0]      wbs_sel_i,
    input [WB_WID-1:0]          wbs_dat_i,
    input [WB_WID-1:0]          wbs_adr_i,
    output reg                  wbs_ack_o,
    output reg [WB_WID-1:0]     wbs_dat_o,

    // To repeaters
    output reg [WB_WID-1:0]     repeat_dat,
    output reg [WB_WID-1:0]     repeat_adr,

    // To NoC wrappers
    output reg [NOC_WID-1:0]    noc_rx,
    output reg [7:0]            noc_rx_bits,
    output reg                  noc_rx_toggle,
    input [NOC_WID-1:0]         noc_tx,
    output reg                  noc_tx_toggle
);

    localparam DEFAULT_ADDR = 32'hFFFFFFFF;     // Out of bounds for all PEs

    localparam NOC_RX_ADDR = 32'hFFFF0000;
    localparam NOC_TX_ADDR = 32'hFFFF0004;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i | ~en) begin
            wbs_dat_o <= 0;
            repeat_dat <= 0;
            repeat_adr <= DEFAULT_ADDR;
            noc_rx <= 0;
            noc_rx_bits <= 0;
            noc_rx_toggle <= 0;
            noc_tx_toggle <= 0;
        end else if (wbs_stb_i && wbs_cyc_i) begin
            repeat_dat <= 0;
            repeat_adr <= DEFAULT_ADDR;
            noc_rx <= 0;
            wbs_dat_o <= 0;

            if (wbs_we_i && ~wbs_ack_o) begin                   // Write: stolen from Charles
                repeat_dat <= wbs_dat_i;
                repeat_adr <= wbs_adr_i;

                if (wbs_adr_i == NOC_RX_ADDR) begin
                    noc_rx <= wbs_dat_i[NOC_WID-1:0];
                    noc_rx_bits <= wbs_dat_i[NOC_WID+7:NOC_WID];
                    noc_rx_toggle <= ~noc_rx_toggle;
                end

            end else if (~wbs_we_i && ~wbs_ack_o) begin         // Read: stolen from Charles
                if (wbs_adr_i == NOC_TX_ADDR) begin
                    wbs_dat_o <= noc_tx;
                    noc_tx_toggle <= ~noc_tx_toggle;
                end
            end
        end
    end

    always @(posedge wb_clk_i) begin
        if (wb_rst_i | ~en) begin
            wbs_ack_o <= 0;
        end else begin
            wbs_ack_o <= (wbs_stb_i && wbs_cyc_i);              // We can process immediately: stolen from Charles
        end
    end
endmodule
