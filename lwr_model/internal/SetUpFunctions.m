function [fun] = SetUpFunctions(parameters, numerical_scheme)
for i = 1:parameters.num_roads
    fun.Q{i} = @(p) parameters.Vmax(i) * p .* (1 - p / parameters.pmax(i));
    fun.V{i} = @(p) parameters.Vmax(i) * (1 - p / parameters.pmax(i));

    DQ = @(p) parameters.Vmax(i) * (1 - 2 * p / parameters.pmax(i));
    fun.DQ_max{i} = @(p) max(abs(DQ(p)));

    fun.D{i} = @(p) (p <= parameters.pc(i)) .* fun.Q{i}(p) ...
    + (p > parameters.pc(i)) .* fun.Q{i}(parameters.pc(i));
    fun.S{i} = @(p) (p >= parameters.pc(i)) .* fun.Q{i}(p) ...
        + (p < parameters.pc(i)) .* fun.Q{i}(parameters.pc(i));

    switch numerical_scheme
        case "supply_demand"
            % supply and demand method
            fun.num_flux{i} = @(u, v, dx, dt) min(fun.D{i}(u), fun.S{i}(v));
        case "staggeredLF"
            % staggered Lax-Friedrich method
            fun.num_flux{i} = @(u, v, dx, dt) 0.25 * dx / dt * (u - v) ...
                + 0.5 * (fun.Q{i}(u) + fun.Q{i}(v));
        case "LF"
            fun.num_flux{i} = @(u, v, dx, dt) 0.5 * dx / dt * (u - v) ...
                + 0.5 * (fun.Q{i}(u) + fun.Q{i}(v));
    end
end
end

