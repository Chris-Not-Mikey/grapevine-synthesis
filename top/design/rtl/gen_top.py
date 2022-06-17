# Constants
L = 5                       # (2^L - 1) PEs
BASE_ADDR = 0x3000_0000     # Base address of root PE

PE_COUNT = 0                # Incremented during runtime
BUS_COUNT = 0
DIAL = "right"

INDENT = "    "

### Code printer functions ###
def indent():
    global INDENT
    INDENT = "{}    ".format(INDENT)


def outdent():
    global INDENT
    INDENT = INDENT[:-4]


def write(line):
    line = line.replace("\n", "\n{}".format(INDENT)).strip()
    print("{}{}".format(INDENT, line))


### Bus repeaters ###
addr = BASE_ADDR
for i in range(8):
    write("wire [15:0]  br{0}_dat;".format(i))
    write("wire [10:0]  br{0}_adr;".format(i))

    if i == 0:
        inc = (2**(L-3)-1+3)*(3*4)
    elif i == 4:
        inc = (2**(L-3)-1+2)*(3*4)
    elif i == 2 or i == 6:
        inc = (2**(L-3)-1+1)*(3*4)
    else:
        inc = (2**(L-3)-1)*(3*4)

    write("""
bus_repeater #(
    .WB_WID           (32),
    .NOC_WID          (16),
    .REGIONAL_ADDR_WID(11),
    .FANOUT           (32),
    .ADDR_LO          (32'h{1}),
    .ADDR_HI          (32'h{2})
) br{0} (
    .clk(wb_clk_i),     .rst(wb_rst_i),
    .in_dat(br_dat),    .in_adr(br_adr),
    .out_dat(br{0}_dat),  .out_adr(br{0}_adr)
);
    """.format(i, hex(addr)[2:], hex(addr+inc)[2:]))
    addr += inc
    print("")
print("")


### NoC wires ###
def print_wires(name):
    write("""
wire            {0}_rxr, {0}_rxa, {0}_txa;
wire [1:0]      {0}_rxd;
wire [31:0]     {0}_txd;
    """.format(name))

def make_noc_wires(level, name):
    print_wires(name)
    if level == 0:
        return
    make_noc_wires(level-1, "{}l".format(name))
    make_noc_wires(level-1, "{}r".format(name))

make_noc_wires(L, "r")
print("\n")
write("assign r_rxr = top_rx_req;")
write("assign r_rxd = top_rx_d;")
write("assign top_rx_ack = r_rxa;")
write("assign top_tx_d = r_txd;")
write("assign r_txa = top_tx_ack;")


### NoC PEs ###
def print_PE(level, name):
    write("""
PE_{3} {0} (
    .clk(wb_clk_i), .rst(wb_rst_i),
    .cfg_dat(br{2}_dat), .cfg_adr(br{2}_adr), .slv_addr(11'h{1}),
    .rx_pr({0}_rxr), .rx_pd({0}_rxd), .rx_pa({0}_rxa),
    .rx_c0r({0}l_rxr), .rx_c0d({0}l_rxd), .rx_c0a({0}l_rxa),
    .rx_c1r({0}r_rxr), .rx_c1d({0}r_rxd), .rx_c1a({0}r_rxa),
    .tx_c0d({0}l_txd), .tx_c0a({0}l_txa),
    .tx_c1d({0}r_txd), .tx_c1a({0}r_txa),
    .tx_pd({0}_txd), .tx_pa({0}_txa)
);
    """.format(name, hex(PE_COUNT*12)[2:], BUS_COUNT, DIAL))

    if level == 1:
        write("""
leaf #(
    .NOC_WID(16)
) leaf_{0}l (
    .clk  (wb_clk_i),
    .rst  (wb_rst_i),
    .rx_pr({0}l_rxr),
    .rx_pd({0}l_rxd),
    .rx_pa({0}l_rxa),
    .tx_pd({0}l_txd),
    .tx_pa({0}l_txa)
);
        """.format(name))
        write("""
leaf #(
    .NOC_WID(16)
) leaf_{0}r (
    .clk  (wb_clk_i),
    .rst  (wb_rst_i),
    .rx_pr({0}r_rxr),
    .rx_pd({0}r_rxd),
    .rx_pa({0}r_rxa),
    .tx_pd({0}r_txd),
    .tx_pa({0}r_txa)
);
        """.format(name))


def make_noc_PEs(level, name):
    global PE_COUNT, BUS_COUNT, DIAL
    dial = str(DIAL)
    if level == 0:
        return
    print_PE(level, name)
    if dial == "right" or dial == "left":
        DIAL = "down"
    elif dial == "down" or dial == "up":
        DIAL = "right"
    PE_COUNT += 1
    make_noc_PEs(level-1, "{}l".format(name))
    if level >= L-2:
        PE_COUNT = 0
        BUS_COUNT += 1
    if dial == "right" or dial == "left":
        DIAL = "up"
    elif dial == "down" or dial == "up":
        DIAL = "left"
    make_noc_PEs(level-1, "{}r".format(name))

make_noc_PEs(L, "r")

outdent()
write("endmodule")


