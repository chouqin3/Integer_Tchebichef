function [y u v ] = clvs_rgb2yuv(rgb)
%RGB2YUV Summary of this function goes here
%   Detailed explanation goes here

r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);
y = 0.299*r + 0.587*g + 0.1721*b;
u = -0.3374*r - 0.6626*g + 1*b;
v = 1*r - 0.8374*g - 0.1626*b;
yuv = cat(3,y,u,v);

end