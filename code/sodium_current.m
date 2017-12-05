function [y, dhdt] = sodium_current( V, h )
	g_Na = 100;
	V_Na = 55;
	phi_h = 10;
	
	
	alpha_m = ((V + 30) / 10) / (1 - exp(-(V + 30) / 10));
	beta_m  = 4 * exp( -(V + 55) / 18 );
	
	m_inf = alpha_m / (alpha_m + beta_m);
	
	alpha_h = 0.07 * exp(-(V + 44) / 20);
	beta_h  = 1 / (exp(-(V + 14) / 10) + 1);
	dhdt = phi_h * ( alpha_h * (1 - h) - beta_h * h );
	
	y = g_Na * m_inf.^3 * h * (V - V_Na);
end