function [J_eco, V_eco, J_ecoqueue, V_ecoqueue, J_flow, V_flow] ...
    = IndividualOptimization(traffic_model, junctions, emission_model, ...
    dispersion_model, opts, V_lower, V_upper)

% used a random vector as inital guess because midpoint leads to local
% minimum -> fmincon is stuck even though better local minima exist
N = length(V_upper);
V0 = (V_upper - V_lower) .* rand(N,1) + V_lower;

% Solve the adjoint equation once zto compute average conentration of
% pollutant in control are without solving the dispersion model whenever
% the speed limits are adapted!
g = SolveAdjointEquation(dispersion_model, opts);

% Solve multiobjective problem aka compute Pareto front
%options = optimoptions('fmincon');
[V_eco, J_eco] = fmincon(@Eco, V0, [], [], [], [], V_lower, V_upper);
[V_ecoqueue, J_ecoqueue] = fmincon(@EcoQueue, V0, [], [], [], [], ...
    V_lower, V_upper);
[V_flow, J_flow] = fmincon(@Flow, V0, [], [], [], [], V_lower, V_upper);

    function val = Flow(V)
        traffic_model.Vmax(1:N) = V(1:N);

        [pp, ~, ~, fun] = SolveLWRModel(traffic_model, junctions, opts);

        qq = zeros(size(pp));
        for e = 1:traffic_model.num_roads
            qq(e,:,:) = fun.Q{e}(pp(e,:,:));
        end
             
        val = - opts.dt * opts.dx * sum(qq(:, :, 2:end), 'all');
    end

    function val = Eco(V)
        traffic_model.Vmax(1:N) = V(1:N);

        [pp, ~, ~, fun] = SolveLWRModel(traffic_model, junctions, opts);

        emission_on_roads = EmissionModel(pp, fun.Q, emission_model.gamma_1, ...
            emission_model.gamma_2, opts);
        emission2d = EmissionInControlDomain(emission_on_roads, ...
            emission_model, opts);

        qq = zeros(size(pp));
        for e = 1:traffic_model.num_roads
            qq(e,:,:) = fun.Q{e}(pp(e,:,:));
        end
        
        tmp = emission2d .* g;
        val =  opts.dx^2 * opts.dt * sum(tmp(2:end,2:end,2:end), 'all');
    end

    function val = EcoQueue(V)
        traffic_model.Vmax(1:N) = V(1:N);

        [pp, queue, ~, fun] = SolveLWRModel(traffic_model, junctions, opts);

        emission_on_roads = EmissionModel(pp, fun.Q, emission_model.gamma_1, ...
            emission_model.gamma_2, opts);
        emission2d = EmissionInControlDomain(emission_on_roads, ...
            emission_model, opts);

        qq = zeros(size(pp));
        for e = 1:traffic_model.num_roads
            qq(e,:,:) = fun.Q{e}(pp(e,:,:));
        end

        val = opts.dx^2 * opts.dt * sum(emission2d .* g, 'all') ...
            + emission_model.gamma_3 * opts.dt ...
             * sum(queue(:, 2:end), 'all') / (opts.T);
    end
end