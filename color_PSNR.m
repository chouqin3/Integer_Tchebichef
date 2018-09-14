function PSNR = color_PSNR(A,B)

%计算输入两图像A,B的峰值信噪比PSNR(dB)

A = double(A);      %%图像数据类型转换
B = double(B);
[Row,Col] = size(A);%%输入图像的大小
% [Row,Col] = size(B);
MSE = sum(sum(sum((A(:,:,:) - B(:,:,:)).^2)) )/ (3*Row * Col);   %%均方误差MSE
%MSE1 = sum(sum((A(:,:,1) - B(:,:,1)).^2)) / (Row * Col);   %%均方误差MSE
%MSE2 = sum(sum((A(:,:,2) - B(:,:,2)).^2)) / (Row * Col);   %%均方误差MSE
%MSE3 = sum(sum((A(:,:,3) - B(:,:,3)).^2)) / (Row * Col);   %%均方误差MSE
%MSE=(MSE1+MSE2+MSE3)/3;
PSNR = 10 * log10(255^2/MSE);               %%峰值信噪比PSNR(dB)