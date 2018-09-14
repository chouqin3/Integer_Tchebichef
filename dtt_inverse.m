function R=dtt_inverse(I5,row,col,block_size) 

s0=[-0.8516   -1.4771   -1.9555   -1.2229    2.6259    0.2772    5.2787   0     ];
s1=[    0    0.8749    0.8247     0.2747   -1.8039   -0.3812   -2.7737    0.5401];
s2=[-0.0639     0       1.3260    0.7290   -1.4312   -0.5746   -2.7592    0.4653];
s3=[0.0937   -0.3165    0        -0.0330   -0.7168    0.3984   -1.1899    0.1473];
s4=[0.4161   -0.3273    0.7480   0          0.2929   -0.6221   -1.2305    0.1523];
s5=[0.5027    0.4629   -0.1874    0.3886        0    0.8798    1.7402   -0.2154];
s6=[0.1659    0.9679   -0.0743    0.5311   -0.6921    0        0.4690    0.1330];
s7=[0.0315   -1.1460   -0.9335   -0.0854    0.2858    1.7895    0        -0.4922];
s8=[0.2207   -2.9537   -2.5221   -1.2378    1.2992    4.4198   -2.2747   -2     ];

p =[0 0 0 0 1 0 0 0;
    0 0 0 0 0 1 0 0;
    1 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0;
    0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 0 1;
    0 0 1 0 0 0 0 0;
    0 0 0 0 0 0 1 0];


e = eye(8);
iS8=e+e(:,8)*s8;
iS7=e-e(:,7)*s7;
iS6=e-e(:,6)*s6;
iS5=e-e(:,5)*s5;
iS4=e-e(:,4)*s4;
iS3=e-e(:,3)*s3;
iS2=e-e(:,2)*s2;
iS1=e-e(:,1)*s1;
iS0=e-e(:,8)*s0;
for i=1:block_size:row
    for j=1:block_size:col
        k=I5(i:i+block_size-1,j:j+block_size-1);
        
%         k=p'*k;
%         k(8,:) = round(iS8(8,:)*k);
%         k(7,:) = round(iS7(7,:)*k);
%         k(6,:) = round(iS6(6,:)*k);
%         k(5,:) = round(iS5(5,:)*k);
%         k(4,:) = round(iS4(4,:)*k);
%         k(3,:) = round(iS3(3,:)*k);
%         k(2,:) = round(iS2(2,:)*k);
%         k(1,:) = round(iS1(1,:)*k);
%         k(8,:) = round(iS0(8,:)*k);
%         xx=k;
%         xx = xx';
%         xx = p'*xx;
%         xx(8,:) = round(iS8(8,:)*xx);
%         xx(7,:) = round(iS7(7,:)*xx);
%         xx(6,:) = round(iS6(6,:)*xx);
%         xx(5,:) = round(iS5(5,:)*xx);
%         xx(4,:) = round(iS4(4,:)*xx);
%         xx(3,:) = round(iS3(3,:)*xx);
%         xx(2,:) = round(iS2(2,:)*xx);
%         xx(1,:) = round(iS1(1,:)*xx);
%         xx(8,:) = round(iS0(8,:)*xx);
%         yy=xx;

        xx = round(iS0*round(iS1*round(iS2*round(iS3*round(iS4*round(iS5*round(iS6*round(iS7*round(iS8*p'*k)))))))));
        yy = round(iS0*round(iS1*round(iS2*round(iS3*round(iS4*round(iS5*round(iS6*round(iS7*round(iS8*p'*xx')))))))));
        IIimg=yy;
        R(i:i+block_size-1,j:j+block_size-1)=IIimg;
    end
end






