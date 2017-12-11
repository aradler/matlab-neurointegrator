clear variables;
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

[ts, ys, ys_mem] = memory_neuron_sim( 6000, 0.005, ext ); 

% Save the data, because this simulation takes a long time to run:

% save( '../data/simple_integrator', 'ts', 'ys', 'ys_mem' );

%% Plotting:

subplots_x = 5;
subplots_y = 1;
subplots_inc = 1;

% Plot the tonic neuron:
subplot( subplots_x, subplots_y, subplots_inc );
plot( ts, squeeze( ys( 1, 1, : ) ) );
% ylabel( 'Tonic neuron (mV)', 'FontSize', 7 );

title( 'Simple step-based integrator test' );

subplots_inc = subplots_inc + 1;

% % Plot the tonic neuron:
% subplot( subplots_x, 1, 2 );
% plot( ts, squeeze( ys( 5, 1, : ) ) );
% ylabel( 'Tonic integral' );

% Plot the excitatory neuron:
subplot( subplots_x, subplots_y, subplots_inc );
plot( ts, squeeze( ys( 1, 2, : ) ) );
ylabel( 'Tonic, Excitatory, Inhibitory, and Memory neuron potentials (mV)', 'FontSize', 8 );

subplots_inc = subplots_inc + 1;

% % Plot the excitatory neuron:
% subplot( subplots_x, 2, 4 );
% plot( ts, squeeze( ys( 5, 2, : ) ) );
% ylabel( 'Excitatory integral' );

% Plot the inhibitory neuron:
subplot( subplots_x, subplots_y, subplots_inc );
plot( ts, squeeze( ys( 1, 3, : ) ) );
% ylabel( 'Inhibitory neuron (mV)', 'FontSize', 7 ); 

subplots_inc = subplots_inc + 1;

% % Plot the inhibitory neuron:
% subplot( subplots_x, 2, 6 );
% plot( ts, squeeze( ys( 5, 3, : ) ) );
% ylabel( 'Inhibitory Integral' );

% Plot the memory neuron:
subplot( subplots_x, subplots_y, subplots_inc );
plot( ts, ys_mem( 1, : ) );
% ylabel( 'Memory neuron (mV)', 'FontSize', 7 ); 

subplots_inc = subplots_inc + 1;

% Plot the memory neuron spike rate:
subplot( subplots_x, 1, subplots_inc );
plot( ts, spike_rate(ys_mem( 1, : ), ts) );
ylabel( 'Memory neuron spiking rate (Hz)', 'FontSize', 7 ); 
xlabel( 'Time (milliseconds)' ); 

% Plotting export and configuration:
set(gca,'color','none') 
set(gcf, 'Units', 'Inches', 'Position', [0.125, 0.125, 5.875, 5.875], 'PaperUnits', 'Inches', 'PaperSize', [6, 6]);
saveas(gcf, '../figures/fig5.pdf');
saveas(gcf, '../figures/fig5.png');