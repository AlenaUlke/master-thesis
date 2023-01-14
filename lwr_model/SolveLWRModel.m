function [p, queue, real_inflow, fun] = SolveLWRModel(parameters, junctions, opts)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% parameters defines the mathematical model and has to contain
% L_road:                length of the road (all roads have the same length)
% p0:               cell with funcation handles where p0{i} describes
%                   intitial density at road i
% num_roads:        number of roads
% Vmax, pmax, pc:   vectors of size #roads -> LWR flux is assumed
% Q_in, Q_out:      cell of length num_roads; if Q_in{e}/Q_out{e} is empty 
%                   the road is an internal in-/outflow road, otherwise it 
%                   contains a function handle modelling the prescribed 
%                   in-/outflow rates
% model_queue:      bool which encodes wheter we model a queue at the free
%                   inflow junctions or not
%
%
% junctions is a cell that stores structs which define the junctions in the
% road network. The structs junctions{i} have to contain
% incoming: incoming roads at the junctions (all roads are enumerated)
% outgoing: outgoing roads at the junctions (all roads are enumerated)
% beta:     scalar which described distribution rates at (1 -> 2) and 
%           (2 -> 1) junctions
%
% opts defines the discretization and has to contain
% T:                final time
% N_lwr:            number of cells of LWR model
% N_t:              number of grid points of the temporal "control" grid
% dx, dt:           spacial and temporal step size (has to be consistent
%                   with numer of grid points)
% cfl:              cfl number
% numerical_scheme:  determines the numerical scheme which is used to solve
%                   the LWR model; can be "supply_demand", "LF" or
%                   "staggeredLF"
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
fun = SetUpFunctions(parameters, opts.numerical_scheme);

inflow_roads = ExternalInflowRoads(parameters.Q_in);
queue = zeros(parameters.num_roads, opts.Nt + 1);
D_queue = cell(parameters.num_roads, 1);

if parameters.model_queue
    for e = inflow_roads
        qmax = fun.Q{e}(parameters.pc(e));
        D_queue{e} = @(t, dt, l) min(parameters.Q_in{e}(t) + l/dt, qmax);
    end
end

dx = opts.dx;
xx = 0:dx:parameters.L_road;
xx = xx(1:end-1) + 0.5 * dx;
tt = 0:opts.dt:opts.T;

% road x space x time
% ensure that p corresponds to average densities of the cell.
p = zeros(parameters.num_roads, opts.N_lwr, opts.Nt + 1);
real_inflow = zeros(1, opts.Nt + 1);
for i = 1:parameters.num_roads
    for k = 1:opts.N_lwr
        p(i, k, 1) = integral(parameters.p0{i}, xx(k) - dx/2, xx(k) + dx/2)/dx;
    end
end

for k = 1:opts.Nt
    t_loc = tt(k);
    p_loc = p(:, :, k);

    if parameters.model_queue
        queue_loc = queue(:, k);
    end

    while t_loc < tt(k+1)
        dt_loc = ComputeNextTimeStep(p_loc, opts.cfl, dx, fun.DQ_max);

        if t_loc + dt_loc > tt(k+1)
            dt_loc = tt(k+1) - t_loc;
        end

        p_loc_tmp = p_loc;

        flow_at_boundaries = FlowAtJunctions(p_loc_tmp, t_loc, ...
            junctions, parameters.Q_in, parameters.Q_out, fun);

        if parameters.model_queue
            % length of the queue at time t = t_loc
            queue_loc_tmp = queue_loc;

            for e = inflow_roads
                external_inflow = min(fun.S{e}(p_loc_tmp(e, 1)), ...
                    D_queue{e}(t_loc, dt_loc, queue_loc_tmp(e)));

                flow_at_boundaries(e, 1) = external_inflow;

                queue_loc(e) = queue_loc_tmp(e) ...
                    + dt_loc * (parameters.Q_in{e}(t_loc) - external_inflow);
            end
        end

        real_inflow_loc = flow_at_boundaries(1, 1);

        for e = 1:parameters.num_roads
            flow = flow_at_boundaries(e, :);
            p_loc(e, :) = FVStep(dx, dt_loc, p_loc_tmp(e, :), ...
                flow, fun.num_flux{e});
        end

        t_loc = t_loc + dt_loc;
    end

    p(:, :, k+1) = p_loc;
    real_inflow(k+1) = real_inflow_loc;

    if parameters.model_queue
        queue(:, k+1) = queue_loc;
    end
end

end