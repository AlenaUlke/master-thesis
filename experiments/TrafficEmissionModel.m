function [concentration, pp, emission2d, xx, tt] = TrafficEmissionModel(Vmax)
[traffic, junctions, dispersion, emission, opts] ...
    = InitializeModels;

traffic.Vmax = Vmax;

[pp, ~, ~, fun] = SolveLWRModel(traffic, junctions, opts);

emission_on_roads = EmissionModel(pp, fun.Q, emission.gamma_1, ...
    emission.gamma_2, opts);

emission2d = EmissionInControlDomain(emission_on_roads, ...
    emission, opts);

dispersion.source = emission2d;
dispersion.type_inflow_boundary = "Robin";
dispersion.type_outflow_boundary = "Neumann";
concentration = SolveAdvectionDiffusionEquation(dispersion, opts);

xx = 0:opts.dx:dispersion.L;
tt = 0:opts.dt:opts.T;
end