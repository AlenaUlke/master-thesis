function [A_diff, A_adv] = AssembleStiffnessMatrix(parameters, opts, neumann_boundary)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% parameters defines the coefficents of the advection diffusion equation
% and has to contain:
% mu:       diffusion coefficient; assumed to be constant
% kappa:    reaction coefficient; assumed to be constant
% v:        a vector which describes a two-dimensional wind field
%
% opts defines the properties of the numerical scheme
% N_dispersion, Nt: number of spacial/temporal cells in one direction,
% dx, dt:           step sizes which are consistent with N_dispersion, Nt      
% robin_condition:  bool which encodes if at the outflow boundary Robin or 
%                   Neumann boundary conditions are imposed
%
% neumann_boundary:  vector of strings; possible options are "north", 
%                    "east", "south", "west", determines the edges where we
%                    impose Neumann boundary conditions.

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
N_x = opts.N_dispersion - 1;
N_y = opts.N_dispersion - 1;

for edge = neumann_boundary
    switch edge
        case "north"
            N_y = N_y + 1;
        case "south"
            N_y = N_y + 1;
        case "east"
            N_x = N_x + 1;
        case "west"
            N_x = N_x + 1;
    end
end

M = N_x * N_y;

% E_x and E_y have non-zero elements at the first lower subdiagonal
E_x = sparse(2:N_x, 1:N_x-1, 1, N_x, N_x);
E_y = sparse(2:N_y, 1:N_y-1, 1, N_y, N_y);

% upwind scheme for advection part
v_x = parameters.v(1);
v_y = parameters.v(2);
A_x = abs(v_x) * speye(N_x) + min(v_x, 0) * E_x' - max(v_x, 0) * E_x; 
A_y = abs(v_y) * speye(N_y) + min(v_y, 0) * E_y' - max(v_y, 0) * E_y;

if parameters.robin_condition
    c_N = parameters.v(1);
    c_E = parameters.v(2);

    c_1 = parameters.mu;
else % free flow at Neumann/Robin boundary
    c_N = 0;
    c_E = 0;

    c_1 = 1;
end

c_S = - c_N;
c_W = - c_E;

for edge = neumann_boundary
    switch edge
        case "north"
            gamma = (c_1 - opts.dx * c_N) / (c_1 + opts.dx * c_N);
            A_y(end, end-1) = min(v_y, 0) * gamma - max(v_y, 0);
        case "south"
            gamma = (c_1 - opts.dx * c_S) / (c_1 + opts.dx * c_S);
            A_y(1,2) = min(v_y,0) - gamma * max(v_y,0);
        case "east"
            gamma = (c_1 - opts.dx * c_E) / (c_1 + opts.dx * c_E);
            A_x(end, end-1) = min(v_x, 0) * gamma - max(v_x, 0);
        case "west"
            gamma = (c_1 - opts.dx * c_W) / (c_1 + opts.dx * c_W);
            A_x(1,2) = min(v_x, 0) - gamma * max(v_x,0);
    end
end

A_adv = kron(speye(N_y), A_x) + kron(A_y, speye(N_x));
A_adv = (1 / opts.dx) * A_adv;

clear A_x A_y;
A_x = E_x + E_x' - 2 * speye(N_x);
A_y = E_y + E_y' - 2 * speye(N_y);

for edge = neumann_boundary
    switch edge
        case "north"
            gamma = (c_1 - opts.dx * c_N) / (c_1 + opts.dx * c_N);
            A_y(end, end-1) = 1 + gamma;
        case "south"
            gamma = (c_1 - opts.dx * c_S) / (c_1 + opts.dx * c_S);
            A_y(1,2) = 1 + gamma;
        case "east"
            gamma = (c_1 - opts.dx * c_E) / (c_1 + opts.dx * c_E);
            A_x(end, end-1) = 1 + gamma;
        case "west"
            gamma = (c_1 - opts.dx * c_W) / (c_1 + opts.dx * c_W);
            A_x(1,2) = 1 + gamma;
    end
end

A_diff = kron(speye(N_y), A_x) + kron(A_y, speye(N_x));
A_diff = (parameters.mu / opts.dx^2) * A_diff;


% assemble the stiffness matrices
%theta = 0;
% A_expl = speye(M) - (opts.dt / opts.dx) * A_adv ...
%     + theta * (opts.dt / opts.dx^2) * parameters.mu * A_diff;
% A_impl = speye(M) - (1 - theta) * (opts.dt / opts.dx^2) * parameters.mu * A_diff;

end