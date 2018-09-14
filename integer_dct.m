function [Bit_Ratio ri] = integer_dct (I)
    [mb,nb]=size(I);
    I=double(I) - 128 ;
    M=dct_transform(I,mb,nb,8);
    [ dccof, accof ]=huffmanEncode(M);
    dc_length=length(dccof);
    ac_length=length(accof);
    Bit_Ratio=(dc_length+ac_length)/(mb*nb);

%     ri = huffmanDecode(dccof,accof,mb,nb);
    ri=dct_inverse(M,mb,nb,8) + 128;
    
end