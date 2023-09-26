%% solo G è instabile
num=40;
den=conv([0.01 1],conv([0.001 1],[0.001 1]));
L = tf(num,den);
margin(L)

%% Scelta del polo
num=40;
tauvett=[]; wcritvett=[];
for tau=0.01:0.001:0.1
    den=conv([tau 1],conv([0.01 1],conv([0.001 1],[0.001 1])));
    [mod,fase,puls]=bode(num,den);
    [alfa,margfase,beta,wcritica]=margin(mod,fase,puls);
    if wcritica>0
        tauvett=[tauvett;tau];
        wcritvett=[wcritvett;wcritica];
    end
end
figure; plot(tauvett,wcritvett); xlabel('tau'); ylabel('pulsazione critica'); grid;

%% tau=0.03
tau=0.03;
den= conv([tau 1],conv([0.01 1],conv([0.001 1],[0.001 1])));
L = tf(num,den);
margin(L)

%% Scelta dello zero
den= conv([tau 1],conv([0.01 1],conv([0.001 1],[0.001 1])));
alphavett=[]; mfvett=[];
for alpha=0.01:0.01:1
    num=[alpha*tau 1]*40;
    [mod,fase,puls]=bode(num,den);
    [alfa,margfase,beta,wcritica]=margin(mod,fase,puls);
    if margfase>0
        alphavett=[alphavett;alpha];
        mfvett=[mfvett;margfase];
    end
end
figure; plot(alphavett,mfvett); xlabel('alpha'); ylabel('margine di fase'); grid;

%% verifica per tau=0.03 e alfa=0.1
clear; close all;
tau=0.03;
alpha=0.26;
num=[alpha*tau 1]*40;
den= conv([tau 1],conv([0.01 1],conv([0.001 1],[0.001 1])));
margin(num,den);
