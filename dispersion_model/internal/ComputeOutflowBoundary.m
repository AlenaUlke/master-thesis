function [outflow, inflow] = ComputeOutflowBoundary(w)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% w:    wind field at a given time t and thus a constant vector with
%       respect to time;
%
% OUTPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Computes the in- and outflow boundary of a rectangular domain for a given
% wind field w which is constant over time or describes the wind field at a
% fixed time t.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

if w(1) == 0
    outflow = ["east" "west"];
    inflow = [];
elseif w(1) > 0
    outflow = ["east"];
    inflow = ["west"];
else
    outflow = ["west"];
    inflow = ["east"];
end

if w(2) == 0
    outflow = [outflow "south", "north"];
elseif w(2) > 0
    outflow = [outflow "north"];
    inflow = [inflow "south"];
else
    outflow = [outflow "south"];
    inflow = [inflow "north"];
end
end