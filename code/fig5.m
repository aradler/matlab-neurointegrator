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
dt = 0.02; % milliseconds
ts = 0:dt:len;

% Initialize the solutions vector ( [V, h, n, b] )
ys = zeros( 5, 3, length( ts ) );

% Initial condition from the paper
ys(:, :, 1) = [
	-68.3737, 0.9820, 0.0631, 0.1259, 0
	-68.3737, 0.9820, 0.0631, 0.1259, 0
	-68.3737, 0.9820, 0.0631, 0.1259, 0 ]';

tau_t = 100; % milliseconds
tau_b = 5;   % milliseconds
% RK45 it on out
for n = 1:(length( ts )-1)
	% ys is a 3-dimensional array whose dimensions are
	% [neuron, V/h/n/b, time]
	k1 = TEI_neurons(ts(n), ys(:, :, n), ext( ts(n) ), tau_t, tau_b );
	k2 = TEI_neurons(ts(n) + dt/2, ys(:, :, n) + dt/2 * k1, ext(ts(n)), tau_t, tau_b);
	k3 = TEI_neurons(ts(n) + dt/2, ys(:, :, n) + dt/2 * k2, ext(ts(n)), tau_t, tau_b);
	k4 = TEI_neurons(ts(n) + dt, ys(:, :, n) + dt * k3, ext(ts(n)), tau_t, tau_b);
	ys(:, :, n+1) = ys(:, :, n) + (dt / 6 .* (k1 + 2*k2 + 2*k3 + k4));
end

% Plot the tonic neuron:
subplot( 4, 1, 1 );
plot( ts, squeeze( ys( 1, 1, : ) ) );
ylabel( 'Tonic stimulus' );

% Plot the excitatory neuron:
subplot( 4, 1, 2 );
plot( ts, squeeze( ys( 1, 2, : ) ) );
ylabel( 'Excitatory stimulus' );

% Plot the inhibitory neuron:
subplot( 4, 1, 3 );
plot( ts, squeeze( ys( 1, 3, : ) ) );
ylabel( 'Inhibitory Stimulus' ); 

% Plot the inhibitory neuron:
subplot( 4, 1, 4 );
plot( ts, spike_rate( squeeze( ys( 1, 3, : ) ), ts ) );
ylabel( 'Spike rate' ); 