%% G(s) = 1
num = 1;
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 7
num = 7;
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(5s)
num = 1;
den = [5 0];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(-5s)
num = 1;
den = [-5 0];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 5s
num = [5 0];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = -5s
num = [-5 0];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(1+5s)
num = 1;
den = [5 1];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(1-5s)
num = 1;
den = [-5 1];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = (1+5s)/1
num = [5 1];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = (1-5s)/1
num = [-5 1];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(1+2s+s^2)
num = 1;
den = [1 2 1];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = (1+2s+s^2)
num = [1 2 1];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = (1-2s+s^2)
num = [1 -2 1];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(1+s^2)
num = 1;
den = [1 0 1];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1+3s
num = [3 1];
den = 1;
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = 1/(1+s)
num = 1;
den = [1 1];
sys = tf(num, den);
figure; bode(sys, '--'); grid on

%% G(s) = (1+3s)/(1+s)
num = [3 1];
den = [1 1];
sys = tf(num, den);
figure; bode(sys, '--'); grid on
