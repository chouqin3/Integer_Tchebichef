clc;
close all;
clear;


p1=dir('E:\SHINE\SHINE\����ͼƬ\Testing images\CT new\CT\bmp��ʽ\*.pgm');
addpath E:\SHINE\SHINE\����ͼƬ\g256_001
imshow('sf.pgm')
[r1 c1]=size(p1);

  for i=1:r1   
    ImgN=p1(i).name;%ͼƬ������  
    ImgN=strcat('E:\SHINE\SHINE\����ͼƬ\Testing images\CT new\CT\bmp��ʽ\',ImgN);%��ȡͼƬ   
    Img=(imread(ImgN));    
    Img=double(Img);
    Img=Img-128;%��ƽƽ��128
    if size(Img,3) == 3  
        Img = rgb2gray(Img);   
    else
        Img = Img;  
    end
    tic
    [dct_size11 dct_bit_ration]=dct_JPEGEncode(Img);
    dct_time=toc;
    tic
    [dtt_size11 dtt_bit_ration]=dtt_JPEGEncode(Img);
    dtt_time=toc;
%     tic
%     [dkt_size11 dkt_compressed_ration]=dkt_JPEGEncode(Img);
%     dkt_time=toc;
    fid=fopen('CT.txt','a');
    fprintf(fid,'%s\n',ImgN);
    fprintf(fid,'%.3f\t%.3f\t\n',dct_time,dtt_time);
    fprintf(fid,'%.3f\t%.3f\t\n',dct_bit_ration,dtt_bit_ration);
  end
fclose(fid);