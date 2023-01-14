function p = FVStep(dx, dt, p_k, flow, num_flux)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% dx, dt:       spacial and tempral step size respectively
% p_k:          vector that contains the numerical density at the current 
%               time step; only contains the density for a SINGLE road, not
%               all roads simultaneously
% flow:         vector where flow(1) is the inflow at the road at x = 0 and
%               flow(2) ia the outflow at the road at x = L
% num_flux:     function handle that computes the numerical flux at the
%               boundary of the spacial cells based on the density of the 
%               two neighbouring cells
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
    p = zeros(size(p_k));

    Q_outflow = num_flux(p_k(2:end-1), p_k(3:end), dx, dt);
    Q_inflow = num_flux(p_k(1:end-2), p_k(2:end-1), dx, dt);

    p(2:end-1) = p_k(2:end-1) - dt/dx * (Q_outflow - Q_inflow);
    
    p(1) = p_k(1) - dt/dx * (num_flux(p_k(1), p_k(2), dx, dt) - flow(1));
    p(end) = p_k(end) - dt/dx * (flow(2) ...
        - num_flux(p_k(end-1), p_k(end), dx, dt));

end