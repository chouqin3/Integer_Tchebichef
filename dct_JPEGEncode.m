function [dct_size11 Bitration]=dct_JPEGEncode(I)

% I=imread('..\经典图片\image compress databse\kodim01.png');
% I=imread('lena.bmp');
% I=imread('I:\经典图片\哥伦比亚大学多光谱\chart_and_stuffed_toy_RGB.bmp');
% I=rgb2gray(I);
[row,column]=size(I);%图像的大小
blockCount=row*column/64;%8*8分块数


%dct2变换：把ImageSub分成8*8像素块，分别进行dct2变换，得变换系数矩阵Coef
% I=blkproc(I,[8 8],'dct2');
I=dct_transform(I,row,column,8);
%JPEG建议量化矩阵
I=round(I);%%向靠近的整数取圆整

%DC系数的DPCM编码
for i=row-7:-8:1
    for j=column-7:-8:1
        if j==1
            if i~=1 %不是第一个DC系数
                I(i,j)=I(i,j)-I(i-8,column-7);
            end
        else
            I(i,j)=I(i,j)-I(i,j-8);
        end
    end
end

%DC系数的扫描，求出它的位数
DCCounts=zeros(16,1);
DCs=zeros(blockCount,2);%存储扫描的DC系数
n=0;
pixel=0;%保存当前扫描的像素值
for i=1:8:row
    for j=1:8:column
        n=n+1;
        if I(i,j)==0
            bitNumber=0;
        else
            bitNumber=floor(log2(abs(I(i,j))))+1;%求Z(k)的二进制位数
        end
        if bitNumber>15
            disp('error');
        end
        DCs(n,:)=[bitNumber I(i,j)];
        DCCounts(bitNumber+1)=DCCounts(bitNumber+1)+1;%%%%%%%什么意思？？？？？？
    end
end

%DC系数的范式huffman编码
existSs=[];%保存DC系数的位数的频数不为零的
SCounts=[];%保存相应的频数
S2T=zeros(16,1);%所有可能的DC系数位数与existSs数组元素(即DC树节点)的映射关系，DC系数最高15位
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

%AC系数的游长编码，并对编码单元频数统计
ACCounts=zeros(256,1);
ACs{row/8,column/8}=[];%用细胞数组存储每个块的的AC游长编码
n=0;
for i=1:8:row
    for j=1:8:column
        n=n+1;
        Z=block2zigzag(I(i:(i+7),j:(j+7)));
        %找到最后一个非零数的位置
        lastNonzero=0;
        for k=64:-1:1
            if Z(k)~=0
                lastNonzero=k;
                break;
            end
        end
        zeroCount=0;
        AC=[];
        %游长编码
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
                    bitNumber=floor(log2(abs(Z(k))))+1;%求Z(k)的二进制位数
                    AC=[AC;[15 0 0];[0 bitNumber Z(k)]];
                    ACCounts(15*16+1)=ACCounts(15*16+1)+1;
                    ACCounts(bitNumber+1)=ACCounts(bitNumber+1)+1;
                    zeroCount=0;
                else
                    bitNumber=floor(log2(abs(Z(k))))+1;%求Z(k)的二进制位数
                    AC=[AC;[zeroCount bitNumber Z(k)]];
                    ACCounts(zeroCount*16+bitNumber+1)=ACCounts(zeroCount*16+bitNumber+1)+1;
                    zeroCount=0;
                end
            end
            AC=[AC;[0 0 0]];%EOB
            ACCounts(1)=ACCounts(1)+1;
        end
        ACs{ceil(i/8),ceil(j/8)}=AC;%将该AC存入到细胞数组中
    end
end

%对游长编码后的AC系数进行范式huffman编码
%找出频数大于零的游长编码单元，存入一个新的数组
existRSs=[];%保存频数不为零的游长编码单元
RSCounts=[];%保存游长编码单元的频数
RS2T=zeros(256,1);%所有256个可能的游长编码单元与existRSs数组元素(即AC树节点)的映射关系,0表示无元素与之对应，AC系数位数最高为15位
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

%进行编码
%对头部编码
Header=dec2bin(row,16);%图像像素的行数(2个字节)
Header=[Header,dec2bin(column,16)];%图像像素的列数(2个字节)
%Header=[Header,'00000000','00000000','00000000','00000000'];%预留图像文件的位数
%对DC系数的huffman表存储
[SSSSInOrder codeLengths codeCounts]=sortTreeCode(DCTree,(length(DCTree)+1)/2);%求出DC系数SSSS的编码的范式递增序列
%SSSS的编码(按位数划分)数量以1个字节存入到huffman表的头部
n=1;
for i=1:16 %SSSS的编码位数为1～16,每种位数的编码的个数最多16个
    if n<=length(codeLengths)&&codeLengths(n)==i
        Header=[Header,dec2bin(codeCounts(n),8)];
        n=n+1;
    else
        Header=[Header,'00000000'];%
    end
end
%将每个编码代表的实际值存入huffman表
for i=1:length(SSSSInOrder)
    Header=[Header,dec2bin(SSSSInOrder{i}.value,8)];
end

%对AC系数的huffman表存储
%首先清空用于DC系数huffman表存储的变量
codesInOrder=[];
codeLengths=[];
codeCounts=[];
[RRRRSSSSInOrder codeLengths codeCounts]=sortTreeCode(ACTree,(length(ACTree)+1)/2);%求出AC系数RRRRSSSS的编码的范式递增序列
%每种RRRRSSSS的编码(按位数划分)数量以2个字节存入到huffman表的头部
n=1;
for i=1:256 %RRRRSSSS的编码位数为1～256,每种位数的编码的个数最多256个
    if n<=length(codeLengths)&&codeLengths(n)==i
        Header=[Header,dec2bin(codeCounts(n),8)];
        n=n+1;
    else
        Header=[Header,'00000000'];
    end
end
% 将每个编码代表的实际值存入huffman表
for i=1:length(RRRRSSSSInOrder)
    Header=[Header,dec2bin(RRRRSSSSInOrder{i}.value,8)];
end

%对每一块进行编码
Body='';%所有块的编码
Blocks{row/8,column/8}=[];%每个块的编码
n=0;
for i=1:row/8
    for j=1:column/8
        n=n+1;
        %对DC系数进行编码
        code=DCTree(S2T(DCs(n,1)+1)).code;%取出SSSS的编码
        if DCs(n,2)>0
            Blocks{i,j}=[Blocks{i,j},code,dec2bin(DCs(n,2))];
        elseif DCs(n,2)<0
            Blocks{i,j}=[Blocks{i,j},code,dec2bin(bitcmp(-DCs(n,2),DCs(n,1)),DCs(n,1))];
        else %DC差值为零,不需要对DC差值(0)进行编码
            Blocks{i,j}=[Blocks{i,j},code];
        end
        %对AC系数进行编码
        AC=ACs{i,j};
        for k=1:length(AC(:,1))
            code=ACTree(RS2T(AC(k,1)*16+AC(k,2)+1)).code;%取出RRRRSSSS的编码
            if AC(k,3)>0
                Blocks{i,j}=[Blocks{i,j},code,dec2bin(AC(k,3))];
            elseif AC(k,3)<0
                Blocks{i,j}=[Blocks{i,j},code,dec2bin(bitcmp(-AC(k,3),AC(k,2)),AC(k,2))];
            else %AC(k,3)=0 编码为ZRL或者EOB,不需要对AC值进行编码
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
%合并文件头与文件体
%FileCode(33:64)=dec2bin(length(FileCode),32);%更改文件位数