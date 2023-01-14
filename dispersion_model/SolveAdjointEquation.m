function w = SolveAdjointEquation(parameters, opts, varargin)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% parameters defines the coefficents of the advection diffusion equation
% and has to contain:
% L:        length of the region omega in x and y direction
% mu:       diffusion coefficient; assumed to be constant
% kappa:    reaction coefficient; assumed to be constant
% v:        a vector which describes a two-dimensional wind field
%           WARNING: v is rotated by 180°
%
% varargin is a optional input parameters which encodes the edges where
% Neumann or Robin boundary conditions are imposed:
% varargin{1}:  neumann_boundary which is a vector of string; possible
%               options are "north", "east", "south", "west".
% If no values are provided the boundary is computed according to problem.v
%
% opts defines the properties of the numerical scheme
% N_dispersion, Nt: number of spacial/temporal cells in one direction,
% dx, dt:           step sizes which are consistent with N_dispersion, Nt
% T:                final time 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
if length(varargin) == 1
    neumann_boundary = varargin{1};
else
    neumann_boundary = ComputeOutflowBoundary(parameters.v);
end

parameters.w0 = 0;
parameters.v = -parameters.v;
parameters.source = 1 / (opts.T * parameters.L * parameters.L);

parameters.backwards_in_time = true;
parameters.robin = true;

w = SolveAdvectionDiffusionEquation(parameters, opts, neumann_boundary);

end