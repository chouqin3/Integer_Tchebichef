function PSNR = color_PSNR(A,B)

%����������ͼ��A,B�ķ�ֵ�����PSNR(dB)

A = double(A);      %%ͼ����������ת��
B = double(B);
[Row,Col] = size(A);%%����ͼ��Ĵ�С
% [Row,Col] = size(B);
MSE = sum(sum(sum((A(:,:,:) - B(:,:,:)).^2)) )/ (3*Row * Col);   %%�������MSE
%MSE1 = sum(sum((A(:,:,1) - B(:,:,1)).^2)) / (Row * Col);   %%�������MSE
%MSE2 = sum(sum((A(:,:,2) - B(:,:,2)).^2)) / (Row * Col);   %%�������MSE
%MSE3 = sum(sum((A(:,:,3) - B(:,:,3)).^2)) / (Row * Col);   %%�������MSE
%MSE=(MSE1+MSE2+MSE3)/3;
PSNR = 10 * log10(255^2/MSE);               %%��ֵ�����PSNR(dB)