clear variables;
close all;
clc;

% define the heaviside because for some reason MATLAB only has it
% in the symbolic math toolbox
heaviside = @(x) double(x > 0);

ext = @( t ) 3 * (heaviside( t-100 ) - heaviside( t-500 )); 

% Initialize the time vector:
len = 1000; % milliseconds
dt = 0.01; % milliseconds
ts = 0:dt:len;

% Initialize the solutions vector ( [V, h, n, b] )
ys = zeros( 5, length( ts ) );

% Initial condition from the paper
ys(:, 1) = [-68.3737, 0.9820, 0.0631, 0.1259, 0]';

tau_tonic = 100;
tau_burst = 5;
% RK45 it on out
for n = 1:(length( ts )-1)
	k1 = neuron(ts(n), ys(:, n), ext( ts(n) ), tau_tonic );
	k2 = neuron(ts(n) + dt/2, ys(:, n) + dt/2 * k1, ext(ts(n)), tau_tonic );
	k3 = neuron(ts(n) + dt/2, ys(:, n) + dt/2 * k2, ext(ts(n)), tau_tonic );
	k4 = neuron(ts(n) + dt, ys(:, n) + dt * k3, ext(ts(n)), tau_tonic );
	ys(:, n+1) = ys(:, n) + (dt / 6 .* (k1 + 2*k2 + 2*k3 + k4));
end

subplot( 2, 2, 1 );
plot( ts, ext( ts ) );
ylabel( 'Membrane Conductance' );
ylim( [-0.5, 3.5] );

subplot( 2, 2, 2 )
plot( ts, ys( 1, : ) );
ylabel( 'Neuron potential' );

subplot( 2, 2, 3 );
plot( ts, ys( 5, : ) );
ylabel( 'Placeholder for summation' );

subplot( 2, 2, 4 );
plot( ts, ys(2:4, : ) )
ylabel( 'Conductance of different ion channels' )
legend( 'Sodium conductance', ...
		'Delayed rectifier potassium conductance', ...
		'A-type potassium conductance' );
xlabel( 'Time (milliseconds)' );

hold on
