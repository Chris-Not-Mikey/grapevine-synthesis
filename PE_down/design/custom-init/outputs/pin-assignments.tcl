
set pins_bottom {\
  {clk} \
  {rst} \
  {rx_pr} \
  {rx_pd[0]} \
  {rx_pd[1]} \
  {rx_pa} \
  {tx_pd[0]} \
  {tx_pd[1]} \
  {tx_pd[2]} \
  {tx_pd[3]} \
  {tx_pd[4]} \
  {tx_pd[5]} \
  {tx_pd[6]} \
  {tx_pd[7]} \
  {tx_pd[8]} \
  {tx_pd[9]} \
  {tx_pd[10]} \
  {tx_pd[11]} \
  {tx_pd[12]} \
  {tx_pd[13]} \
  {tx_pd[14]} \
  {tx_pd[15]} \
  {tx_pd[16]} \
  {tx_pd[17]} \
  {tx_pd[18]} \
  {tx_pd[19]} \
  {tx_pd[20]} \
  {tx_pd[21]} \
  {tx_pd[22]} \
  {tx_pd[23]} \
  {tx_pd[24]} \
  {tx_pd[25]} \
  {tx_pd[26]} \
  {tx_pd[27]} \
  {tx_pd[28]} \
  {tx_pd[29]} \
  {tx_pd[30]} \
  {tx_pd[31]} \
  {tx_pa}\
}

set pins_top {\
  {cfg_dat[0]} \
  {cfg_dat[1]} \
  {cfg_dat[2]} \
  {cfg_dat[3]} \
  {cfg_dat[4]} \
  {cfg_dat[5]} \
  {cfg_dat[6]} \
  {cfg_dat[7]} \
  {cfg_dat[8]} \
  {cfg_dat[9]} \
  {cfg_dat[10]} \
  {cfg_dat[11]} \
  {cfg_dat[12]} \
  {cfg_dat[13]} \
  {cfg_dat[14]} \
  {cfg_dat[15]} \
  {cfg_adr[0]} \
  {cfg_adr[1]} \
  {cfg_adr[2]} \
  {cfg_adr[3]} \
  {cfg_adr[4]} \
  {cfg_adr[5]} \
  {cfg_adr[6]} \
  {cfg_adr[7]} \
  {cfg_adr[8]} \
  {cfg_adr[9]} \
  {cfg_adr[10]} \
  {slv_addr[0]} \
  {slv_addr[1]} \
  {slv_addr[2]} \
  {slv_addr[3]} \
  {slv_addr[4]} \
  {slv_addr[5]} \
  {slv_addr[6]} \
  {slv_addr[7]} \
  {slv_addr[8]} \
  {slv_addr[9]} \
  {slv_addr[10]} \
}

set pins_left {\
  {rx_c0r} \
  {rx_c0d[0]} \
  {rx_c0d[1]} \
  {rx_c0a} \
  {tx_c0d[0]} \
  {tx_c0d[1]} \
  {tx_c0d[2]} \
  {tx_c0d[3]} \
  {tx_c0d[4]} \
  {tx_c0d[5]} \
  {tx_c0d[6]} \
  {tx_c0d[7]} \
  {tx_c0d[8]} \
  {tx_c0d[9]} \
  {tx_c0d[10]} \
  {tx_c0d[11]} \
  {tx_c0d[12]} \
  {tx_c0d[13]} \
  {tx_c0d[14]} \
  {tx_c0d[15]} \
  {tx_c0d[16]} \
  {tx_c0d[17]} \
  {tx_c0d[18]} \
  {tx_c0d[19]} \
  {tx_c0d[20]} \
  {tx_c0d[21]} \
  {tx_c0d[22]} \
  {tx_c0d[23]} \
  {tx_c0d[24]} \
  {tx_c0d[25]} \
  {tx_c0d[26]} \
  {tx_c0d[27]} \
  {tx_c0d[28]} \
  {tx_c0d[29]} \
  {tx_c0d[30]} \
  {tx_c0d[31]} \
  {tx_c0a} \
}

set pins_right {\
  {rx_c1r} \
  {rx_c1d[0]} \
  {rx_c1d[1]} \
  {rx_c1a} \
  {tx_c1d[0]} \
  {tx_c1d[1]} \
  {tx_c1d[2]} \
  {tx_c1d[3]} \
  {tx_c1d[4]} \
  {tx_c1d[5]} \
  {tx_c1d[6]} \
  {tx_c1d[7]} \
  {tx_c1d[8]} \
  {tx_c1d[9]} \
  {tx_c1d[10]} \
  {tx_c1d[11]} \
  {tx_c1d[12]} \
  {tx_c1d[13]} \
  {tx_c1d[14]} \
  {tx_c1d[15]} \
  {tx_c1d[16]} \
  {tx_c1d[17]} \
  {tx_c1d[18]} \
  {tx_c1d[19]} \
  {tx_c1d[20]} \
  {tx_c1d[21]} \
  {tx_c1d[22]} \
  {tx_c1d[23]} \
  {tx_c1d[24]} \
  {tx_c1d[25]} \
  {tx_c1d[26]} \
  {tx_c1d[27]} \
  {tx_c1d[28]} \
  {tx_c1d[29]} \
  {tx_c1d[30]} \
  {tx_c1d[31]} \
  {tx_c1a} \
}



editPin -layer met2 -pin $pins_top    -side TOP    -spreadType SIDE
editPin -layer met1 -pin $pins_right  -side RIGHT  -spreadType SIDE
editPin -layer met2 -pin $pins_bottom -side BOTTOM -spreadType SIDE
editPin -layer met1 -pin $pins_left   -side LEFT   -spreadType SIDE
