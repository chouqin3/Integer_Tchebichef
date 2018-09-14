function dtt=dttmtx(N)
order_max = N;
for x=0:N-1
    t(1,x+1) = 1/sqrt(N);
end
for x=0:N-1
    t(2,x+1) = (2*x+1-N)*sqrt(3/(N*(N^2-1)));
end

for x=0:N-1
   for tt=2:order_max-1
       alpha1 = (2/tt)*sqrt((4*tt^2-1)/(N^2-tt^2));
       alpha2 = ((1-N)/tt)*sqrt((4*tt^2-1)/(N^2-tt^2));
       alpha3 = ((1-tt)/tt)*sqrt((2*tt+1)/(2*tt-3))*sqrt((N^2-(tt-1)^2)/(N^2-tt^2));
       t(tt+1,x+1) = (alpha1*x+alpha2)*t(tt-1+1,x+1)+alpha3*t(tt-2+1,x+1);
   end
end
dtt=t;