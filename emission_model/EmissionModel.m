function emissions = EmissionModel(p, Q, gamma_1, gamma_2, opts)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% p:            traffic density of each road over time
% Q:            cell where Q{e} is the flux function of road e
% gamma_1,
%   gamma_2:    parameters of the emission model which estimates the
%               produces emissions based on the the traffic density and 
%               flux: gamma_1 * p + gamma_2 * Q(p)
%
% opts defines the properties of the grid sizes of the numerical schemes:
% N_lwr:    number of grid points of the discrete roads
% Nt:       number of grid points of the temporal grid
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
num_roads = size(p, 1);

emissions = zeros(num_roads, opts.N_lwr, opts.Nt + 1);

for e = 1:num_roads
    emissions(e, :, :) = gamma_1 * p(e, :, :) ...
        + gamma_2 * Q{e}(p(e, :, :));  
end
end