clear;
close all;
clc;

M_s = 250; % Kg
k_s = 5000;% N/m
a_s = 1000;% N*s/m

A = [ 0 , 1 ; -k_s / M_s , -a_s / M_s ];	

autoval = eig( A ); disp(autoval)

B = [ 0 , 0 ; k_s / M_s , a_s / M_s ];
c = [ 1 0 ];
d = [ 0 0 ];
sys_sedile_2 = ss( A , B , c , d );

%% alta velocità
vel = 50 / 3.6;	% m/s
[ x_strada , x_dot_strada , t_strada ] = genera_rampa( vel );
[ pos_sedile_2 , t_sim , st_sim ] = lsim( sys_sedile_2 , [ x_strada ; x_dot_strada ] , t_strada );

figure
plot( t_sim , pos_sedile_2 )
grid on
xlabel( 'tempo [s]' )
ylabel( 'posizione del sedile [m]' )
hold on
plot( t_sim,x_strada , 'r' )
legend( 'posizione sedile' , 'posizione dosso' );
title( sprintf( 'velocità = %i km/h',vel*3.6 ) )
axis([0 15 0 0.2])

%% bassa velocità
vel = 5 / 3.6;	% m/s
[ x_strada , x_dot_strada , t_strada ] = genera_rampa( vel );
[ pos_sedile_2 , t_sim , st_sim ] = lsim( sys_sedile_2 , [ x_strada ; x_dot_strada ] , t_strada );

figure
plot( t_sim , pos_sedile_2 )
grid on
xlabel( 'tempo [s]' )
ylabel( 'posizione del sedile [m]' )
hold on
plot( t_sim,x_strada , 'r' )
legend( 'posizione sedile' , 'posizione dosso' );
title( sprintf( 'velocità = %i km/h',vel*3.6 ) )
axis([0 15 0 0.2])

%% bassissima velocità
vel = 1 / 3.6;	% m/s
[ x_strada , x_dot_strada , t_strada ] = genera_rampa( vel );
[ pos_sedile_2 , t_sim , st_sim ] = lsim( sys_sedile_2 , [ x_strada ; x_dot_strada ] , t_strada );

figure
plot( t_sim , pos_sedile_2 )
grid on
xlabel( 'tempo [s]' )
ylabel( 'posizione del sedile [m]' )
hold on
plot( t_sim,x_strada , 'r' )
legend( 'posizione sedile' , 'posizione dosso' );
title( sprintf( 'velocità = %i km/h',vel*3.6 ) )
axis([0 15 0 0.2])