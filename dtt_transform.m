function I5=dtt_transform(img,row,col,block_size)
s0=[-0.8516   -1.4771   -1.9555   -1.2229    2.6259    0.2772    5.2787   0     ];
s1=[    0    0.8749    0.8247     0.2747   -1.8039   -0.3812   -2.7737    0.5401];
s2=[-0.0639     0       1.3260    0.7290   -1.4312   -0.5746   -2.7592    0.4653];
s3=[0.0937   -0.3165    0        -0.0330   -0.7168    0.3984   -1.1899    0.1473];
s4=[0.4161   -0.3273    0.7480   0          0.2929   -0.6221   -1.2305    0.1523];
s5=[0.5027    0.4629   -0.1874    0.3886        0    0.8798    1.7402   -0.2154];
s6=[0.1659    0.9679   -0.0743    0.5311   -0.6921    0        0.4690    0.1330];
s7=[0.0315   -1.1460   -0.9335   -0.0854    0.2858    1.7895    0        -0.4922];
s8=[0.2207   -2.9537   -2.5221   -1.2378    1.2992    4.4198   -2.2747   -2     ];
e = eye(8);
S8=e+e(:,8)*s8;
S7=e+e(:,7)*s7;
S6=e+e(:,6)*s6;
S5=e+e(:,5)*s5;
S4=e+e(:,4)*s4;
S3=e+e(:,3)*s3;
S2=e+e(:,2)*s2;
S1=e+e(:,1)*s1;
S0=e+e(:,8)*s0;

p =[0 0 0 0 1 0 0 0;
    0 0 0 0 0 1 0 0;
    1 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0;
    0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 0 1;
    0 0 1 0 0 0 0 0;
    0 0 0 0 0 0 1 0];

for i=1:block_size:row
    for j=1:block_size:col
        x=img(i:i+block_size-1,j:j+block_size-1);
%         x(8,:) = round(S0(8,:)*x);
%         x(1,:) = round(S1(1,:)*x);
%         x(2,:) = round(S2(2,:)*x);
%         x(3,:) = round(S3(3,:)*x);
%         x(4,:) = round(S4(4,:)*x);
%         x(5,:) = round(S5(5,:)*x);
%         x(6,:) = round(S6(6,:)*x);
%         x(7,:) = round(S7(7,:)*x);
%         x(8,:) = round(S8(8,:)*x);
%         yy = p*round(x);   
%         yy = yy';
%         yy(8,:) = round(S0(8,:)*yy);
%         yy(1,:) = round(S1(1,:)*yy);
%         yy(2,:) = round(S2(2,:)*yy);
%         yy(3,:) = round(S3(3,:)*yy);
%         yy(4,:) = round(S4(4,:)*yy);
%         yy(5,:) = round(S5(5,:)*yy);
%         yy(6,:) = round(S6(6,:)*yy);
%         yy(7,:) = round(S7(7,:)*yy);
%         yy(8,:) = round(S8(8,:)*yy);
%         yy=p*round(yy);
%         k=yy;
        
       yy = p*round(S8*round(S7*round(S6*round(S5*round(S4*round(S3*round(S2*round(S1*round(S0*x)))))))));      
       k = p*round(S8*round(S7*round(S6*round(S5*round(S4*round(S3*round(S2*round(S1*round(S0*yy')))))))));
       I5(i:i+block_size-1,j:j+block_size-1)=k;
    end
end
end



