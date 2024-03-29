%%有效质量计算
clear all; clc;
dr=0.25;
% wr=0.5;
% lr=1;
x=linspace(0,2,10);
y=linspace(0,2,10);
[lr,wr]=meshgrid(x,y);

g1=wr-1;g2=wr-2;
g9=2*lr.*g1+wr-2;
g10=2*wr-3;
g11=5*wr-9;

g18=4*lr.*g1.*(15156+1800*dr.*g1.*g2.*g10.^2+wr.*(-41834+wr.*(41856+wr.*(-18039+2816*wr))));
g19=wr.*(135808+wr.*(-182782+wr.*(120878+wr.*(-39257+4992*wr))));

g12=3*g2.^3+8*dr.*lr.*(3*g2.^2+6*lr.*g1.*g2+4*lr.^2.*g1.^2).*g1;
g13=2*g1.*(-39624+67200*dr.*lr.^3.*g1.^4.*g2+100*lr.^2.*g1.^2.*(-234+432*dr.*g1.*g2.*g10+wr.*(490+wr.*(-317+64*wr)))+g18+g19);
g14=150*g2.*g9.^2.*g12.*log(2-wr).^2;
g15=15*g2.*g9.*log(2-wr).*(-3200*dr.*lr.^3.*g1.^4-960*dr.*lr.^2.*g1.^3.*g11-...
    10*lr.*g1.*g2.*(96*dr.*g1.*g10+g2.*(31*wr-30))-g2.^2.*(396+...
    wr.*(279*wr-676))-20*g9.*g1*2.*log(wr));
g16=15*g2.*g9.*log(wr).*(3200*dr.*lr.^3.*g1.^4+960*dr.*lr.^2.*g1.^3.*g11+...
    10*lr.*g1.*g2.*(96*dr.*g1.*g10+g2.*(31*wr-30))+g2.^2.*(396+...
    wr.*(279*wr-676))+10*g9.*g1*2.*log(wr));
g17=-5000*(1+dr.*lr.*(2-wr)).*(1+3*lr.*(1+lr)).^2;
M1=g13+g14+g15+g16;
M=(g13+g14+g15+g16)./g17;

figure(1)
[C,h]=contour(lr,wr,M);
clabel(C,h)
xlabel('lr');
ylabel('wr');
hold on