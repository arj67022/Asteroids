% If an object has position coordinates greater than 30 in either the x or
% y-direction, subtract 60 from those coordinates to make the object appear
% on the other side of the screen.
function [x1,x2] = WrapPos(laserCoords,a1,a2)
x1 = laserCoords(a1)-60;
x2 = laserCoords(a2)-60;
end