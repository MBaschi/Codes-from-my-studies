function [evalua]=averageECG(R_index,x,pre,post,fm)
% x es la se�al EHG (dimension 1xn) (ECG materno y ECG fetal)
% R_index contiene los indices de ECG materno (se�al ECG registrada)
% pre: ventana de an�lisis antes de la onda R en muestras, default
% value=275=0.275s*1000 Hz
% post: ventana de an�lisis despu�s de la onda R en muestras, default
% value=425=0.425s*1000Hz
% fm: frecuencia de muestreo, por defecto 1000 Hz

% evalua: los n latidos identificados 

if(nargin<2)
     error('al menor ha de tener dos variable: R_index y x');
end
% pre=100, equivale a 200 ms antes de la onda R con una frecuencia muestreo
% de 500 Hz
% post=150, equivale a 300 ms despu�s de la onda R con una fm=500 Hz
if nargin==2
    pre=275;
    post=425;
    fm=1000;
end
if nargin==3
    post=425;
    fm=1000;
end
if nargin==4
    fm=1000;
end
if size(x,1)>size(x,2)
    x=x';
end
[b,a]=butter(5,2/fm,'high');
x=filtfilt(b,a,x);

m=size(R_index,2);

% % Si el primer QRS detectado, la onda P est� fuera de la ventana actual
% if (R_index(1)-pre)>=1
%     evalua=(R_index(1)-pre):(R_index(1)+post);
% else
%     evalua=1:(R_index(1)+post);
% end
evalua=[];
ii=[];
for i=2:m-1
    if (R_index(i)-pre+1)<1
        ini=1;
    else
        ini=R_index(i)-pre+1;
    end
    if R_index(i)+post>length(x)
        fin=length(x);
    else 
        fin=R_index(i)+post;
    end    
    eval=x(ini:fin);
    evalua=[evalua;eval];
    ii=[ii;R_index(i)];
end


average=mean(evalua); template=average';


isoelectric=(average(1)+average(end))/2;
reference=isoelectric*ones(1,length(x));
resid=0;
for j=1:size(evalua,1)
    factor(j)=pinv(template'*template)*template'*evalua(j,:)';
end


for i=2:m-1
    reference((R_index(i)-pre+1):(R_index(i)+post))=average*factor(i-1);
end

% resolviendo problema del efecto borde (cuando la ventana se extiende m�s
% all� de la ventana de an�lisis
n=length(average);

ini=R_index(1)-pre+1;
fin=R_index(1)+post;
if ini<=1
    reference(1:fin)=average(n-fin+1:n);   
else
    reference(ini:fin)=average;
end
ini=R_index(m)-pre+1;
fin=R_index(m)+post;
if fin>=length(x)
    fin=length(x);
    tam=fin-ini+1;
    reference(ini:length(x))=average(1:tam);
else
    reference(ini:fin)=average;
end

% 
% % Si el �ltimo QRS detectado esta muy cercano del final
% if (R_index(end)+post)<=length(x)
%     evalua=[(R_index(end)-pre):(R_index(end)+post)];
% else
%     evalua=[R_index(end)-pre:length(x)];
% end
% 
% average=mean(evalua);
