function [ mue, C] = combine( mue1, C1, mue2, C2)

mue=(mue1'*C2+mue2'*C1)/(C1+C2);

C=(C1*C2)/(C1+C2);