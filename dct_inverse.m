function R=dct_inverse( img,row,col,block_size) 
s0=[-1.1648 2.8234 -0.5375 0.6058 -1.2228 0.3805 -0.0288 2];
s1=[0 -1.1129 0.0570 -0.4712 0.1029 0.0156 -0.4486 -0.4619];
s2=[-0.0685 0 0.2708 -0.2708 -0.2235 0.2568 -0.3205 0.3841];
s3=[-0.0364 -1.7104 0 -1.0000 0.3066 0.6671 -0.5953 0.2039];
s4=[0.7957 0.9664 0.4439 0 0.6173 -0.1422 1.0378 -0.1700];
s5=[0.4591 0.4108 -0.2073 -1.0824 0 0.7071 0.8873 -0.2517];
s6=[-0.6573 0.5810 -0.2931 -0.5307 -0.8730 0 -0.1594 -0.3560];
s7=[1.0024 -0.7180 -0.0928 -0.0318 0.4170 1.1665 0 0.4904];
s8=[1.1020 -2.0306 -0.3881 0.6561 1.2405 1.6577 -1.1914 0];
pl=[0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 1 0;
    0 0 0 0 1 0 0 0;
    0 0 1 0 0 0 0 0;
    0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 0 1;
    1 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0];
pr=[0 0 1 0 0 0 0 0;
    0 0 0 0 0 0 0 1;
    0 0 0 0 1 0 0 0;
    0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 1 0;
    1 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0;
    0 0 0 0 0 1 0 0];
e = eye(8);
iss8=e-e(:,8)*s8;
iss7=e-e(:,7)*s7;
iss6=e-e(:,6)*s6;
iss5=e-e(:,5)*s5;
iss4=e-e(:,4)*s4;
iss3=e-e(:,3)*s3;
iss2=e-e(:,2)*s2;
iss1=e-e(:,1)*s1;
iss0=e-e(:,8)*s0;
 p=pl*pr;
for i=1:block_size:row
    for j=1:block_size:col
         k=img(i:i+block_size-1,j:j+block_size-1);
         
%          k =p'*k;
%           k(8,:) = round(iss8(8,:)*k);
%         k(7,:) = round(iss7(7,:)*k);
%         k(6,:) = round(iss6(6,:)*k);
%         k(5,:) = round(iss5(5,:)*k);
%         k(4,:) = round(iss4(4,:)*k);
%         k(3,:) = round(iss3(3,:)*k);
%         k(2,:) = round(iss2(2,:)*k);
%         k(1,:) = round(iss1(1,:)*k);
%         k(8,:) = round(iss0(8,:)*k);
%         xx=round(k);
%         xx = p*xx';
%         xx(8,:) = round(iss8(8,:)*xx);
%         xx(7,:) = round(iss7(7,:)*xx);
%         xx(6,:) = round(iss6(6,:)*xx);
%         xx(5,:) = round(iss5(5,:)*xx);
%         xx(4,:) = round(iss4(4,:)*xx);
%         xx(3,:) = round(iss3(3,:)*xx);
%         xx(2,:) = round(iss2(2,:)*xx);
%         xx(1,:) = round(iss1(1,:)*xx);
%         xx(8,:) = round(iss0(8,:)*xx);
%         xx=p*xx;
        
        xxx = round(iss0*round(iss1*round(iss2*round(iss3*round(iss4*round(iss5*round(iss6*round(iss7*round(iss8*p'*k)))))))));
        xx = round(iss0*round(iss1*round(iss2*round(iss3*round(iss4*round(iss5*round(iss6*round(iss7*round(iss8*p'*xxx')))))))));
        IIimg=xx;
        R(i:i+block_size-1,j:j+block_size-1)=IIimg;
    end
end






