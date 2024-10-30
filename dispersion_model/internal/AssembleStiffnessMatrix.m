function [A_diff, A_adv] = AssembleStiffnessMatrix(parameters, opts, ...
    neumann_boundary, robin_boundary)
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
% robin_boundary:    vector of strings; possible options are "north", 
%                    "east", "south", "west", determines the edges where we
%                    impose Robin boundary conditions.
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

% include Robin boundaries
for edge = robin_boundary
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

%M = N_x * N_y;

% E_x and E_y have non-zero elements at the first lower subdiagonal
E_x = sparse(2:N_x, 1:N_x-1, 1, N_x, N_x);
E_y = sparse(2:N_y, 1:N_y-1, 1, N_y, N_y);

%%%%%%  upwind scheme for advection part %%%%%
v_x = parameters.v(1);
v_y = parameters.v(2);
A_x = abs(v_x) * speye(N_x) + min(v_x, 0) * E_x' - max(v_x, 0) * E_x; 
A_y = abs(v_y) * speye(N_y) + min(v_y, 0) * E_y' - max(v_y, 0) * E_y;

% computes (v_x, v_y) * outernormal for a square domain
c_N = v_y; %parameters.v(1);
c_E = v_x; %parameters.v(2);
c_S = - c_N;
c_W = - c_E;

mu = parameters.mu;

%%% Check the computation of gamma and the derivation of this
%%% discretization!!!!!
for edge = robin_boundary
    switch edge
        case "north"
            gamma = (mu + opts.dx * c_N) / (mu - opts.dx * c_N);
            A_y(end, end-1) = min(v_y, 0) * gamma - max(v_y, 0);
        case "south"
            gamma = (mu + opts.dx * c_S) / (mu - opts.dx * c_S);
            A_y(1,2) = min(v_y,0) - gamma * max(v_y,0);
        case "east"
            gamma = (mu + opts.dx * c_E) / (mu - opts.dx * c_E);
            A_x(end, end-1) = min(v_x, 0) * gamma - max(v_x, 0);
        case "west"
            gamma = (mu + opts.dx * c_W) / (mu - opts.dx * c_W);
            A_x(1,2) = min(v_x, 0) - gamma * max(v_x,0);
    end
end


for edge = neumann_boundary %setdiff(neumann_boundary, robin_boundary)
    switch edge
        case "north"
            A_y(end, end-1) = min(v_y, 0) - max(v_y, 0);
        case "south"
            A_y(1,2) = min(v_y,0) - max(v_y,0);
        case "east"
            A_x(end, end-1) = min(v_x, 0) - max(v_x, 0);
        case "west"
            A_x(1,2) = min(v_x, 0) - max(v_x,0);
    end
end

A_adv = kron(speye(N_y), A_x) + kron(A_y, speye(N_x));
A_adv = (1 / opts.dx) * A_adv;


%%%%%% Laplace Operator %%%%%%%%%%%
clear A_x A_y;
A_x = E_x + E_x' - 2 * speye(N_x);
A_y = E_y + E_y' - 2 * speye(N_y);

for edge = robin_boundary
    switch edge
        case "north"
            gamma = (mu + opts.dx * c_N) / (mu - opts.dx * c_N);
            A_y(end, end-1) = 1 + gamma;
        case "south"
            gamma = (mu + opts.dx * c_S) / (mu - opts.dx * c_S);
            A_y(1,2) = 1 + gamma;
        case "east"
            gamma = (mu + opts.dx * c_E) / (mu - opts.dx * c_E);
            A_x(end, end-1) = 1 + gamma;
        case "west"
            gamma = (mu + opts.dx * c_W) / (mu - opts.dx * c_W);
            A_x(1,2) = 1 + gamma;
    end
end

for edge = neumann_boundary %setdiff(neumann_boundary, robin_boundary)
    switch edge
        case "north"
            A_y(end, end-1) = 2;
        case "south"
            A_y(1,2) = 2;
        case "east"
            A_x(end, end-1) = 2;
        case "west"
            A_x(1,2) = 2;
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