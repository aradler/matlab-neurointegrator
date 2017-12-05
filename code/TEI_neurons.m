function dydt = TEI_neurons( t, y, ext, tau_tonic, tau_burst )
	dydt = [
		neuron( t, y(:, 1), ext(1), tau_tonic )';
		neuron( t, y(:, 2), ext(2), tau_burst )';
		neuron( t, y(:, 3), ext(3), tau_burst )';
		]';
end