function [V_pareto, F_pareto] = ParetoFrontFlowDiffQueue(traffic_model, ...
    junctions, emission_model, dispersion_model, opts, V_lower, V_upper)

% used a random vector as inital guess because midpoint leads to local
% minimum -> fmincon is stuck even though better local minima exist
N = length(V_upper);
%x0 = (V_upper -  V_lower) .* rand(N, 1) + V_lower;

% Solve the adjoint equation once zto compute average conentration of
% pollutant in control are without solving the dispersion model whenever
% the speed limits are adapted!
g = SolveAdjointEquation(dispersion_model, opts);

% % Solve the singelobejctive problems to obtain ideal vector
% [V_queue, F_queue] = fmincon(@QueueLength, x0, [], [], [], [], ...
%     V_lower, V_upper)
% 
% [V_diff, F_diff] = fmincon(@AveragePollutant, x0, [], [], [], [], ...
%     V_lower, V_upper)

% Solve multiobjective problem aka compute Pareto front
options = optimoptions('paretosearch', 'ParetoSetSize', 160);
[V_pareto, F_pareto] = paretosearch(@FusedObjectives, N, [], [], [], [], ...
    V_lower, V_upper, [], options);


% Definition of the cost functionals    
    function val = FusedObjectives(V)
        traffic_model.Vmax(1:N) = V(1:N);

        [pp, queue, ~, fun] = SolveLWRModel(traffic_model, junctions, opts);

        qq = zeros(size(pp));
        for e = 1:traffic_model.num_roads
            qq(e,:,:) = fun.Q{e}(pp(e,:,:));
        end
        
        emission_on_roads = EmissionModel(pp, fun.Q, emission_model.gamma_1, ...
            emission_model.gamma_2, opts);
        emission2d = EmissionInControlDomain(emission_on_roads, ...
            emission_model, opts);
        
        tmp = emission2d .* g;
        average_emissions =  opts.dx^2 * opts.dt * sum(tmp(2:end,2:end,2:end), 'all');   
        flux = opts.dt * opts.dx * sum(qq(:, :, 2:end), 'all');
        average_idle_traffic = opts.dt * sum(queue(2:end), 'all') / opts.T;

        val = [-flux; average_emissions; average_idle_traffic];
    end
end