function [ts, ys, ys_mem] = memory_neuron_sim( len, dt, ext )
    % Initialize the time vector:
    ts = 0:dt:len;

    % Initialize the solutions vector ( [V, h, n, b] )
    ys = zeros( 5, 3, length( ts ) );

    % Initial condition from the paper
    ys(:, :, 1) = [
        -68.3737, 0.9820, 0.0631, 0.1259, 0
        -68.3737, 0.9820, 0.0631, 0.1259, 0
        -68.3737, 0.9820, 0.0631, 0.1259, 0 ]';

    ys_mem = zeros( 5, length( ts ) );
    % ys_mem( :, 1 ) = [ -68.3737, 0.9820, 0.0631, 0.1259, 0 ]';

    tau_t = 100; % milliseconds
    tau_b = 5;   % milliseconds

    % RK45 it on out
    for n = 1:(length( ts )-1)
        % ys is a 3-dimensional array whose dimensions are
        % [V/h/n/b/s, neuron (tonic/excit/inhib), time]
        k1 = TEI_neurons(ts(n), ys(:, :, n), ext( ts(n) ), tau_t, tau_b );
        k2 = TEI_neurons(ts(n) + dt/2, ys(:, :, n) + dt/2 * k1, ext(ts(n)), tau_t, tau_b);
        k3 = TEI_neurons(ts(n) + dt/2, ys(:, :, n) + dt/2 * k2, ext(ts(n)), tau_t, tau_b);
        k4 = TEI_neurons(ts(n) + dt, ys(:, :, n) + dt * k3, ext(ts(n)), tau_t, tau_b);
        ys(:, :, n+1) = ys(:, :, n) + (dt / 6 .* (k1 + 2*k2 + 2*k3 + k4));

        k1_mem = memory_neuron(ts(n), ys_mem(:, n), ys(:, :, n), tau_t );
        k2_mem = memory_neuron(ts(n) + dt/2, ys_mem( :, n ) + dt/2 * k1, ys(:, :, n), tau_t);
        k3_mem = memory_neuron(ts(n) + dt/2, ys_mem( :, n ) + dt/2 * k2, ys(:, :, n), tau_t);
        k4_mem = memory_neuron(ts(n) + dt, ys_mem( :, n ) + dt * k3, ys(:, :, n), tau_t);
        ys_mem(:, n+1) = ys_mem(:, n) + (dt / 6 .* (k1_mem + 2*k2_mem + 2*k3_mem + k4_mem));

    end

end