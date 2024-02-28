% This class defines the laser object along with the properties of a laser
% and functions that set a laser's properties, reset a laser's properties,
% update a laser's position, create a line segment for a laser, and create a
% line object for a laser. 
classdef laser
    properties
        num = 0; % Number associated with each laser object
        xPos = [nan,nan]; % x endpoints of laser
        yPos = [nan,nan]; % y endpoints of laser
        xVelocity = 0; % velocity in the x-direction
        yVelocity = 0; % velocity in the y-direction
        theta = 0; % direction of motion
        las = line(nan,nan,'linestyle','-','color', 'w','markersize',40); % line associated with laser
        timer = 0; % time that the laser has been in play
        lineSegment = []; % line segment associated with laser
    end
    methods
        % this function defines the position, direction of motion, and
        % velocity of the laser
        function obj = objChar(obj,shipNoseX,shipNoseY,shipTheta)
            % Laser takes position and direction of motion of the ship when
            % it fired the laser
            obj.xPos = [shipNoseX,shipNoseX+cos(shipTheta)];
            obj.yPos = [shipNoseY,shipNoseY+sin(shipTheta)];
            obj.theta = shipTheta;
            % define velocities of the endpoints of the laser
            obj.xVelocity = 40*[cos(obj.theta),cos(obj.theta)];
            obj.yVelocity = 40*[sin(obj.theta),sin(obj.theta)];
        end
        
        % This function updates the position of the laser while
        % simultaneously making sure that the laser wraps around the edges
        % of the game screen.
        function obj = move(delta,obj)
            % Updates the position
            obj.xPos = obj.xPos + delta*obj.xVelocity;
            obj.yPos = obj.yPos + delta*obj.yVelocity;
                       
            % Makes sure that the laser wraps around the edges of the game
            % screen.
            if obj.xPos(1)>30 && obj.xPos(2)>30
                [obj.xPos(1),obj.xPos(2)] = WrapPos(obj.xPos,1,2);
            elseif obj.xPos(1)<-30 && obj.xPos(2)<-30
                [obj.xPos(1),obj.xPos(2)] = WrapNeg(obj.xPos,1,2);
            end
            
            if obj.yPos(1)>30 && obj.yPos(2)>30
                [obj.yPos(1),obj.yPos(2)] = WrapPos(obj.yPos,1,2);
            elseif obj.yPos(1)<-30 && obj.yPos(2)<-30
                [obj.yPos(1),obj.yPos(2)] = WrapNeg(obj.yPos,1,2);
            end
               
        end
        
        % Creates line associated with laser
        function obj = createLas(obj)        
            obj.las = line(nan,nan,'linestyle','-','color','w','markersize',40);       
        end
        
        % resets laser's properties when it is no longer supposed to be
        % visible.
        function obj = reset(obj)
            obj.xPos = [nan,nan];
            obj.yPos = [nan,nan];
            obj.timer = 0;
        end
        
        % Creates line segment of laser
        function lineSegment = lineSeg(obj)
            lineSegment = [obj.xPos(1),obj.yPos(1); obj.xPos(2), obj.yPos(2)];           
        end
        
    end
end
            
            
            
 
            
            
  
    