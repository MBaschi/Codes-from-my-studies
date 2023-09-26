function [omegas,bms,omegasf,bfsf]=bodeasin(num,den,wmin,wmax)
% function [omega,bms,omegasf,bfsf]=bodeasin(num,den,wmin,wmax)
% Diagrammi di Bode asintotici e reali
% num,den = vettori con i coeff. del numeratore e del denominatore ordinati
% secondo potenze decrescenti di s
% wmin, wmax = valore minimo e massimo della pulsazione
% La funzione ritorna
% omega: i valori dei punti per il diagramma asintotico del modulo
% bms: l'ordinata del diagramma di bode asintotico del modulo
% omegasf: i valori dei punti per il diagramma asintotico della fase
% bfsf: l'ordinata del diagramma di bode asintotico della fase


dmin=floor(log10(wmin));
dmax=ceil(log10(wmax));
wmin=10^dmin; wmax=10^dmax;
%
% Calcolo di poli, zeri e guadagno
%
nn=length(num)-1;
nd=length(den)-1;
poli=roots(den);
zeri=roots(num);
numz=num(num~=0); kn=numz(length(numz));
denz=den(den~=0); kd=denz(length(denz));
guad=kn/kd;
%
% Costruzione vettore delle ascisse
%
nomega=1; omega(nomega)=wmin;
for i=1:nd
  om=abs(poli(i));
  if om>wmin & om<wmax
    nomega=nomega+1; omega(nomega)=om;
  end
end
for i=1:nn
  om=abs(zeri(i));
  if om>wmin & om<wmax
    nomega=nomega+1; omega(nomega)=om;
  end
end
nomega=nomega+1; omega(nomega)=wmax;
%
% Calcolo diagramma del modulo
%
bm=zeros(length(omega));
for j=1:nomega
  bm(j)=guad;
  for i=1:nd
    om=abs(poli(i));
    if om==0
      bm(j)=bm(j)/omega(j);
    elseif om<omega(j)
      bm(j)=bm(j)*om/omega(j);
    end
  end
  for i=1:nn
    om=abs(zeri(i));
    if om==0
      bm(j)=bm(j)*omega(j);
    elseif om<omega(j)
      bm(j)=bm(j)*omega(j)/om;
    end
  end
end
[omegas,ind]=sort(omega);
bms=bm(ind);
%
% Calcolo diagramma della fase
%
for j=1:nomega
  bf(j)=0;
  for i=1:nd
    om=abs(poli(i));
    if om<omega(j)
      if real(poli(i))>0
        bf(j)=bf(j)+90;
      else
        bf(j)=bf(j)-90;
      end
    end
  end
  for i=1:nn
    om=abs(zeri(i));
    if om<omega(j)
      if real(zeri(i))>0
        bf(j)=bf(j)-90;
      else
        bf(j)=bf(j)+90;
      end
    end
  end
  if guad<0
    bf(j)=bf(j)-180;
  end
end
bfs=bf(ind);
for i=1:nomega-1
  omegasf(2*i-1)=omegas(i);
  omegasf(2*i)=omegas(i);
  bfsf(2*i-1)=bfs(i);
  bfsf(2*i)=bfs(i+1);
end
omegasf(2*nomega-1)=omegas(nomega);
bfsf(2*nomega-1)=bfs(nomega);
bms=20*log10(bms);
