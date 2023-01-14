function flow = FlowAtJunctions(p, t, junctions, Q_in, Q_out, fun)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% p:            matrix of size num_roads x space; representes the densities
%               of each road at time t
% t:            current time step
% junctions:    cell where each entry encodes the type of the junction
% Q_in, 
%   Q_out:      cell of length num_roads; if Q_in{e}/Q_out{e} is empty the 
%               road is an internal in-/outflow road, otherwise it contains 
%               a  function handle modelling the prescribed in-/outflow 
%               rates Q_in{e}(t)/Q_out{e}(t)
% REMARK: Q_out can also be "free flow" in this case we impose free flow at
% the putflow boundary instead of a fixed outflow rate
%
% fun:          struct of functions defining the LWR model on each road
%               where the flux is given by the Greenshield flux; each road
%               is allowed to have different Vmax and pmax
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

% road x 2 -> (e, 1) start of road e and (e, 2) end of road e
num_roads = length(fun.Q);
flow = zeros(num_roads, 2);

for e = 1:num_roads
    % set inflow of external roads according to Q_in{e}
    if ~isempty(Q_in{e})
        flow(e, 1) = min(Q_in{e}(t), fun.S{e}(p(e, 1)));
    end
    
    % outflow is either free flow or given by Q_out{e}
    if ~isempty(Q_out{e})
        if isa(Q_out{e}, 'function_handle')
            flow(e, 2) = min(fun.D{e}(p(e, end)), Q_out{e}(t));
        else
            flow(e, 2) = fun.Q{e}(p(e, end));
        end
    end
end

for e = 1:length(junctions)
    num_incoming_roads = length(junctions{e}.incoming);
    num_outgoing_roads = length(junctions{e}.outgoing);

    if (num_incoming_roads == 1 && num_outgoing_roads == 1)
        % Version 1 (Goatin et al)
        incoming_road = junctions{e}.incoming(1);
        outgoing_road = junctions{e}.outgoing(1);

        flow_tmp = min(fun.D{incoming_road}(p(incoming_road, end)), ...
            fun.S{outgoing_road}(p(outgoing_road, 1)));
        flow(incoming_road, 2) = flow_tmp;
        flow(outgoing_road, 1) = flow_tmp;

    elseif (num_incoming_roads == 1 && num_outgoing_roads == 2)
        alpha = junctions{e}.beta;

        incoming_road = junctions{e}.incoming(1);
        outgoing_road1 = junctions{e}.outgoing(1);
        outgoing_road2 = junctions{e}.outgoing(2);

        c1 = fun.D{incoming_road}(p(incoming_road, end));
        c2 = fun.S{outgoing_road1}(p(outgoing_road1, 1));
        c3 = fun.S{outgoing_road2}(p(outgoing_road2, 1));

        % Version 1 (Goatin et al) -> maximizes flux but violates
        % distribution rates
        inflow1 = min(alpha * c1, c2);
        inflow2 = min((1 - alpha) * c1, c3);
        outflow1 = inflow1 + inflow2;

        % Version 2 (sample solution) -> keeps distribution rates but might
        % not maximize flux
        % outflow1 = min([c1, c2 / alpha, c3 / (1 - alpha)]);
        % inflow1 = alpha * outflow1;
        % inflow2 = (1 - alpha) * outflow1;

        flow(incoming_road, 2) = outflow1;
        flow(outgoing_road1, 1) = inflow1;
        flow(outgoing_road2, 1) = inflow2;

    elseif (num_incoming_roads == 2 && num_outgoing_roads == 1)
        beta = junctions{e}.beta;

        incoming_road1 = junctions{e}.incoming(1);
        incoming_road2 = junctions{e}.incoming(2);
        outgoing_road = junctions{e}.outgoing(1);

        c1 = fun.D{incoming_road1}(p(incoming_road1, end));
        c2 = fun.D{incoming_road2}(p(incoming_road2, end));
        c3 = fun.S{outgoing_road}(p(outgoing_road, 1));

        outflow1 = min(c1, max(beta * c3, c3 - c2));
        outflow2 = min(c2, max((1 - beta) * c3, c3 - c1));
        inflow = outflow1 + outflow2;

        flow(incoming_road1, 2) = outflow1;
        flow(incoming_road2, 2) = outflow2;
        flow(outgoing_road, 1) = inflow;

    else
        error("This type of junction is not supported!");
    end
end
