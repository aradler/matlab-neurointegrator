function y = intrinsic_current( V, h, n, b )
	Cm = 1;
	I_L = leak_current( V );
    [I_Na, dhdt] = sodium_current( V, h );
	[I_K, dndt]  = delayed_rectifier_potassium_current( V, n );
	[I_A, dbdt]  = a_type_potassium_current( V, b );
    I_int = I_L + I_Na + I_K + I_A;
	dVdt = -I_int / Cm;
	
	y = [dVdt, dhdt, dndt, dbdt]';
end