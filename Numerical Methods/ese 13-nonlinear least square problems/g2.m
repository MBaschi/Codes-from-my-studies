function F=g2(x,z,b)

F=zeros(3,1); 

F(1) =  (log(z).*z.^x(1))'...
    *(z.^x(1) +z.^x(2) +x(3)*ones(size(z))-b);
F(2) =  (log(z).*z.^x(2))'...
    *(z.^x(1) +z.^x(2) +x(3)*ones(size(z))-b);
F(3) = ones(size(z))'*(z.^x(1) +z.^x(2) +x(3)*ones(size(z)) -b);

end