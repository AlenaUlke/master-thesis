function w = SolveAdvectionDiffusionEquation(parameters, opts, varargin)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% parameters defines the coefficents of the advection diffusion equation
% and has to contain:
% L:        length of the region omega in x and y direction
% mu:       diffusion coefficient; assumed to be constant
% kappa:    reaction coefficient; assumed to be constant
% v:        a vector which describes a two-dimensional wind field        
% source:   source term of the PDE already evaluated at the grid
% w0:       function handle or scalar if inital data is constant 
% robin_conidtion:      bool which encodes if at the outflow boundary Robin
%                       or Neumann boundary conditions are imposed
% backwards_in_time:    bool which encodes wether the PDE is solved
%                       forwards or backwards in time; if backwards the 
%                       initial condition becomes a final condition
%
% varargin is a optional input parameters which encodes the edges where
% Neumann or Robin boundary conditions are imposed:
% varargin{1}:  neumann_boundary which is a vector of string; possible
%               options are "north", "east", "south", "west".
% If no values are provided the boundary is computed according to problem.v
%
% opts defines the properties of the numerical scheme
% N_dispersion, Nt: number of spacial/temporal cells in one direction,
% dx, dt:   step sizes which are consistent with N_dispersion, Nt
% T:        final time 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

dx = opts.dx;
xx = 0:dx:parameters.L;

% x-direction x y-direction x time
w = zeros(opts.N_dispersion + 1, opts.N_dispersion + 1, opts.Nt+1);
if isa(parameters.w0, 'function_handle')
    for i=1:opts.N+1
        for j=1:opts.N+1
            w(i,j,1) = parameters.w0(xx(i), xx(j));
        end
    end
else
    w(:,:,1) = parameters.w0;
end

if(length(varargin) == 1)
    neumann_boundary = varargin{1};
else
    neumann_boundary = ComputeOutflowBoundary(parameters.v);
end

% Stiffness matrix and source term
[A_diff, A_adv] = AssembleStiffnessMatrix(parameters, opts, neumann_boundary);

% ranges of coordinates for homogeneous Dirichlet data 
x_range = 2:opts.N_dispersion;
y_range = 2:opts.N_dispersion;

for edge = neumann_boundary
    switch edge
        case "north"
            y_range = [y_range opts.N_dispersion + 1];
        case "south"
            y_range = [1 y_range];
        case "east"
            x_range = [x_range opts.N_dispersion + 1];
        case "west"
            x_range = [1 x_range];
    end
end

N_x = length(x_range);
N_y = length(y_range);

I = eye(N_x * N_y);
if opts.implicit
    A_expl = I - opts.dt * A_adv;
    A_impl = I - opts.dt * A_diff;
else
    A_expl = I - opts.dt * A_adv + opts.dt * A_diff;
    A_impl = I;
end

for k = 1:opts.Nt
    % solution at the current time step t(k)
    w_k = w(x_range, y_range, k);

    % reshape w_k into a vector (column major order)
    w_loc = w_k(:);

    % Compute solution at the next time step
    if isscalar(parameters.source)
        w_loc = (A_expl  * w_loc) + opts.dt * parameters.source;
    else
        source_k = parameters.source(x_range, y_range, k);
        sourcetmp = source_k(:);
        w_loc = (A_expl * w_loc) + opts.dt * sourcetmp;
    end

    if opts.implicit
        w_loc = A_impl \ w_loc;
    end

    % reshape the solution into a matrix to match the grid
    w(x_range, y_range, k+1) = reshape(w_loc, [N_x, N_y]);
end

if parameters.backwards_in_time
    w = flip(w, 3);
end
end