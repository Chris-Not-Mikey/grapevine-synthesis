W = 2860
H = 3470

def placeInstance(L, name, ws, hs):
    if L == 0:
        return
    w = int((ws[0]+ws[1])/2)
    h = int((hs[0]+hs[1])/2)
    print("placeInstance {} {} {}".format(name, w-75, h-75))
    print("addHaloToBlock 3 3 3 3 {}".format(name))

    if L % 2 == 0:
        placeInstance(L-1, f"{name}l", ws, (hs[0],h))
        placeInstance(L-1, f"{name}r", ws, (h,hs[1]))
    else:
        placeInstance(L-1, f"{name}l", (ws[0],w), hs)
        placeInstance(L-1, f"{name}r", (w,ws[1]), hs)

placeInstance(5, "i_Top/r", (0,W), (0,H))
