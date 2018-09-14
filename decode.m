function I=decode(FileCode)
cursor=1;
row=bin2dec(FileCode(cursor:cursor+15));%行数
cursor=cursor+16;
column=bin2dec(FileCode(cursor:cursor+15));%列数
cursor=cursor+16;
YLength=bin2dec(FileCode(cursor:cursor+31));%灰度部分位数
cursor=cursor+32;
BrightnessQuantizationTable=ones(8,8);
ChromaQuantizationTable=ones(8,8);
Y=JPEGDecode(FileCode(cursor:cursor+YLength-1),BrightnessQuantizationTable);
[rowY,columnY]=size(Y);%图像的大小
I=Y;%换回真彩色空间
I(row+1:rowY,:)=[];%去掉扩展的行
I(column+1:columnY,:)=[];%去掉扩展的列
end