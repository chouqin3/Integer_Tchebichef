function rgb = clvs_yuv2rgb(yuv)

y = yuv(:,:,1);
u = yuv(:,:,2);
v = yuv(:,:,3);
A = [0.299 0.587 0.1721
    -0.3374  -0.6626 1
    1       -0.8374  -0.1626];
B = inv(A);
r = B(1,1)*y + B(1,2)*u + B(1,3)*v;
g = B(2,1)*y + B(2,2)*u + B(2,3)*v;
b = B(3,1)*y + B(3,2)*u + B(3,3)*v;
rgb = (cat(3,r,g,b));

end