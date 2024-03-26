function m = m_choice(phi,dphi,xold,gamma)

m=0;
phiold  = phi(xold);
dphiold = dphi(xold);

xm   = xold - gamma*dphiold;
phim = phi(xm);

mlim = -0.5*gamma*norm(dphiold, 2)^2;

inc = phim-phiold;

while inc>mlim
    m    = m+1;
    xm   = xold - (0.5^m)*gamma*dphiold;
    phim = phi(xm);
    inc  = phim-phiold;
    mlim = .5*mlim;
end