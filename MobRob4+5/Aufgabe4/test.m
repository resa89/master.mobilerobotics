syms l1x l1y l2x l2y x y theta
h = [sqrt((l1x-x)^2+(l1y-y)^2); sqrt((l2x-x)^2+(l2y-y)^2)]
H = jacobian(h, [x y theta])