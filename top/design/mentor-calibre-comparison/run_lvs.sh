envsubst < calibre_lvs.rule.template > calibre_lvs.rule

v2lvs -i \
      -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi \
      -lsp source.added -s source.added \
      -v inputs/PE_up.lvs.v -o PE_up.sp \
      -log v2lvs_PE_up.log

v2lvs -i \
      -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi \
      -lsp source.added -s source.added \
      -v inputs/PE_down.lvs.v -o PE_down.sp \
      -log v2lvs_PE_down.log

v2lvs -i \
      -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi \
      -lsp source.added -s source.added \
      -v inputs/PE_left.lvs.v -o PE_left.sp \
      -log v2lvs_PE_left.log

v2lvs -i \
      -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi \
      -lsp source.added -s source.added \
      -v inputs/PE_right.lvs.v -o PE_right.sp \
      -log v2lvs_PE_right.log

v2lvs -i \
      -lsp inputs/adk/stdcells.spi -s inputs/adk/stdcells.spi \
      -lsp source.added -s source.added \
      -v inputs/design.lvs.v -o design.lvs.v.spice \
      -log v2lvs_design.log

calibre -lvs -hier ./calibre_lvs.rule -hcell hcells -automatch
