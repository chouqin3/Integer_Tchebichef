function [dct_size11 Bitration]=dct_JPEGEncode(I)

% I=imread('..\����ͼƬ\image compress databse\kodim01.png');
% I=imread('lena.bmp');
% I=imread('I:\����ͼƬ\���ױ��Ǵ�ѧ�����\chart_and_stuffed_toy_RGB.bmp');
% I=rgb2gray(I);
[row,column]=size(I);%ͼ��Ĵ�С
blockCount=row*column/64;%8*8�ֿ���


%dct2�任����ImageSub�ֳ�8*8���ؿ飬�ֱ����dct2�任���ñ任ϵ������Coef
% I=blkproc(I,[8 8],'dct2');
I=dct_transform(I,row,column,8);
%JPEG������������
I=round(I);%%�򿿽�������ȡԲ��

%DCϵ����DPCM����
for i=row-7:-8:1
    for j=column-7:-8:1
        if j==1
            if i~=1 %���ǵ�һ��DCϵ��
                I(i,j)=I(i,j)-I(i-8,column-7);
            end
        else
            I(i,j)=I(i,j)-I(i,j-8);
        end
    end
end

%DCϵ����ɨ�裬�������λ��
DCCounts=zeros(16,1);
DCs=zeros(blockCount,2);%�洢ɨ���DCϵ��
n=0;
pixel=0;%���浱ǰɨ�������ֵ
for i=1:8:row
    for j=1:8:column
        n=n+1;
        if I(i,j)==0
            bitNumber=0;
        else
            bitNumber=floor(log2(abs(I(i,j))))+1;%��Z(k)�Ķ�����λ��
        end
        if bitNumber>15
            disp('error');
        end
        DCs(n,:)=[bitNumber I(i,j)];
        DCCounts(bitNumber+1)=DCCounts(bitNumber+1)+1;%%%%%%%ʲô��˼������������
    end
end

%DCϵ���ķ�ʽhuffman����
existSs=[];%����DCϵ����λ����Ƶ����Ϊ���
SCounts=[];%������Ӧ��Ƶ��
S2T=zeros(16,1);%���п��ܵ�DCϵ��λ����existSs����Ԫ��(��DC���ڵ�)��ӳ���ϵ��DCϵ�����15λ
n=0;
sum=0;
for i=1:16
    if DCCounts(i)>0
        n=n+1;
        existSs=[existSs i-1];
        SCounts=[SCounts DCCounts(i)];
        sum=sum+DCCounts(i);
        S2T(i)=n;
    end
end
DCTree=huffman(existSs,SCounts,sum);

%ACϵ�����γ����룬���Ա��뵥ԪƵ��ͳ��
ACCounts=zeros(256,1);
ACs{row/8,column/8}=[];%��ϸ������洢ÿ����ĵ�AC�γ�����
n=0;
for i=1:8:row
    for j=1:8:column
        n=n+1;
        Z=block2zigzag(I(i:(i+7),j:(j+7)));
        %�ҵ����һ����������λ��
        lastNonzero=0;
        for k=64:-1:1
            if Z(k)~=0
                lastNonzero=k;
                break;
            end
        end
        zeroCount=0;
        AC=[];
        %�γ�����
        if lastNonzero==0 || lastNonzero==1
            AC=[0 0 0];%EOB
            ACCounts(1)=ACCounts(1)+1;
        else
            for k=2:lastNonzero
                if (Z(k)==0 && zeroCount<16)
                    zeroCount=zeroCount+1;
                elseif (Z(k)==0 && zeroCount==16);
                    AC=[AC;[15 0 0]];%ZRL
                    ACCounts(15*16+1)=ACCounts(15*16+1)+1;%%%%%%
                    zeroCount=1;
                elseif (Z(k)~=0 && zeroCount==16)
                    bitNumber=floor(log2(abs(Z(k))))+1;%��Z(k)�Ķ�����λ��
                    AC=[AC;[15 0 0];[0 bitNumber Z(k)]];
                    ACCounts(15*16+1)=ACCounts(15*16+1)+1;
                    ACCounts(bitNumber+1)=ACCounts(bitNumber+1)+1;
                    zeroCount=0;
                else
                    bitNumber=floor(log2(abs(Z(k))))+1;%��Z(k)�Ķ�����λ��
                    AC=[AC;[zeroCount bitNumber Z(k)]];
                    ACCounts(zeroCount*16+bitNumber+1)=ACCounts(zeroCount*16+bitNumber+1)+1;
                    zeroCount=0;
                end
            end
            AC=[AC;[0 0 0]];%EOB
            ACCounts(1)=ACCounts(1)+1;
        end
        ACs{ceil(i/8),ceil(j/8)}=AC;%����AC���뵽ϸ��������
    end
end

%���γ�������ACϵ�����з�ʽhuffman����
%�ҳ�Ƶ����������γ����뵥Ԫ������һ���µ�����
existRSs=[];%����Ƶ����Ϊ����γ����뵥Ԫ
RSCounts=[];%�����γ����뵥Ԫ��Ƶ��
RS2T=zeros(256,1);%����256�����ܵ��γ����뵥Ԫ��existRSs����Ԫ��(��AC���ڵ�)��ӳ���ϵ,0��ʾ��Ԫ����֮��Ӧ��ACϵ��λ�����Ϊ15λ
n=0;
sum=0;
for i=1:256
    if ACCounts(i)>0
        n=n+1;
        existRSs(n)=i-1;
        RSCounts(n)=ACCounts(i);
        sum=sum+ACCounts(i);
        RS2T(i)=n;
    end
end
ACTree=huffman(existRSs,RSCounts,sum);

%���б���
%��ͷ������
Header=dec2bin(row,16);%ͼ�����ص�����(2���ֽ�)
Header=[Header,dec2bin(column,16)];%ͼ�����ص�����(2���ֽ�)
%Header=[Header,'00000000','00000000','00000000','00000000'];%Ԥ��ͼ���ļ���λ��
%��DCϵ����huffman��洢
[SSSSInOrder codeLengths codeCounts]=sortTreeCode(DCTree,(length(DCTree)+1)/2);%���DCϵ��SSSS�ı���ķ�ʽ��������
%SSSS�ı���(��λ������)������1���ֽڴ��뵽huffman���ͷ��
n=1;
for i=1:16 %SSSS�ı���λ��Ϊ1��16,ÿ��λ���ı���ĸ������16��
    if n<=length(codeLengths)&&codeLengths(n)==i
        Header=[Header,dec2bin(codeCounts(n),8)];
        n=n+1;
    else
        Header=[Header,'00000000'];%
    end
end
%��ÿ����������ʵ��ֵ����huffman��
for i=1:length(SSSSInOrder)
    Header=[Header,dec2bin(SSSSInOrder{i}.value,8)];
end

%��ACϵ����huffman��洢
%�����������DCϵ��huffman��洢�ı���
codesInOrder=[];
codeLengths=[];
codeCounts=[];
[RRRRSSSSInOrder codeLengths codeCounts]=sortTreeCode(ACTree,(length(ACTree)+1)/2);%���ACϵ��RRRRSSSS�ı���ķ�ʽ��������
%ÿ��RRRRSSSS�ı���(��λ������)������2���ֽڴ��뵽huffman���ͷ��
n=1;
for i=1:256 %RRRRSSSS�ı���λ��Ϊ1��256,ÿ��λ���ı���ĸ������256��
    if n<=length(codeLengths)&&codeLengths(n)==i
        Header=[Header,dec2bin(codeCounts(n),8)];
        n=n+1;
    else
        Header=[Header,'00000000'];
    end
end
% ��ÿ����������ʵ��ֵ����huffman��
for i=1:length(RRRRSSSSInOrder)
    Header=[Header,dec2bin(RRRRSSSSInOrder{i}.value,8)];
end

%��ÿһ����б���
Body='';%���п�ı���
Blocks{row/8,column/8}=[];%ÿ����ı���
n=0;
for i=1:row/8
    for j=1:column/8
        n=n+1;
        %��DCϵ�����б���
        code=DCTree(S2T(DCs(n,1)+1)).code;%ȡ��SSSS�ı���
        if DCs(n,2)>0
            Blocks{i,j}=[Blocks{i,j},code,dec2bin(DCs(n,2))];
        elseif DCs(n,2)<0
            Blocks{i,j}=[Blocks{i,j},code,dec2bin(bitcmp(-DCs(n,2),DCs(n,1)),DCs(n,1))];
        else %DC��ֵΪ��,����Ҫ��DC��ֵ(0)���б���
            Blocks{i,j}=[Blocks{i,j},code];
        end
        %��ACϵ�����б���
        AC=ACs{i,j};
        for k=1:length(AC(:,1))
            code=ACTree(RS2T(AC(k,1)*16+AC(k,2)+1)).code;%ȡ��RRRRSSSS�ı���
            if AC(k,3)>0
                Blocks{i,j}=[Blocks{i,j},code,dec2bin(AC(k,3))];
            elseif AC(k,3)<0
                Blocks{i,j}=[Blocks{i,j},code,dec2bin(bitcmp(-AC(k,3),AC(k,2)),AC(k,2))];
            else %AC(k,3)=0 ����ΪZRL����EOB,����Ҫ��ACֵ���б���
                Blocks{i,j}=[Blocks{i,j},code];
            end
        end
        Body=[Body,Blocks{i,j}];
    end
end
FileCode=[Header,Body];
dct_size11=numel(FileCode)-32;
dct_compressed_ration=8*row*column/dct_size11
Bitration=dct_size11/(row*column);
% fid=fopen('c','wb');
% fwrite(fid,FileCode);
% fclose(fid);
%�ϲ��ļ�ͷ���ļ���
%FileCode(33:64)=dec2bin(length(FileCode),32);%�����ļ�λ��