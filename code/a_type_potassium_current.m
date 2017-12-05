function [y, dbdt] = a_type_potassium_current( V, b )
	g_A = 20;
	tau_b = 20;
	V_K = -80;
	
	a_inf = 1 / (exp(-(V + 50) / 20 ) + 1);
	b_inf = 1 / (exp((V + 80) /6 ) + 1);
	
	dbdt = (b_inf - b) / tau_b;
	y = g_A * a_inf.^3 * b * ( V - V_K );
end