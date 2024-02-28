% If an object has position coordinates less than -30 in either the x or
% y-direction, add 60 to those coordinates to make the object appear
% on the other side of the screen.
function [x1,x2] = WrapNeg(laserCoords,a1,a2)
x1 = laserCoords(a1)+60;
x2 = laserCoords(a2)+60;
end