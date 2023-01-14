function [axis, center_index] = ParallelAxis(road2d)
% INPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% road2d:   parameterizing curve which maps the beginning of a cell from
%           the discretization of the LWR model onto an index of the 
%           discretecontrol domain
%
% OUTPUT PARAMETER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% axis:             axis which is parallel to the road given through road2d
% center_index:     index corresponding to the discrete control domain; 
%                   encodes the beginning of the center line of the road
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
x1 = road2d(1);
x2 = road2d(2);

diff = x1 - x2;

if (diff(1) == 0)
    axis = 2;
elseif (diff(2) == 0)
    axis = 1;
else
    error("Road is not parallel to the x- nor the y-axis!");
end

center_index = x1;

end