clc;
close all;
clear;


p1=dir('E:\SHINE\SHINE\经典图片\Testing images\Anatomic\Man & Femal\新建文件夹\*.png');
% % addpath E:\SHINE\SHINE\经典图片\g256_007
% % imshow('sf.pgm')
[r1 c1]=size(p1);

for i=1: r1
    ImgN=p1(i).name;%图片的名字
    ImgN=strcat('E:\SHINE\SHINE\经典图片\Testing images\Anatomic\Man & Femal\新建文件夹\',ImgN);%读取图片
    Img=(imread(ImgN));
    Img=double(Img);
    Img=Img-128;%
    [Y U V] = clvs_rgb2yuv(Img);
    tic
    [dct_Y_size11 dct_Y_bit_ration]=dct_JPEGEncode(Y);
    [dct_U_size11 dct_U_bit_ration]=dct_JPEGEncode(U);
    [dct_V_size11 dct_V_bit_ration]=dct_JPEGEncode(V);
    dct_bit_ration = (dct_Y_bit_ration + dct_U_bit_ration + dct_V_bit_ration) / 3;
    dct_time=toc;
    tic
    [dtt_Y_size11 dtt_Y_bit_ration]=dtt_JPEGEncode(Y);
    [dtt_U_size11 dtt_U_bit_ration]=dtt_JPEGEncode(U);
    [dtt_V_size11 dtt_V_bit_ration]=dtt_JPEGEncode(V);
    dtt_bit_ration = (dtt_Y_bit_ration + dtt_U_bit_ration + dtt_V_bit_ration) / 3;
    dtt_time=toc;
    %     tic
    %     [dkt_size11 dkt_compressed_ration]=dkt_JPEGEncode(Img);
    %     dkt_time=toc;
    fid=fopen('Man & Femal.txt','a');
    fprintf(fid,'%s\n',ImgN);
    fprintf(fid,'%.3f\t%.3f\t\n',dct_time,dtt_time);
    fprintf(fid,'%.3f\t%.3f\t\n',dct_bit_ration,dtt_bit_ration);
end
fclose(fid);