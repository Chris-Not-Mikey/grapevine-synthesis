#! /usr/bin/env python
#=========================================================================
# construct.py
#=========================================================================
# Adapted from GcdUnit
#
# Author : Leo Liu and Priyanka Dilip
# Date   : May 10, 2022
#

import os
import sys

from mflowgen.components import Graph, Step

def construct():
    g = Graph()

    adk_name = 'skywater-130nm-adk'
    adk_view = 'view-standard'

    parameters = {
        'construct_path' : __file__,
        'design_name'    : 'user_proj_example',
        'clock_period'   : 100,
        'adk'            : adk_name,
        'adk_view'       : adk_view,
        'topographical'  : True
    }

    this_dir = os.path.dirname(os.path.abspath( __file__ ))

    g.set_adk(adk_name)
    adk = g.get_adk_step()

    info            = Step('info', default=True)
    rtl             = Step(this_dir + '/rtl')
    constraints     = Step(this_dir + '/constraints')
    PE              = Step(this_dir + '/PE')
    dc              = Step('synopsys-dc-synthesis', default=True)
    custom_flowstep = Step(this_dir + '/custom-flowstep')
    iflow           = Step('cadence-innovus-flowsetup', default=True)
    custom_init     = Step(this_dir + '/custom-init')
    init            = Step('cadence-innovus-init', default=True)
    power           = Step(this_dir + '/cadence-innovus-power')
    place           = Step('cadence-innovus-place', default=True)
    custom_cts      = Step(this_dir + '/custom-cts-overrides')
    cts             = Step('cadence-innovus-cts', default=True)
    postcts_hold    = Step('cadence-innovus-postcts_hold', default=True)
    route           = Step('cadence-innovus-route', default=True)
    postroute       = Step('cadence-innovus-postroute', default=True)
    signoff         = Step(this_dir + '/cadence-innovus-signoff')
    gdsmerge        = Step('mentor-calibre-gdsmerge', default=True)

    pt_signoff      = Step('synopsys-pt-timing-signoff', default=True)
    magic_drc       = Step(this_dir + '/open-magic-drc')
    magic_antenna   = Step(this_dir + '/open-magic-antenna')
    magic_gds2spice = Step(this_dir + '/open-magic-gds2spice')
    calibre_lvs     = Step(this_dir + '/mentor-calibre-comparison')


    dc.extend_inputs(['PE_up.db', 'PE_up.lef'])
    dc.extend_inputs(['PE_down.db', 'PE_down.lef'])
    dc.extend_inputs(['PE_left.db', 'PE_left.lef'])
    dc.extend_inputs(['PE_right.db', 'PE_right.lef'])
    for step in [iflow, init, power, place, cts, postcts_hold, route, postroute, signoff]:
        step.extend_inputs(['PE_up.lib', 'PE_up.lef'])
        step.extend_inputs(['PE_down.lib', 'PE_down.lef'])
        step.extend_inputs(['PE_left.lib', 'PE_left.lef'])
        step.extend_inputs(['PE_right.lib', 'PE_right.lef'])
    signoff.extend_inputs(['PE_up.gds', 'PE_down.gds', 'PE_left.gds', 'PE_right.gds'])
    gdsmerge.extend_inputs(['PE_up.gds', 'PE_down.gds', 'PE_left.gds', 'PE_right.gds'])

    iflow.extend_inputs(custom_flowstep.all_outputs())
    init.extend_inputs(custom_init.all_outputs())
    cts.extend_inputs(custom_cts.all_outputs())
    cts.get_param('order').insert(0, "cts-overrides.tcl")

    pt_signoff.extend_inputs(['PE_up.db', 'PE_down.db', 'PE_left.db', 'PE_right.db'])

    g.add_step(info)
    g.add_step(rtl)
    g.add_step(constraints)
    g.add_step(PE)
    g.add_step(dc)
    g.add_step(custom_flowstep)
    g.add_step(iflow)
    g.add_step(custom_init)
    g.add_step(init)
    g.add_step(power)
    g.add_step(place)
    g.add_step(custom_cts)
    g.add_step(cts)
    g.add_step(postcts_hold)
    g.add_step(route)
    g.add_step(postroute)
    g.add_step(signoff)
    g.add_step(gdsmerge)
    g.add_step(pt_signoff)
    g.add_step(magic_drc)
    g.add_step(magic_antenna)
    g.add_step(magic_gds2spice)
    g.add_step(calibre_lvs)

    g.connect_by_name(adk,              dc)
    g.connect_by_name(constraints,      dc)
    g.connect_by_name(rtl,              dc)
    g.connect_by_name(PE,               dc)

    g.connect_by_name(adk,              iflow)
    g.connect_by_name(custom_flowstep,  iflow)
    g.connect_by_name(dc,               iflow)
    g.connect_by_name(PE,               iflow)

    g.connect_by_name(adk,              init)
    g.connect_by_name(dc,               init)
    g.connect_by_name(iflow,            init)
    g.connect_by_name(custom_init,      init)
    g.connect_by_name(PE,               init)

    g.connect_by_name(adk,              power)
    g.connect_by_name(dc,               power)
    g.connect_by_name(iflow,            power)
    g.connect_by_name(init,             power)
    g.connect_by_name(PE,               power)

    g.connect_by_name(adk,              place)
    g.connect_by_name(dc,               place)
    g.connect_by_name(iflow,            place)
    g.connect_by_name(power,            place)
    g.connect_by_name(PE,               place)

    g.connect_by_name(adk,              cts)
    g.connect_by_name(dc,               cts)
    g.connect_by_name(iflow,            cts)
    g.connect_by_name(place,            cts)
    g.connect_by_name(PE,               cts)
    g.connect_by_name(custom_cts,       cts)

    g.connect_by_name(adk,              postcts_hold)
    g.connect_by_name(iflow,            postcts_hold)
    g.connect_by_name(cts,              postcts_hold)
    g.connect_by_name(PE,               postcts_hold)

    g.connect_by_name(adk,              route)
    g.connect_by_name(iflow,            route)
    g.connect_by_name(postcts_hold,     route)
    g.connect_by_name(PE,               route)

    g.connect_by_name(adk,              postroute)
    g.connect_by_name(iflow,            postroute)
    g.connect_by_name(route,            postroute)
    g.connect_by_name(PE,               postroute)

    g.connect_by_name(adk,              signoff)
    g.connect_by_name(iflow,            signoff)
    g.connect_by_name(postroute,        signoff)
    g.connect_by_name(PE,               signoff)

    g.connect_by_name(adk,              gdsmerge)
    g.connect_by_name(signoff,          gdsmerge)
    g.connect_by_name(PE,               gdsmerge)

    g.connect_by_name(adk,              pt_signoff)
    g.connect_by_name(PE,               pt_signoff)
    g.connect_by_name(signoff,          pt_signoff)
    g.connect(dc.o("design.sdc"),       pt_signoff.i("design.pt.sdc"))

    g.connect_by_name(adk,              magic_drc)
    g.connect_by_name(gdsmerge,         magic_drc)

    g.connect_by_name(adk,              magic_antenna)
    g.connect_by_name(signoff,          magic_antenna)
    g.connect_by_name(PE,               magic_antenna)

    g.connect_by_name(adk,              magic_gds2spice)
    g.connect_by_name(gdsmerge,         magic_gds2spice)
    g.connect_by_name(PE,               magic_gds2spice)

    g.connect_by_name(adk,              calibre_lvs)
    g.connect_by_name(magic_gds2spice,  calibre_lvs)
    g.connect_by_name(signoff,          calibre_lvs)
    g.connect_by_name(PE,               calibre_lvs)

    g.update_params(parameters)

    return g

if __name__ == '__main__':
  g = construct()
  g.plot()



