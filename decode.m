function I=decode(FileCode)
cursor=1;
row=bin2dec(FileCode(cursor:cursor+15));%����
cursor=cursor+16;
column=bin2dec(FileCode(cursor:cursor+15));%����
cursor=cursor+16;
YLength=bin2dec(FileCode(cursor:cursor+31));%�ҶȲ���λ��
cursor=cursor+32;
BrightnessQuantizationTable=ones(8,8);
ChromaQuantizationTable=ones(8,8);
Y=JPEGDecode(FileCode(cursor:cursor+YLength-1),BrightnessQuantizationTable);
[rowY,columnY]=size(Y);%ͼ��Ĵ�С
I=Y;%�������ɫ�ռ�
I(row+1:rowY,:)=[];%ȥ����չ����
I(column+1:columnY,:)=[];%ȥ����չ����
end