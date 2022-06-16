#=========================================================================
# globalnetconnect.tcl
#=========================================================================
# Author : 
# Date   : 

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

# Connect VNW / VPW if any cells have these pins

# (pohan remove) globalNetConnect vccd1 -type pgpin -pin vccd1 -inst *
# (pohan remove) globalNetConnect vccd1 -type tiehi
# (pohan remove) globalNetConnect vssd1 -type pgpin -pin vssd1 -inst *
# (pohan remove) globalNetConnect vssd1 -type tielo
# (pohan remove) globalNetConnect vccd1 -type pgpin -pin VPP -inst *
# (pohan remove) globalNetConnect vssd1 -type pgpin -pin VBB -inst *

globalNetConnect vccd1    -type pgpin -pin VPWR    -inst * -verbose
globalNetConnect vssd1    -type pgpin -pin VGND    -inst * -verbose
globalNetConnect vssd1    -type pgpin -pin VNB     -inst * -verbose
globalNetConnect vccd1    -type pgpin -pin VPB     -inst * -verbose

# this is for SRAM macro, should turn on when hardening Tile_MemCore
#globalNetConnect vccd1    -type pgpin -pin vdd     -inst * -verbose
#globalNetConnect vssd1    -type pgpin -pin gnd     -inst * -verbose

globalNetConnect vccd1 -type tiehi
globalNetConnect vssd1 -type tielo
