function F=g3(x,z,b)
 
F = zeros(6,1); 

F(1) = (cos(x(2)*pi*z))'...
    *(x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b);
F(2) = (-x(1)*pi*z.*sin(x(2)*pi*z))'...
    *(x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b);
F(3) = cos(x(4)*pi*z)'*(x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b);

F(4) = (-x(3).*pi*z.*sin(x(4)*pi.*z))'...
    *(x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b);
F(5) = cos(x(6)*pi*z)'*(x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b);
F(6) = (-x(5)*pi*z.*sin(x(6)*pi*z))'...
    *(x(1)*cos(x(2)*pi*z)+x(3)*cos(x(4)*pi*z)+x(5)*cos(x(6)*pi*z)-b);
end