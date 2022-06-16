module RX_NODE #(
    parameter N = 16
)(
    input                       rstn,
    input                       pr,
    input [1:0]                 pd,
    output wire                 pa,

    output wire                 c0r,
    output wire [1:0]           c0d,
    input                       c0a,

    output wire                 c1r,
    output wire [1:0]           c1d,
    input                       c1a,

    output wire                 xr,
    output wire [1:0]           xd,
    input                       xa
);

    wire rst;
    assign rst = ~rstn;

    wire        _u0, _u1, uu, __v;
    wire [1:0]  _pd;
    wire        _pr, _c0r, _c0a, _c1r, _c1a, _xr, _xa;

    reg         u0, u1, _v;
    reg         _and0a, _and1a;

    assign _u0 = ~u0;
    assign _u1 = ~u1;

    assign uu = ~(_u0 & _u1);

    assign pa = ~((_pr | uu) & _and0a & _and1a);

    assign __v = ~_v;

    assign _pd[0] = ~pd[0];
    assign _pd[1] = ~pd[1];

    assign _c0r = ~(__v & u0);
    assign _c1r = ~(__v & u1);

    assign c0d[0] = ~(_pd[0] | _c0r);
    assign c0d[1] = ~(_pd[1] | _c0r);

    assign c1d[0] = ~(_pd[0] | _c1r);
    assign c1d[1] = ~(_pd[1] | _c1r);

    assign _xr = _pr;
    assign xd = c0d | c1d;

    assign _pr = ~pr;
    assign c0r = ~_c0r;
    assign _c0a = ~c0a;
    assign c1r = ~_c1r;
    assign _c1a = ~c1a;
    assign xr = ~_xr;
    assign _xa = ~xa;

    always @(*) begin
        if (~rst & (~_pd[0] & ~__v)) begin
            u0 = 1;
        end else if (rst | (_pr)) begin
            u0 = 0;
        end

        if (~rst & (~_pd[1] & ~__v)) begin
            u1 = 1;
        end else if (rst | (_pr)) begin
            u1 = 0;
        end

        if (~uu) begin
            _v = 1;
        end else if (uu & _pd[0] & _pd[1]) begin
            _v = 0;
        end

        if (~rst & (~_xa & ~_c0a)) begin
            _and0a = 0;
        end else if (rst | (_xa & _c0a)) begin
            _and0a = 1;
        end

        if (~rst & (~_xa & ~_c1a)) begin
            _and1a = 0;
        end else if (rst | (_xa & _c1a)) begin
            _and1a = 1;
        end
    end

endmodule

