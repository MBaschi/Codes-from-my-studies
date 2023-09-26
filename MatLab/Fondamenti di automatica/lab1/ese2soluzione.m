A = [ -0.8 1   -1;
      -0.5 0.6 -1;
      -1   1   -0.5 ];

autoval = eig( A );

modautoval = abs( autoval );

lD = max( modautoval );
TD = -1 / log( lD );
TR = 5 * TD;

% ---------------------------------------------- %

b = [ 1 ; 1 ; 1 ];
c = [ 1 1 1 ];
d = 0;
u = 2;

xeq = ( eye( size( A ) ) - A ) \ b * u;%xeq = inv( eye( size( A ) ) - A ) * b * u;

yeq = c * xeq + d * u;

% ---------------------------------------------- %

sistema = ss( A , b , c , d , 1 );

t = 0 : 20;
u= 2 * ones( size( t ) );

[ out , time , state ] = lsim( sistema , u , t );

figure
plot( time , out , '-*' )
hold all
plot( time , u )
xlim( [ -1 , 20 ] )
ylim( [ 0 , 7 ] )
grid on
title( 'Uscita del sistema a un ingresso costante u=2' )
xlabel( 'tempo [campioni]' )
legend( 'output','input' )

figure 
plot( time , state( : , 1 ) , '-*' )
hold all 
plot( time , state( : , 2 ) , '-*' ) 
plot( time , state( : , 3 ) , '-*' ) 
xlim( [ -1 , 20 ] )
ylim( [ 0 , 3 ] )
grid on 
title( 'Movimento per ingresso costante u=2' ) 
xlabel( 'tempo [campioni]' ) 
legend( 'x_1' , 'x_2' , 'x_3' )

figure
plot3( state( : , 1 ) , state( : , 2 ) , state( : , 3 ) , '-*' )
hold on
grid
plot3( xeq( 1 ) , xeq( 2 ) , xeq( 3 ) , '.' , 'MarkerSize' , 40 )