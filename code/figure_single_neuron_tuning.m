clear variables;
close all;
clc;

ext = @( t ) t / 1000.0;

% Initialize the time vector:
len = 5000; % milliseconds
dt = 0.005; % milliseconds
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

subplot( 2, 1, 1 );
plot( ts, ext( ts ), 'r' );
ylabel( 'Applied Current (uA/cm^2)' );

subplot( 2, 1, 2 )
plot( ts, ys( 1, : ) );
ylabel( 'Neuron potential (mV)' );

% subplot( 4, 1, 4 );
% plot( ts, ys(2:4, : ) )
% ylabel( 'Conductance of different ion channels' )
% legend( 'Sodium conductance', ...
% 		'Delayed rectifier potassium conductance', ...
% 		'A-type potassium conductance' );
xlabel( 'Time (milliseconds)' );

% Plotting export and configuration:
set(gcf, 'Units', 'Inches', 'Position', [0.125, 0.125, 5.875, 5.875], 'PaperUnits', 'Inches', 'PaperSize', [6, 6]);
saveas(gcf, '../figures/single_neuron_tuning.pdf');
saveas(gcf, '../figures/single_neuron_tuning.png');


