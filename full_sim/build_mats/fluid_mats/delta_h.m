function del_h = delta_h( rf, rb , dr )

%take points on the flow domain (rf) that are within the support
%(supp) of the IB points (rb), and evaluate
%               delta( abs(rf - rb) )

%Currently uses the Yang3 smooth delta function (see Yang et al, JCP,
%2009), which has a support of 6*h (3*h on each side)

%Note: the result is delta * h
r = abs( rf - rb ); 
r1 = r/dr;
r2 = r1.*r1;
r3 = r2.*r1;
r4 = r3.*r1;

del_h = 0;


    a5 = asin((1.d0/2.d0)*sqrt(3.d0)*(2.d0*r1-1.d0));
    a8 = sqrt(1.d0-12.d0*r2+12.d0*r1) ;

del_h = del_h + (r1 <=1 ) .* (...
    0.4166666667d-1*r4+(-0.1388888889+0.3472222222d-1*a8).*r3+ ...
    (-0.7121664902d-1-0.5208333333d-1*a8+0.2405626122*a5).*r2+ ...
    (-.2405626122*a5-.3792313933+.1012731481*a8).*r1+0.8018753741d-1*a5 ...
    -0.4195601852d-1*a8+.6485698427 );


    a6 = asin((1.d0/2.d0)*sqrt(3.d0)*(-3.d0+2.d0*r1));
    a9 = sqrt(-23.d0+36.d0*r1-12.d0*r2);

del_h = del_h + (r1 >1 & r1 <= 2) .* (...
    -0.6250000000d-1*r4+(.4861111111-0.1736111111d-1*a9).*r3 + ...
    (-1.143175026+0.7812500000d-1.*a9-.1202813061.*a6).*r2 + ...
    (.8751991178+.3608439183.*a6-.1548032407.*a9).*r1-.2806563809.*a6 + ...
    0.822848104d-2+.1150173611.*a9 );


    a1 = asin((1.d0/2.d0*(2.d0*r1-5.d0))*sqrt(3.d0));
    a7 = sqrt(-71.d0-12.d0*r2+60.d0*r1);

del_h = del_h + (r1 > 2 & r1 <=3) .* (...
    0.2083333333d-1*r4+(0.3472222222d-2.*a7-.2638888889).*r3+ ...
        (1.214391675-0.2604166667d-1.*a7+0.2405626122d-1.*a1).*r2+ ...
        (-.1202813061.*a1-2.449273192+0.7262731481d-1.*a7).*r1 +.1523563211.*a1 ...
        +1.843201677-0.7306134259d-1.*a7 );
    
end






