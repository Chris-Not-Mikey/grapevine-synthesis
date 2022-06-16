module bus_repeater #(
    parameter WB_WID = 32,
    parameter NOC_WID = 16,
    parameter REGIONAL_ADDR_WID = 9,
    parameter FANOUT = 32,
    parameter ADDR_LO = 32'h0,
    parameter ADDR_HI = 32'b001000000000        // non-inclusive
) (

    input                               clk,
    input                               rst,
    input [WB_WID-1:0]                  in_dat,
    input [WB_WID-1:0]                  in_adr,

    output reg [NOC_WID-1:0]            out_dat,
    output reg [REGIONAL_ADDR_WID-1:0]  out_adr
);

    always @(posedge clk) begin
        if (rst) begin
            out_dat <= 0;
            out_adr <= 1;       // Note: address 0 actually maps to a PE
        end else begin
            if (in_adr >= ADDR_LO && in_adr < ADDR_HI) begin
                out_dat <= in_dat[NOC_WID-1:0];
                out_adr <= in_adr-ADDR_LO;
            end else begin
                out_dat <= 0;
                out_adr <= 1;
            end
        end
    end

endmodule


// module tb;

//     reg clk, rst;
//     reg [31:0] in_dat, in_adr;
//     wire [15:0] out_dat;
//     wire [8:0] out_adr;

//     bus_repeater i_bus_repeater (
//         .clk    (clk    ),
//         .rst    (rst    ),
//         .in_dat (in_dat ),
//         .in_adr (in_adr ),
//         .out_dat(out_dat),
//         .out_adr(out_adr)
//     );

//     always #5 clk = ~clk;

//     initial begin
//         $dumpfile("dump.vcd");
//         $dumpvars(0, tb);

//         clk = 0;
//         rst = 1;

//         in_dat = 0;
//         in_adr = 0;

//         #21;
//         rst = 0;
//         in_dat = 1;
//         in_adr = 0;

//         #10;
//         in_dat = 2;
//         in_adr = 32'b001000000000;

//         #200;
//         $finish;
//     end

// endmodule
