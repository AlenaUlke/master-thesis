function [b_min, b_max, axis] = ParallelAxisAndRoadBorder(road2d, width, dx)
[axis, center_index] = ParallelAxis(road2d);

% translate index (i,j) into absolute value (x_i, y_j)
center_value = dx * center_index;

if axis == 1
    b_min = round( (center_value(2) - width/2) / dx, 0);
    b_max = round( (center_value(2) + width/2) / dx, 0);
elseif axis == 2
    b_min = round( (center_value(1) - width/2) / dx, 0);
    b_max = round( (center_value(1) + width/2) / dx, 0);
else
    error("Road is not parallel to the x- nor y-axis!")
end
end