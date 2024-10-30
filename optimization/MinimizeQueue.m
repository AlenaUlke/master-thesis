function [J_queue, V_queue] ...
    = MinimizeQueue(traffic_model, junctions, emission_model, opts, V_lower, V_upper)

% used a random vector as inital guess because midpoint leads to local
% minimum -> fmincon is stuck even though better local minima exist
N = length(V_upper);
V0 = (V_upper - V_lower) .* rand(N,1) + V_lower;

% Solve multiobjective problem aka compute Pareto front
%options = optimoptions('fmincon');
[V_queue, J_queue] = fmincon(@Queue, V0, [], [], [], [], V_lower, V_upper);

    function val = Queue(V)
        traffic_model.Vmax(1:N) = V(1:N);

        [~, queue, ~, ~] = SolveLWRModel(traffic_model, junctions, opts);

        val =  emission_model.gamma_3 * opts.dt ...
             * sum(queue(:, 2:end), 'all') / (opts.T);
    end
end