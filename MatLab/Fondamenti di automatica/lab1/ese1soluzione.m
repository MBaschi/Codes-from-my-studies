close all;
clear;
clc;

A=[ -1  -1  2 ;
     0  -2 10 ;
     0 -10 -2 ];

autoval = eig( A );

REval = real( autoval );
% ------------------------------------ %
TD = -1 / max( REval ); % TD = tempo dominante

TR = 5 * TD; % TR = tempo di risposta del sistema
% ------------------------------------ %
b = [ 1 ; 1 ; 1 ];
c = [ 1 1 1 ];
d = 0;
u = 1;

xeq = -inv( A ) * b * u; % si ottiene mettendo x punto = 0

yeq = c * xeq + d * u;
% ------------------------------------ %
sistema = ss( A , b , c , d );

t = 0 : 0.001 : 7;

u = ones( size( t ) );

[ uscita , tempo , stato ] = lsim( sistema , u , t );

figure
plot( tempo , uscita )
hold all
plot( tempo , u )
ylim( [ 0 , 1.2 ] )
grid on
title( 'Uscita del sistema a ingresso unitario' )
xlabel( 'tempo [s]' )

guadagno = dcgain( sistema ) * ones( size( t ) );
plot( tempo , guadagno )
legend( 'uscita' , 'ingresso' , 'guadagno statico del sistema' )

figure
plot( tempo , stato( : , 1 ) ) 
hold all
plot( tempo , stato( : , 2 ) )
plot( tempo , stato( : , 3 ) )
grid on
title( 'Movimento per ingresso costante u=1' )
xlabel( 'tempo [s]' )
legend( 'x_1' , 'x_2' , 'x_3' )

figure
plot3( stato( : , 1 ) , stato( : , 2 ) , stato( : , 3 ) )
grid
hold on
plot3( xeq( 1 ) , xeq( 2 ) , xeq( 3 ) , '*' )
% ------------------------------------ %
u2 = 5 * u;
[ uscita2 , tempo2 , stato2 ] = lsim( sistema , u2 , t );

figure
plot( tempo2 , uscita2 )
hold all
plot( tempo2 , u2 )
ylim( [ 0 , 5.2 ] )
grid on
title( 'Uscita del sistema a ingresso u=5' )
xlabel( 'tempo [s]' )

regime = 5 * guadagno;
plot( tempo2 , regime )
legend( 'uscita' , 'ingresso' , 'regime del sistema per u=5' )

figure
plot( tempo2 , stato2( : , 1 ) )
hold all
plot( tempo2 , stato2( : , 2 ) )
plot( tempo2 , stato2( : , 3 ) )
grid on
title( 'Movimento per ingresso costante u=5' )
xlabel( 'tempo [s]' )
legend( 'x_1' , 'x_2' , 'x_3' )
