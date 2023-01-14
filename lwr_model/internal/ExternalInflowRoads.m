function inflow_roads = ExternalInflowRoads(Q_in)
num_roads = length(Q_in);
inflow_roads = [];

for e = 1:num_roads
    if ~isempty(Q_in{e})
        inflow_roads = [inflow_roads, e];
    end
end
end