#=========================================================================
# power-strategy-singlemesh.tcl
#=========================================================================
# This script implements a single power mesh on the upper metal layers.
# Note that M2 is expected to be vertical, and the lower metal layer of
# the power mesh is expected to be horizontal.
#
# Author : Christopher Torng
# Date   : January 20, 2019

#-------------------------------------------------------------------------
# Stdcell power rail preroute
#-------------------------------------------------------------------------
# Generate horizontal stdcell preroutes

sroute -nets {vccd1 vssd1}

#-------------------------------------------------------------------------
# Shorter names from the ADK
#-------------------------------------------------------------------------

set pmesh_bot 4
set pmesh_top 5

#-------------------------------------------------------------------------
# Power ring
#-------------------------------------------------------------------------
# pohan: change "-follow core" to "-follow io"
# (don't add a ring) addRing -nets {vccd1 vssd1} -type core_rings -follow io   \
# (don't add a ring)         -layer [list top  $pmesh_top bottom $pmesh_top  \
# (don't add a ring)                      left $pmesh_bot right  $pmesh_bot] \
# (don't add a ring)         -width $savedvars(p_ring_width)                 \
# (don't add a ring)         -spacing $savedvars(p_ring_spacing)             \
# (don't add a ring)         -offset $savedvars(p_ring_spacing)              \
# (don't add a ring)         -extend_corner {tl tr bl br lt lb rt rb}

#-------------------------------------------------------------------------
# Power mesh bottom settings (vertical)
#-------------------------------------------------------------------------
# - pmesh_bot_str_width            : 8X thickness compared to 3 * M1 width
# - pmesh_bot_str_pitch            : Arbitrarily choosing the stripe pitch
# - pmesh_bot_str_intraset_spacing : Space between vssd1/vccd1, choosing
#                                    constant pitch across vssd1/vccd1 stripes
# - pmesh_bot_str_interset_pitch   : Pitch between same-signal stripes

# Get M1 min width and signal routing pitch as defined in the LEF

set M1_min_width    [dbGet [dbGetLayerByZ [expr $base_layer_idx + 1]].minWidth]
set M1_route_pitchX [dbGet [dbGetLayerByZ [expr $base_layer_idx + 1]].pitchX]

# Bottom stripe params

set pmesh_bot_str_width [expr  8 *  3 * $M1_min_width   ]
set pmesh_bot_str_pitch [expr 4 * 10 * $M1_route_pitchX]

set pmesh_bot_str_intraset_spacing [expr $pmesh_bot_str_pitch - $pmesh_bot_str_width]
set pmesh_bot_str_interset_pitch   [expr 2*$pmesh_bot_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer [expr $base_layer_idx + 1] \
                 -stacked_via_top_layer    $pmesh_top

# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.
#
addStripe -nets {vssd1 vccd1} -layer $pmesh_bot -direction vertical \
    -width $pmesh_bot_str_width                                 \
    -spacing $pmesh_bot_str_intraset_spacing                    \
    -set_to_set_distance $pmesh_bot_str_interset_pitch          \
    -max_same_layer_jog_length $pmesh_bot_str_pitch             \
    -padcore_ring_bottom_layer_limit $pmesh_bot                 \
    -padcore_ring_top_layer_limit $pmesh_top                    \
    -start [expr $pmesh_bot_str_pitch]                          \
    -extend_to design_boundary

#-------------------------------------------------------------------------
# Power mesh top settings (horizontal)
#-------------------------------------------------------------------------
# - pmesh_top_str_width            : 8X thickness compared to 3 * M1 width
# - pmesh_top_str_pitch            : Arbitrarily choosing the stripe pitch
# - pmesh_top_str_intraset_spacing : Space between vssd1/vccd1, choosing
#                                    constant pitch across vssd1/vccd1 stripes
# - pmesh_top_str_interset_pitch   : Pitch between same-signal stripes

set pmesh_top_str_width [expr  8 *  3 * $M1_min_width   ]
set pmesh_top_str_pitch [expr 4 * 10 * $M1_route_pitchX]

set pmesh_top_str_intraset_spacing [expr $pmesh_top_str_pitch - $pmesh_top_str_width]
set pmesh_top_str_interset_pitch   [expr 2*$pmesh_top_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer $pmesh_bot \
                 -stacked_via_top_layer    $pmesh_top

# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.
# 
addStripe -nets {vssd1 vccd1} -layer $pmesh_top -direction horizontal \
    -width $pmesh_top_str_width                                   \
    -spacing $pmesh_top_str_intraset_spacing                      \
    -set_to_set_distance $pmesh_top_str_interset_pitch            \
    -max_same_layer_jog_length $pmesh_top_str_pitch               \
    -padcore_ring_bottom_layer_limit $pmesh_bot                   \
    -padcore_ring_top_layer_limit $pmesh_top                      \
    -start [expr $pmesh_top_str_pitch]                            \
    -extend_to design_boundary


