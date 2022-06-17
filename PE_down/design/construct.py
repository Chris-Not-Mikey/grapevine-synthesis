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
        'design_name'    : 'PE_down',
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
    dc              = Step('synopsys-dc-synthesis', default=True)
    custom_flowstep = Step(this_dir + '/custom-flowstep')
    iflow           = Step('cadence-innovus-flowsetup', default=True)
    custom_init     = Step(this_dir + '/custom-init')
    init            = Step('cadence-innovus-init', default=True)
    custom_power    = Step(this_dir + '/custom-power')
    power           = Step('cadence-innovus-power', default=True)
    place           = Step('cadence-innovus-place', default=True)
    cts             = Step('cadence-innovus-cts', default=True)
    postcts_hold    = Step('cadence-innovus-postcts_hold', default=True)
    route           = Step('cadence-innovus-route', default=True)
    postroute       = Step('cadence-innovus-postroute', default=True)
    signoff         = Step(this_dir + '/cadence-innovus-signoff')
    genlibdb        = Step('cadence-genus-genlib', default=True)        # Stolen from Charles
    lib2db          = Step(this_dir + '/convert-lib2db')                # Stolen from Charles
    gdsmerge        = Step('mentor-calibre-gdsmerge', default=True)
    magic_drc       = Step(this_dir + '/open-magic-drc')

    iflow.extend_inputs(custom_flowstep.all_outputs())
    init.extend_inputs(custom_init.all_outputs())
    power.extend_inputs(custom_power.all_outputs())

    g.add_step(info)
    g.add_step(rtl)
    g.add_step(constraints)
    g.add_step(dc)
    g.add_step(custom_flowstep)
    g.add_step(iflow)
    g.add_step(custom_init)
    g.add_step(init)
    g.add_step(custom_power)
    g.add_step(power)
    g.add_step(place)
    g.add_step(cts)
    g.add_step(postcts_hold)
    g.add_step(route)
    g.add_step(postroute)
    g.add_step(signoff)
    g.add_step(genlibdb)
    g.add_step(lib2db)
    g.add_step(gdsmerge)
    g.add_step(magic_drc)


    g.connect_by_name(adk,              dc)
    g.connect_by_name(constraints,      dc)
    g.connect_by_name(rtl,              dc)

    g.connect_by_name(adk,              iflow)
    g.connect_by_name(custom_flowstep,  iflow)
    g.connect_by_name(dc,               iflow)

    g.connect_by_name(adk,              init)
    g.connect_by_name(dc,               init)
    g.connect_by_name(iflow,            init)
    g.connect_by_name(custom_init,      init)

    g.connect_by_name(adk,              power)
    g.connect_by_name(dc,               power)
    g.connect_by_name(iflow,            power)
    g.connect_by_name(init,             power)
    g.connect_by_name(custom_power,     power)

    g.connect_by_name(adk,              place)
    g.connect_by_name(dc,               place)
    g.connect_by_name(iflow,            place)
    g.connect_by_name(power,            place)

    g.connect_by_name(adk,              cts)
    g.connect_by_name(dc,               cts)
    g.connect_by_name(iflow,            cts)
    g.connect_by_name(place,            cts)

    g.connect_by_name(adk,              postcts_hold)
    g.connect_by_name(iflow,            postcts_hold)
    g.connect_by_name(cts,              postcts_hold)

    g.connect_by_name(adk,              route)
    g.connect_by_name(iflow,            route)
    g.connect_by_name(postcts_hold,     route)

    g.connect_by_name(adk,              postroute)
    g.connect_by_name(iflow,            postroute)
    g.connect_by_name(route,            postroute)

    g.connect_by_name(adk,              signoff)
    g.connect_by_name(iflow,            signoff)
    g.connect_by_name(postroute,        signoff)

    g.connect_by_name(adk,              genlibdb)
    g.connect_by_name(signoff,          genlibdb)

    g.connect_by_name(genlibdb,         lib2db)

    g.connect_by_name(adk,              gdsmerge)
    g.connect_by_name(signoff,          gdsmerge)

    g.connect_by_name(adk,              magic_drc)
    g.connect_by_name(gdsmerge,         magic_drc)

    g.update_params(parameters)

    return g

if __name__ == '__main__':
  g = construct()
  g.plot()



