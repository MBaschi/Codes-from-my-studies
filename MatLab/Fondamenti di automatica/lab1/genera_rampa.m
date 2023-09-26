function [u,u_dot,t_dosso]=genera_rampa(vel)

h_dosso=0.1; % metri
l_dosso=1;  % metri
t_0=1;      % secondi
d_dosso = sqrt(h_dosso^2 + l_dosso^2);
t_1=t_0+d_dosso/vel;
f_camp=10000;
t_dosso=0:1/f_camp:15;

u=zeros(size(t_dosso));
u(floor(t_0*f_camp):floor(t_1*f_camp))=h_dosso/d_dosso*vel*(t_dosso(floor(t_0*f_camp):floor(t_1*f_camp))-t_dosso(floor(t_0*f_camp)));
u(floor(t_1*f_camp)+1:end)=u(floor(t_1*f_camp));

u_dot=zeros(size(t_dosso));
u_dot(floor(t_0*f_camp):floor(t_1*f_camp))=h_dosso/d_dosso*vel;