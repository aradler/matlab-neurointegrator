function dydt = neuron( t, y, ext, tau )
	I_intrinsic = intrinsic_current( y(1), y(2), y(3), y(4) );
	dydt = I_intrinsic + [ext; 0; 0; 0];

	
	alpha = 1; % to make the effects of synaptic saturation weak, pg 174
	% tau_0 = 100;
	% tau_burst = 5;
	
	% Sigmoid, as defined in the paper:
	theta_s = -20; % mV, pg 174
	sigma_s = 2; % mV, pg 174
	
	s = (alpha .* (1 - y(5)) .* 1./(1 + exp(-(y(1)-theta_s)./sigma_s)) - y(5)) ./ tau;
	dydt = [ dydt; s ];
end