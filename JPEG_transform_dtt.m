function [Bit_Ratio ri] = JPEG_transform_dtt (I)
    [mb,nb]=size(I);
    I=double(I);
    C = dttmtx(8);
    I1 = blkproc(I, [8 8], 'P1*x*P2', C, C');
    M = round(I1);
    [ dccof, accof ]=huffmanEncode(M);
    dc_length=length(dccof);
    ac_length=length(accof);
    Bit_Ratio=(dc_length+ac_length)/(mb*nb);

%     ri = huffmanDecode(dccof,accof,mb,nb);
     ri = blkproc(M, [8 8], 'P1*x*P2', C', C);
   
 
end