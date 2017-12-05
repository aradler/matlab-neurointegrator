clear all;
close all;
clc;

% define the heaviside because for some reason MATLAB only has it
% in the symbolic math toolbox
heaviside = @(x) double(x > 0);

% Tonic external current. The applied current is 3 uA/cm^2
ext_T = @( t ) 3;
% Excitatory external current. This, like in the paper, is 3
% 50 millisecond pulses at 1, 2, and 3 seconds. The applied
% current is 5 uA/cm^2.
ext_E = @( t ) 5 * (...
	heaviside( t-1000 ) - heaviside( t-1050 ) + ...
	heaviside( t-2000 ) - heaviside( t-2050 ) + ...
	heaviside( t-3000 ) - heaviside( t-3050 ) ); 
% Excitatory external current. This, like in the paper, is 3
% 50 millisecond pulses at 4 and 5 seconds.
ext_I = @( t ) 5 * (...
	heaviside( t-4000 ) - heaviside( t-4050 ) + ...
	heaviside( t-5000 ) - heaviside( t-5050 ) );

ext = @( t ) [ ext_T(t) ext_E(t) ext_I(t) ];

% Initialize the time vector:
len = 6000; % milliseconds
dt = 0.01; % milliseconds
ts = 0:dt:len;

% Initialize the solutions vector ( [V, h, n, b] )
ys = zeros( 4, 3, length( ts ) );

% Initial condition from the paper
ys(:, :, 1) = [
	-68.3737, 0.9820, 0.0631, 0.1259
	-68.3737, 0.9820, 0.0631, 0.1259
	-68.3737, 0.9820, 0.0631, 0.1259 ]';


% RK45 it on out
for n = 1:(length( ts )-1)
	% ys is a 3-dimensional array whose dimensions are
	% [neuron, V/h/n/b, time]
	k1 = TEI_neurons(ts(n), ys(:, :, n), ext( ts(n) ) );
	k2 = TEI_neurons(ts(n) + dt/2, ys(:, :, n) + dt/2 * k1, ext(ts(n)) );
	k3 = TEI_neurons(ts(n) + dt/2, ys(:, :, n) + dt/2 * k2, ext(ts(n)) );
	k4 = TEI_neurons(ts(n) + dt, ys(:, :, n) + dt * k3, ext(ts(n)));
	ys(:, :, n+1) = ys(:, :, n) + (dt / 6 .* (k1 + 2*k2 + 2*k3 + k4));
end

theta_s = -20; %mV pg 174
sigma_s = 2; %mV pg 174
alpha = 1; % to make the effects of synaptic saturation weak, pg 174
tau_0 = 100;
tau_burst = 5;

% %ds/dt = [alpha(1-s_0)sigma(V_0)-s_0]/tao_0;
sigma = @(V) 1./(1 + exp(-(V-theta_s)./sigma_s));
s_0=zeros(length( ts ),1);
s_e=zeros(length( ts ),1);
s_i=zeros(length( ts ),1);
V_0=ys(1, 1, :);
V_e=ys(1, 2, :);
V_i=ys(1, 3, :);

% s_0 := y(1)
% V_0 := y(2)
f = @(t, y) ( alpha .* ( 1 - y(1) ) .* sigma( y(2) ) - y(1) ) ./ tau_0;
f_eburst = @(t, y) ( alpha .* ( 1 - y(1) ) .* sigma( y(2) ) - y(1) ) ./ tau_burst;
%RK4
tic
for step=1:length(ts)-1
        
    k_1_0 = f(ts(step), [s_0(step), V_0(step)]);
    k_1_e = f_eburst(ts(step), [s_e(step), V_e(step)]);
    k_1_i = f_eburst(ts(step), [s_i(step), V_i(step)]);
    
    k_2_0 = f(ts(step) + (dt./2), [s_0(step), V_0(step)] + dt.*(k_1_0 ./ 2));
    k_2_e = f_eburst(ts(step) + (dt./2), [s_e(step), V_e(step)] + dt.*(k_1_e ./ 2));
    k_2_i = f_eburst(ts(step) + (dt./2), [s_i(step), V_i(step)] + dt.*(k_1_i ./ 2));
    
    k_3_0 = f(ts(step) + (dt./2), [s_0(step), V_0(step)] + dt.*(k_2_0 ./ 2));
    k_3_e = f_eburst(ts(step) + (dt./2), [s_e(step), V_e(step)] + dt.*(k_2_e ./ 2));
    k_3_i = f_eburst(ts(step) + (dt./2), [s_i(step), V_i(step)] + dt.*(k_2_i ./ 2));
    
    k_4_0 = f(ts(step) + dt, [s_0(step), V_0(step)] + dt.*(k_3_0));
    k_4_e = f_eburst(ts(step) + dt, [s_e(step), V_e(step)] + dt.*(k_3_e));
    k_4_i = f_eburst(ts(step) + dt, [s_i(step), V_i(step)] + dt.*(k_3_i));
    
    s_0(step+1) = s_0(step) + (k_1_0+2*k_2_0+2*k_3_0+k_4_0)*(dt/6);
    s_e(step+1) = s_e(step) + (k_1_e+2*k_2_e+2*k_3_e+k_4_e)*(dt/6);
    s_i(step+1) = s_i(step) + (k_1_i+2*k_2_i+2*k_3_i+k_4_i)*(dt/6);
    
end
toc

figure(1)
plot(ts, s_0)

figure(2)
plot(ts, s_e)

figure(3)
plot(ts, s_i)

% % Plot the tonic neuron:
% subplot( 3, 1, 1 );
% plot( ts, squeeze( ys( 1, 1, : ) ) );
% ylabel( 'Tonic stimulus' );
% 
% % Plot the excitatory neuron:
% subplot( 3, 1, 2 );
% plot( ts, squeeze( ys( 1, 2, : ) ) );
% ylabel( 'Excitatory stimulus' );
% 
% % Plot the inhibitory neuron:
% subplot( 3, 1, 3 );
% plot( ts, squeeze( ys( 1, 3, : ) ) );
% ylabel( 'Inhibitory Stimulus' ); 