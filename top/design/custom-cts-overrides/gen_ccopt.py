def make_tcl_command(L, name):
    if (L == 0):
        return
    print(f"set pin_name {name}/clk")
    print("set_ccopt_property -pin $pin_name sink_type stop")
    print("set_ccopt_property -pin $pin_name -delay_corner delay_default capacitance_override 0.0102")
    make_tcl_command(L-1, f"{name}l")
    make_tcl_command(L-1, f"{name}r")


make_tcl_command(5, "i_Top/r")
