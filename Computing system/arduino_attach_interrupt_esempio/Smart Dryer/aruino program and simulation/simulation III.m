clear all
close all

disp('_____________________________________')
%costamti che mi servono
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
p_asc=0.05 %percentuale di calore preso per far evaporare l'acqua
t_incr=0.01;

%costanti definite nella teoria
c_1=h*A_p/(M*c_va);
c_2=k*S/(M*c_va);
c_3=h*A_p/(M*c_p);


System=@(t,y)[c_1.*(y(2)-y(1))+c_2.*(T_amb-y(1)) %y(1)= temperatura aria, y(2)=temperatura panno, y(3)= numero di particelle nel panno  
              c_3*(1-p_asc).*(y(1)-y(2))]
              
            
t=[1:t_incr:5000]; %tempo di simulazione in secondi
Y0=[ T_amb
     T0_p];
     
risultati=ode45(System,t,Y0);

l=size(risultati.y,2);
T_A=risultati.y(1,:);
T_P=risultati.y(2,:);
t=[1:l];


plot(t,T_A);hold on;plot(t,T_P);




%cose che tnego che magari mi potrebbero servire
%N_usc=@(T)integral(@(v)max_bolz(v,T),vf,inf); %numero di particelle uscenti dal sistema
%d_mb=@(v,T,N,dN,dT)(4*pi*(m/(2*pi*R))^(-3/2)).*(v.^2).*exp(-(m*v.^2)./(2*R*T)).*T.^(-3/2).*(dN-N.*dT./T(-((m*v.^2)./(2*R*T))-1)); %derivata di maxwell boltzam nel tempo dove il numeor di particelle e la temperatura dipendono dal tempo
%g=@(T,N,dN,dT)integral(@(v)(d_mb(v,T,N,dN,dT).*(0.5.*m.*v.^2)),vf,inf); %energie uscente presa per l'asciugatura in unità di tempo

disp('//////////////////////////////')