function y = leak_current( V )
    g_L = 0.2;
    V_L = -65;
    y = g_L * ( V - V_L );
end