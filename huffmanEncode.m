function [ dccof, accof ] = huffmanEncode(trans)
%HUFFMANENCODER Summary of this function goes here
%   Detailed explanation goes here
% trans=[16 0 0 0 0 0 0 0
%         0 1 0 0 0 0 0 0
%         zeros(6,8)];
[mf,nf] = size(trans);
mb = mf / 8;
nb = nf / 8;

if mb * nb > 1
    fdc = reshape(trans(1:8:mf, 1:8:nf)', mb*nb, 1);
end
fdpcm = dpcm(fdc,1);
dccof = [];
for i = 1:mb*nb,
    dccof = [dccof jdcenc(fdpcm(i))];
end
z = [1   2   6   7  15  16  28  29
    3   5   8  14  17  27  30  43
    4   9  13  18  26  31  42  44
    10  12  19  25  32  41  45  54
    11  20  24  33  40  46  53  55
    21  23  34  39  47  52  56  61
    22  35  38  48  51  57  60  62
    36  37  49  50  58  59  63  64];

acseq=[];
for i = 1:mb
    for j = 1:nb
        tmp(z) = trans(8*(i-1)+1:8*i, 8*(j-1)+1:8*j);
        % tmp is 1 by 64
        eobi = find(tmp~=0, 1, 'last'); %end of block index
        % eob is labelled with 999
        acseq = [acseq tmp(2:eobi) 999];
    end
end
accof = jacenc(acseq);
end 
























% zig = [1   2   6   7  15  16  28  29;
%    3   5   8  14  17  27  30  43;
%    4   9  13  18  26  31  42  44;
%   10  12  19  25  32  41  45  54;
%   11  20  24  33  40  46  53  55;
%   21  23  34  39  47  52  56  61;
%   22  35  38  48  51  57  60  62;
%   36  37  49  50  58  59  63  64];
% [m, n] = size(trans);
% % DC、AC系数获取
% ac = [];
% dc = zeros([1, m*n]);
% count = 1;
% for i = 1:m
%     for j = 1:n
%         tmp = trans{i, j};
% %         eob = find(tmp, 1);
%         ac = [ac, tmp(2:end)];
%         dc(count) = tmp(1);
%         count = count + 1;
%     end
% end
% %DC系数差分编码
% dcs = zeros([1, m*n]);
% dcs(1) = dc(1);
% for i = 2:m*n
%     dcs(i) = dc(i) - dc(i-1);
% end
% %生成字典
% data = [ac dcs];
% elements = unique(data);
% freq = histc(data, elements) ./ length(data);
% [dict, avglen] = huffmandict(elements, freq);
%
% %Huffma编码
% acEnc = huffmanenco(ac, dict);
% dcEnc = huffmanenco(dcs, dict);



