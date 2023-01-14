function source = ComputeSourceTerm(p, Q, gamma_1, gamma_2, road2d, opts) 
ComputeSourceTerm(p, Q, gamma_1, gamma_2, road2d, opts) 
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% p:            traffic density of each road over time
% Q:            cell where Q{e} is the flux function of road e
% gamma_1,
%   gamma_2:    parameters of the emission model which estimates the
%               produces emissions based on the the traffic density and 
%               flux: gamma_1 * p + gamma_2 * Q(p)
% road2d:       cell of curves which parameterized the road in the 2D domain;
%               maps an index of the discrete road onto an index pair of
%               the discrete two-dimensional control area
%
% opts defines the properties of the grid sizes of the numerical schemes:
% N_lwr:    number of grid points of the discrete roads
% N_adv:    number of grid points in x- and y- direction of the discrete
%           control area; 
% Nt:       number of grid points of the temporal grid
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
num_roads = size(p, 1);

emissions = zeros(num_roads, opts.N_lwr, opts.Nt + 1);
source = zeros(opts.N_adv + 1, opts.N_adv + 1, opts.Nt + 1);

for e = 1:num_roads
    emissions(e, :, :) = gamma_1 * p(e, :, :) ...
        + gamma_2 * Q{e}(p(e, :, :));

    for ll = 1:opts.N_lwr
        grid_point = road2d{e}(ll);  
        source(grid_point(1), grid_point(2), :) =  squeeze(emissions(e, ll, :)) ...
            + squeeze(source(grid_point(1), grid_point(2), :));
    end
end

end