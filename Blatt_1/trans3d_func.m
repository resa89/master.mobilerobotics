function [ T ] = trans3d_func( x,y,z,alpha,betta,gamma)
    R=rotx(alpha,'deg');
    R=R*roty(betta,'deg');
    R=R*rotz(gamma,'deg');
    
    T=transl(x,y,z);
    T(1:3,1:3)=R;
    
end