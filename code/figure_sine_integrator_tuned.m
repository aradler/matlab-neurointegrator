clear variables;
close all;
clc;

% Define our input function. For this example, we will be integrating a
% sine function with a relatively reasonable amplitude (0.2 ) and a period
% slow enough (4 seconds) that the neuron is not overwhelmed. 
in_func = @(t) sin( t * pi / 2000 );

% Tonic external current. The applied current is 3 uA/cm^2
ext_T = @( t ) 3;

% Excitatory external current. For this figure, this will be the positive
% half of the input sine wave.
ext_E = @( t ) max( in_func(t), 0 ) + 1.9;
% Inhibitory external current. This will be the negative half of the
% applied current
ext_I = @( t ) -min( in_func(t), 0 ) + 1.9;

ext = @( t ) [ ext_T(t) ext_E(t) ext_I(t) ];

[ts, ys, ys_mem] = memory_neuron_sim( 6000, 0.001, ext ); 

save( '../data/sine_integrator_tuned', 'ts', 'ys', 'ys_mem' );

%% Plotting:

subplots_x = 5;
subplots_y = 2;

% Plot the input function:
subplot( subplots_x, subplots_y, [1 2] );
plot( ts, in_func( ts ), 'r' );
ylabel( 'Input Function', 'FontSize', 8 );
title( 'Tuned memory neuron integrating a sine function' );

%
% Excitatory:
%

% Plot the excitatory neuron:
subplot( subplots_x, subplots_y, 3 );
plot( ts, squeeze( ys( 1, 2, : ) ) );
ylabel( {'Excitatory neuron','potential (mV)'}, 'FontSize', 7 );

% Plot the excitatory neuron current:
subplot( subplots_x, subplots_y, 4 );
plot( ts, ext_E( ts ), 'r' );
ylabel( {'Excitatory neuron','current (uA/cm^2)'}, 'FontSize', 7 );

%
% Inhibitory:
%

% Plot the inhibitory neuron:
subplot( subplots_x, subplots_y, 5 );
plot( ts, squeeze( ys( 1, 3, : ) ) );
ylabel( {'Inhibitory neuron','potential (mV)'}, 'FontSize', 7 ); 

% Plot the inhibitory neuron current:
subplot( subplots_x, subplots_y, 6 );
plot( ts, ext_I( ts ), 'r' );
ylabel( {'Inhibitory neuron','current (uA/cm^2)'}, 'FontSize', 7 );

%
% Memory:
%

% Plot the memory neuron:
subplot( subplots_x, subplots_y, [7 8] );
plot( ts, ys_mem( 1, : ) );
ylabel( {'Memory neuron','potential (mV)'}, 'FontSize', 7 ); 

% Plot the memory neuron:
subplot( subplots_x, subplots_y, [9 10] );
plot( ts, spike_rate(ys_mem( 1, : ), ts) );
ylabel( {'Memory neuron','spiking rate (Hz)'}, 'FontSize', 7 ); 
xlabel( 'Time (milliseconds)' ); 

% Plotting export and configuration:
set(gcf, 'Units', 'Inches', 'Position', [0.125, 0.125, 5.875, 5.875], 'PaperUnits', 'Inches', 'PaperSize', [6, 6]);
saveas(gcf, '../figures/memory-sine-tuned.pdf');
saveas(gcf, '../figures/memory-sine-tuned.png');