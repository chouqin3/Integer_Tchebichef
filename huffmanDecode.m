function ri=huffmanDecode(dccof,accof,mb,nb)
block_size = 8;
mb=mb/8;
nb=nb/8;
dcarr = jdcdec(dccof);
acarr = jacdec(accof);

Eob = find(acarr==999);
kk = 1;
ind1 = 1;
n = 1;
for ii = 1:mb
    for jj = 1:nb
        ac = acarr(ind1:Eob(n)-1);
        ind1 = Eob(n) + 1;
        n = n + 1;
        ri(8*(ii-1)+1:8*ii,8*(jj-1)+1:8*jj) = dezigzag([dcarr(kk) ac zeros(1,63-length(ac))]);
        kk = kk + 1;
    end
end
end

