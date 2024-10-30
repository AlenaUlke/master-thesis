function [emission] = EmissionInControlDomain(emission_on_roads, emission_model, opts)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% emission_on_roads:    tensor of size #roads x N_lwr x Nt, contains
%                       estimated emissions for each road
%
% emission_model is a struct with parameters:
% road2d:               curves that parameterize the roads in the
%                       two-dimensional domain
% width:                width of the roads, is the small for all roads
%
% opts defines the properties of the numerical scheme
% N_dispersion, 
%       N_lwr, Nt:  number of spacial/temporal cells in one direction,
% dx, dt:           step sizes which are consistent with N_dispersion, Nt
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
emission = zeros(opts.N_dispersion + 1, opts.N_dispersion + 1, opts.Nt + 1);
road_counter = zeros(opts.N_dispersion + 1, opts.N_dispersion + 1, opts.Nt + 1);

road2d = emission_model.road2d;
width = emission_model.width;

for e = 1:size(emission_on_roads,1)
    [b_min, b_max, axis] = ParallelAxisAndRoadBorder(road2d{e}, width, opts.dx);
    b_range = b_max - b_min + 1;

    % distribute emissions on the line to the entire width of the road
    real_road_width = (b_range - 1) * opts.dx;
    distributed_emission = squeeze(emission_on_roads(e, :, :)) / real_road_width;

    for n = 1:opts.N_lwr
        position = road2d{e}(n);
        emission_tmp = kron(distributed_emission(n,:), ones(b_range,1));
        

        if axis == 1
            %size(squeeze(emission(position(1),b_min:b_max,:)))
            %size(emission_tmp')
            emission(position(1),b_min:b_max,:) ...
                = squeeze(emission(position(1),b_min:b_max,:)) + emission_tmp;
            road_counter(position(1),b_min:b_max,:) ...
                = road_counter(position(1),b_min:b_max,:) + 1;
        else
            emission(b_min:b_max,position(2),:) ...
                = squeeze(emission(b_min:b_max,position(2),:)) + emission_tmp;
            road_counter(b_min:b_max,position(2),:) ...
                = road_counter(b_min:b_max,position(2),:) + 1;
        end
    end
end

% replace 0 in road_counter by 1 for numerical purposes
no_roads = find(road_counter == 0);
road_counter(no_roads) = 1;

emission = emission ./ road_counter;

end