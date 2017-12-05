function [y, dndt] = delayed_rectifier_potassium_current( V, n )
	g_K = 40;
	V_K = -80;
	phi_n = 10;
	
	alpha_n = ((V + 34) / 100) / (1 - exp(-(V + 34) / 10 ) );
	beta_n  = 0.125 * exp( -(V + 44) / 80 );
	
	dndt = phi_n * (alpha_n * (1-n) - beta_n * n);
	
	y = g_K * n.^4 * (V - V_K);
end