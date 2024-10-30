function [lwr_model, junctions, dispersion_model, emission_model, ...
    opts] = InitializeModels
%% Values of the parameters
T = 5; 
L_road = 1;
road_width = 0.1;
L = 3 * L_road;

% traffic
pmax = [1, 1, 1, 1, 1, 1];
p0 = [0.6, 0.4, 0.9, 0.5, 0.8, 0.3];
Vmax = [1, 0.5, 1, 1, 1, 1];
q_in = 0.25; %Vmax(1) * pmax(1) / 4;

% emission
gamma_1 = 0.5; %8.68; %1e-5; % density
gamma_2 = 1;%1e-6; % flux
gamma_3 = 0.5; % queue gamma_2 = 0.15, gamma_3 = 0.588 -> ratio gamma_3/gamma_2

% dispersion
mu = 1e-6;
v = [1, 1];
kappa = 0.01;  %%%%% kappa = 2;
w0 = 0;

% robin_condition = true;
backwards_in_time = false;

% opts
N_lwr = 20;
N_dispersion = 3 * N_lwr;

% Nt = 50;%200; % dt = T / N_t

% this should satisfy the cfl condition
% for the dispersion model
dx = L_road / N_lwr; 
dt_cfl = (v(1)^2 / (2 * mu + abs(v(1)) * dx) ...
    + v(2)^2 / (2 * mu + abs(v(2)) * dx))^(-1);
dt_cfl = min(dt_cfl, ...
    dx * dx / (4 * mu + norm(v,1) * dx));
Nt =  ceil(3 * T / dt_cfl);
%dt_cfl = T/400;

%% The traffic model 
lwr_model.num_roads = 6;
lwr_model.pmax = pmax;
lwr_model.pc = lwr_model.pmax/2;
lwr_model.Vmax = Vmax;

lwr_model.T = T; 
lwr_model.L_road = L_road;

lwr_model.flux = "greenshield";


for e = 1:lwr_model.num_roads
    p_0{e} = @(x) p0(e) + 0 * x;
end
lwr_model.p0 = p_0;

Q_in = cell(lwr_model.num_roads, 1);
Q_out = cell(lwr_model.num_roads, 1);
Q_in{1} = @(t) q_in * (t < lwr_model.T) + 0*t;
Q_out{6} = "free flow";

lwr_model.Q_in = Q_in;
lwr_model.Q_out = Q_out;
lwr_model.model_queue = true;

junctions{1}.beta = 0.5;
junctions{1}.incoming = [1];
junctions{1}.outgoing = [2, 3];

junctions{2}.incoming = [2];
junctions{2}.outgoing = [4];

junctions{3}.beta = 0.5;
junctions{3}.incoming = [4, 5];
junctions{3}.outgoing = [6];

junctions{4}.incoming = [3];
junctions{4}.outgoing = [5];

% opts involed in traffic model
opts.cfl = 0.9; % cfl for traffic model
opts.T = T;

opts.N_lwr = N_lwr; 
opts.Nt = Nt;

opts.dx = L_road / N_lwr;
opts.dt = T / Nt;
%opts.dt_cfl = dt_cfl;
opts.implicit = false;
opts.numerical_scheme = "supply_demand";
%% The emission model
emission_model.gamma_1 = gamma_1;
emission_model.gamma_2 = gamma_2;
emission_model.gamma_3 = gamma_3;

road2d{1} = @(ll) [ll, opts.N_lwr + 1];
road2d{2} = @(ll) [opts.N_lwr + 1, opts.N_lwr + ll];
road2d{3} = @(ll) [opts.N_lwr + ll, opts.N_lwr + 1];
road2d{4} = @(ll) [2 * opts.N_lwr + 1, opts.N_lwr + ll];
road2d{5} = @(ll) [opts.N_lwr + ll, 2 * opts.N_lwr + 1];
road2d{6} = @(ll) [2 * opts.N_lwr + ll, 2 * opts.N_lwr + 1];

emission_model.road2d = road2d;
emission_model.width = road_width;

opts.N_dispersion = N_dispersion;
%% The dispersion model and the adjoint 
%dispersion_model.robin_condition = robin_condition;
dispersion_model.backwards_in_time = backwards_in_time;

dispersion_model.L = L;
dispersion_model.mu = mu;
dispersion_model.v = v;
dispersion_model.kappa = kappa; 
dispersion_model.w0 = w0;
end