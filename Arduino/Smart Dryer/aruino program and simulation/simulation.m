clear all
close all

disp('______________________')
M=0.5; %peso panni in kg
c_p=1000; %calore specifico cotone in J/(kg*K) su internet dice che va da 840 a 1300
c_a_s=711.28; %calore specifico aria secca in J/(kg*K)  VOLUME COSTANTE
c_va=2050; %calore specifico vapore aqueo
h=50;  %coefficente di scambio termico convettivo in W/(m^2*K). saponnemntricamnete h va da 10 a 100
k=50; %coefficende di scambio termico tra due masse d'aria
S=0.3*0.08; %superficie di separazione tra aria esterna e interna in m^2 30cm X 8cm (spannometrico)
A_p=0.5*0.5; %area panno in m^2 50cm X 50cm
T_amb=300; %temperatura ambiente
T0_p=273+16; %temperature iniziale del panno in K
N_a=(6.022*10^23); %numero di avogadro
R=8.314;%vostante dei gas perfetti
m=18*10^(-3); %massa molare dell'acqua: 18 g/mol(2*MM idrogeno+ MM ossigeno=1+1+16) 
n=M/m; %numero di moli di acqua iniziali
Ni=1000; %numero di molecole d'acqua nel vestito iniziali;
t_increment=0.1;
%costanti definite nella teoria
c_1=h*A_p/(M*c_va);
c_2=k*S/(M*c_va);
c_3=h*A_p/(M*c_p);
c_4=1/(M*c_p);
c_5=-m/(2*R);


%max_bolz=@(v,T)4.*pi.*(m./(2.*pi.*R.*T)).^(3/2).*v.^2.*exp(-(m./(2.*pi.*R.*T)).*v.^2);v=[0:10:4000]; plot(v,max_bolz(v,T)) %se vuoi plottare la distribuzione di maxweel boltzman
vf=2250; %velocità di fuga delle molecole (ipotizzata a caso guardando la distribuzione di maxwell boltzam)

%funzioni definite nella teoria
A=@(v,y)  4.*pi.*((-c_5.*v.^2).^(-1.5)).*(y.^(-1.5)).*exp(c_5.*v.^2./y);
B=@(v,y,N)4.*pi.*((-c_5.*v.^2).^(-1.5)).*(-N.*exp(c_5.*v.^2./y).*(y.^(-2.5)).*(c_5*v.^2./y+3/2));
D=@(y1,y2) c_3.*(y1-y2);
E=@(v,y) -c_4.*A(v,y).*0.5.*m.*v.^2;
F=@(v,y,N) -c_4.*B(v,y,N).*0.5.*m.*v.^2;
%integrali definiti nella teoria
SA=@(y2)integral(@(v)A(v,y2),vf,inf);
SB=@(y2,y3)integral(@(v)B(v,y2,y3),vf,inf);
SE=@(y2)integral(@(v)E(v,y2),vf,inf);
SF=@(y2,y3)integral(@(v)F(v,y2,y3),vf,inf);


f=@(y1,y2,y3) (D(y1,y2)./(1-SF(y2,y3))).*(1+(((1-SA(y2)).*SE(y2))./((1-SA(y2)).*(1-SF(y2,y3))-SB(y2,y3).*SE(y2))));
g=@(y1,y2,y3) (D(y1,y2).*(1-SA(y2)))./((1-SA(y2)).*(1-SF(y2,y3))-SB(y2,y3).*SE(y2));

System=@(t,y)[c_1*(y(2)-y(1))+c_2*(T_amb-y(1)) %y(1)= temperatura aria, y(2)=temperatura panno, y(3)= numero di particelle nel panno  
              f(y(1),y(2),y(3))
              -g(y(1),y(2),y(3))]; 
            
t=[1:t_increment:10000]; %tempo di simulazione in secondi
Y0=[ T_amb
     T0_p
     Ni];
risultati=ode45(System,t,Y0);
T_A=risultati.y(1,1:size(t,2));
T_P=risultati.y(2,1:size(t,2));
N=risultati.y(3,1:size(t,2));
plot(t,T_A);
hold on;
plot(t,T_P);
hold off;
plot(t,N);
%cose che tnego che magari mi potrebbero servire
%N_usc=@(T)integral(@(v)max_bolz(v,T),vf,inf); %numero di particelle uscenti dal sistema
%d_mb=@(v,T,N,dN,dT)(4*pi*(m/(2*pi*R))^(-3/2)).*(v.^2).*exp(-(m*v.^2)./(2*R*T)).*T.^(-3/2).*(dN-N.*dT./T(-((m*v.^2)./(2*R*T))-1)); %derivata di maxwell boltzam nel tempo dove il numeor di particelle e la temperatura dipendono dal tempo
%g=@(T,N,dN,dT)integral(@(v)(d_mb(v,T,N,dN,dT).*(0.5.*m.*v.^2)),vf,inf); %energie uscente presa per l'asciugatura in unità di tempo
    