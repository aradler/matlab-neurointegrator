function dydt = memory_neuron( t, y, ext_y, tau )
	ext_y = squeeze( ext_y );
	I_intrinsic = intrinsic_current( y(1), y(2), y(3), y(4) );

	W = 1.882;
	W_e = 1;
	W_i = 4;
	W_0 = 3.8;
	
	V_e = 0;
	V_i = -70;
		
	alpha = 1; % to make the effects of synaptic saturation weak, pg 174
	% tau_0 = 100;
	% tau_burst = 5;
	
	% Sigmoid, as defined in the paper:
	theta_s = -20; % mV, pg 174
	sigma_s = 2; % mV, pg 174
	
	% dsdt = (alpha .* (1 - y(5)) .* 1./(1 + exp(-(y(1)-theta_s)./sigma_s)) - y(5)) ./ tau;
	dsdt = (alpha * (1-y(5)) * 1/(1 + exp(-(y(1)-theta_s)/sigma_s)) - y(5)) / tau;
	g_E = W * y(5) + W_0 * ext_y(5, 1) + W_e * ext_y(5, 2);
	g_I = W_i * ext_y(5, 3);
	
	% Intrinsic currents:
	dydt = I_intrinsic;
	% Excitatory conductance:
	dydt = dydt - [g_E .* ( y(1) - V_e ); 0; 0; 0];
	% Inhibitory conductance:
	dydt = dydt - [g_I .* ( y(1) - V_i ); 0; 0; 0];
	
	% Add the integral term on the end
	dydt = [ dydt; dsdt ];
end