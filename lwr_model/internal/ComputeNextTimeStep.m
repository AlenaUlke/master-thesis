function dt = ComputeNextTimeStep(p, cfl, dx, DQ_max)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% p:        density at a fixed time t, but over the entire spacial domain;
%           has size num_roads x space
% dx:       step size of the spacial grid
% cfl:      the CFL number between  0 and 1
% DQ_max:   cell of function handles which return the absolute maximum of Q'
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
dt = min(dx * cfl / DQ_max{1}(p(1,:)), 0.01);
for i = 2:length(DQ_max)
    dt = min(dt,  dx * cfl / DQ_max{i}(p(i,:)));
end
end