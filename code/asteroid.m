% This class defines an asteroid object along with the properties of an 
% asteroid and its functions that define an asteroid's properties, update
% an asteroid's position, and create a polygon shape for an asteroid image
% (for collision detection).
classdef asteroid
    properties
        num = 1; % number associated with each asteroid object
        type = 'large' % Refers to size of asteroid
        xPos = [0,2]; % endpoints of x-positions
        yPos = [0,2]; % endpoints of y-positions
        theta = 0; % direction of motion
        velocity = 0.4;
        image = []; % image of asteroid
    end
    methods
        % This function defines the properties of an asteroid. 
        function obj1 = objProp(obj1,obj2)
            
            % The size depends on the asteroid type. subtract four from x an
            % y dimensions to go from large to small.
            if strcmp(obj2.type,'large')
                obj1.type = 'medium';
                obj1.xPos(1) = obj2.xPos(1);
                obj1.xPos(2) = obj2.xPos(2)-4;
                obj1.yPos(1) = obj2.yPos(1);
                obj1.yPos(2) = obj2.yPos(2)-4;
            % Subtract 3 from x and y dimensions to go from medium to small.
            else
                obj1.type = 'small';
                obj1.xPos(1) = obj2.xPos(1);
                obj1.xPos(2) = obj2.xPos(2)-3;
                obj1.yPos(1) = obj2.yPos(1);
                obj1.yPos(2) = obj2.yPos(2)-3;
            end
            
            % Asteroid velocity and direction angle are random for each
            % asteroid
            obj1.velocity = rand;
            obj1.theta = rand*2*pi;
            
        end
        
        % This function creates a polyshape of an asteroid
        function area = poly(obj)
            area = polyshape([obj.xPos(1),obj.xPos(1),obj.xPos(2),obj.xPos(2)],[obj.yPos(1),obj.yPos(2),obj.yPos(2),obj.yPos(1)]);
        end
        
        % This function increments the position of an asteroid while
        % simultaneously making sure that the asteroid wraps around the
        % edges of the game screen.
        function obj = move(obj)
            obj.xPos = obj.xPos + obj.velocity.*[cos(obj.theta),cos(obj.theta)];
            obj.yPos = obj.yPos + obj.velocity.*[sin(obj.theta),sin(obj.theta)];
            
            % Makes sure that asteroid wraps around edges of screen
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
     
    end
end
            
        