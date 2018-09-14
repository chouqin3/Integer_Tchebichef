function [Compression_Ratio ri]  = integer_dtt_color (I)
    [mb,nb]=size(I);
%     I1=I;
    I=double(I);
    M=dtt_transform(I,mb,nb,8);
    [ dccof, accof ]=huffmanEncode(M);
    dc_length=length(dccof);
    ac_length=length(accof);
    Compression_Ratio=(8/((dc_length+ac_length)/(mb*nb)));
    ri = huffmanDecode(dccof,accof,mb,nb);
    ri=dtt_inverse(ri,mb,nb,8);
    ri=round(ri);

end