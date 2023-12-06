clear all;clc;
syms E v E1 E2 v12 v21 G12  z1 z2 z3 z0 E3 L W d31 d32 y p1 p2 tc;
%t=0:0.0001:0.025;
%E3=100*sin(2*pi*120*t)+100;     
%plot(t,E3)
%PZT��ѧ���ܲ���
p1=7800;   %�ܶ�kg/m
t=127e-6;
E3=300/t;            %��������ĵ糡ǿ��v
E=6.2e10;   v=0.31; %���Ժͼ���ģ��Gpa &���ɱ� ����G12=24e9
d31=-320e-12; d32=-320e-12; %ѹ�糣��pm/v
d=[d31;d32;0];
%CF��ѧ���ܲ���
p2=1500;   %�ܶ�kg/m
E1=350e9;  E2=7e9; G12=5e9;   %���Ժͼ���ģ��Gpa
v12=0.33; v21=E2*v12/E1;         %���ɱ�
%% �նȾ����Ԫ��   ��ͬ���Բ���PZT
Q112=E/(1-v^2);  Q222=Q112;
Q122=E*v/(1-v^2);
Q662=E/(2*(1+v)); G=Q662;
%�նȾ����Ԫ��   �������Բ���CF
Q11=E1/(1-v12*v21);
Q12=v12*E2/(1-v12*v21);
Q22=E2/(1-v12*v21);
Q66=G12;
% PZT layer�նȾ���
Q0=[Q112 Q122 0
        Q122 Q222 0
         0      0    Q662];
% CF layer�նȾ���
Q1=[Q11 Q12 0
         Q12 Q22 0
         0      0    Q66];
% �����նȾ���
Qmid=Q1;
Qfirst=Q0;
Qthird=Q0;
%% ����ѹ���������ļ��β���
wnom=1e-3; l=5e-3;    %��Ⱥͳ���
l_r=1; w_r=1.5;
%% �ۺ�ģ�͵ĸ���ϵ��
g_delta=(1+2*l_r);
g_c=8*(1-w_r).^3;
g_d=-6*(w_r-1).*(3+4*l_r-2*w_r-4*l_r.*w_r);
g_e=3*(-2-2*l_r+w_r+2*l_r.*w_r).^2.*log((2-w_r)./w_r);
G_le=(g_d+g_e)./g_c;
G_F=g_delta/G_le;
G_U=g_delta*G_F;
%%  
Du=[];%�����ܶ�
TD=[];%tip displacement
BF=[];%block force
%  tr=tc/t;  CF�������ѹ���ú�ȱ�
for tr=0:0.01:2;
    tc=tr*t  ;
   % ������m
    z0=-tc/2-t; 
    z1=-tc/2; 
    z2=tc/2; 
    z3=tc/2+t; 

     % �������նȾ���
     A=Qfirst*(z1-z0)+Qmid*(z2-z1)-Qthird*(z3-z2);
     B=(Qfirst*(z1^2-z0^2)+Qmid*(z2^2-z1^2)+Qthird*(z3^2-z2^2))*(1/2);
     D=(Qfirst*(z1^3-z0^3)+Qmid*(z2^3-z1^3)+Qthird*(z3^3-z2^3))*(1/3);
     F=[A,B;B,D];
     % C=inv(F);  % inv_Matrix inverse % Warning: Matrix is singular to working precision. 
     C=pinv(F);   % pinv_Moore-Penrose pseudoinverse of matrix
     
     % ֻ���ǵ�ѹ���ĺ��,�糡����ʱ��������������
     Fp=E3*(z1-z0)*Qfirst*d+E3*(z3-z2)*Qthird*d;  
     Mp=E3*1/2*(z1^2-z0^2)*Qfirst*d-E3*1/2*(z3^2-z2^2)*Qthird*d;
     Np=[Fp;Mp];
     PE3=C(4,1)*Np(1)+C(4,2)*Np(2)+C(4,4)*Np(4)+C(4,5)*Np(5);
    % du=3/8*PE3*PE3/F(4,4)/(2*p1*t+p2*tc)*G_U;
    du=-3/8*PE3*PE3/C(4,4)/(2*p1*t+p2*tc)*G_U;
    
    Du=[Du du];
    td=PE3*l^2/2*g_delta;
    td=td*10^6;%ת��Ϊ΢��
    TD=[TD td];
    bf=3*PE3*wnom/(2*C(4,4)*l)*G_F;
    bf=bf*10^3;%ת��ΪmN
    BF=[BF bf];
end

tr=0:0.01:2;
% �����ܶ�
figure(1);
plot(tr,Du)
xlabel('Passive Layer Thickness Ratio(tr)');
ylabel('Energy density (J/kg)');
grid on

% Զ��λ�����
figure(2);
plot(tr,TD)
xlabel('Passive Layer Thickness Ratio(tr)');
ylabel('Tip Displacement (um)');
grid on
 
% ���������
figure(3);
plot(tr,BF)
xlabel('Passive Layer Thickness Ratio(tr)');
ylabel('Block Force (mN)');
grid on