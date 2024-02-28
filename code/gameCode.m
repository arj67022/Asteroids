% Arjun Kanthawar
% ENGR 105 Project
% 12/8/19

% Asteroids

% This game allows the user to control a space ship using the arrow keys
% and shoot lasers using the space bar. The user gains points by shooting
% asteroids of three different sizes (10 points for a large asteroid, 20 
% points for a medium-sized asteroid, and 50 points for a small one). When 
% hit with a laser, a larger asteroid results in two smaller asteroids. All 
% objects in the game wrap around the screen edges. This includes lasers, 
% asteroids, and the ship. The user has three lives and loses lives each 
% time that the ship hits an asteroid. The game screen resets each time
% that all of the asteroids have been destroyed. The game ends when the 
% user runs out of lives. To play this game, run "start.m" and click 
% "play game."


%% Create game map and objects
clear all;

% Create Figure window with keyboard callbakcs
fig = figure(  'WindowKeyPressFcn', @keyDownFcn,   'color', 'black', ...
             'WindowKeyReleaseFcn',   @keyUpFcn, 'menubar',  'none');

% set the coordinate grid of the game screent
ax  = axes('units',  'normal', 'position', [.01 .01 .98 .88], ...
           'color',   'black',  'TickLen', [0 0], ...
           'XGrid',      'on',    'YGrid', 'on', ...
            'XLim', [-30, 30],     'YLim', [-30, 30]);
        
points = 0; % Total Points
lives = 3; % Number of lives that the player has left. 
str = {'Points: 0','Lives: 3'};
% str = {num2str(points),num2str(lives)};

% Create textbox in the corner of the screen displaying points and lives
% left
scoreBoard = annotation('textbox', 'units', 'normal', 'position', [0 .9 1 .1], ...
         'string', str, 'color',  'white', 'fontsize', 18);       
      
% Ship consists of three lines that form a triangle 
% Initial x and y position of ship
x = [1.5,cos(2*pi/3),cos(4*pi/3),1.5]; 
y = [0,sin(2*pi/3),sin(4*pi/3),0];

% 
ship  = line('Xdata',x,'Ydata',y,'linewidth', 2, 'color', [.6 .6 .6]); 



%% Lasers

% Create 4 Laser objects. Give each one its own number and create the line
% associated with each laser.
laser1 = laser;
laser1.num = 1;
laser1 = createLas(laser1); % Creates a line associated with a laser
laser2 = laser;
laser2.num = 2;
laser2 = createLas(laser2);
laser3 = laser;
laser3.num = 3;
laser3 = createLas(laser3);
laser4 = laser;
laser4.num = 4;
laser4 = createLas(laser4);

% List of lasers
laserList= [laser1,laser2,laser3,laser4];
% currentLasers will keep track of laser positions throughout
currentLasers = laserList;

% Array for the amount of time that each laser has been in play
laserTimers = [laser1.timer,laser2.timer,laser3.timer,laser4.timer];

% Read in images of each asteroid (large, medium and small)
largeAst = imread('Ast1.png');
medAst = imread('Ast2.png');
smallAst = imread('Ast3.png');
hold on

% Define three large asteroids along with their positions, associated
% numbers, and directions of motion.
largeAst1 = asteroid;
largeAst1.xPos = [12 22];
largeAst1.yPos = [-8 2];
largeAst1.num = 1;
largeAst1.theta = rand*2*pi;

largeAst2 = asteroid;
largeAst2.xPos = [4 14];
largeAst2.yPos = [-28 -18];
largeAst2.num = 2;
largeAst2.theta = rand*2*pi;

largeAst3 = asteroid;
largeAst3.xPos = [-19 -9];
largeAst3.yPos = [16 26];
largeAst3.num = 3;
largeAst3.theta = rand*2*pi;

% Define six medium sized asteroids along with their associated numbers
medAst1 = asteroid;
medAst1.num = 4;
medAst1.type = 'medium';

medAst2 = asteroid;
medAst2.num = 5;
medAst2.type = 'medium';

medAst3 = asteroid;
medAst3.num = 6;
medAst3.type = 'medium';

medAst4 = asteroid;
medAst4.num = 7;
medAst4.type = 'medium';

medAst5 = asteroid;
medAst5.num = 8;
medAst5.type = 'medium';


medAst6 = asteroid;
medAst6.num = 9;
medAst6.type = 'medium';

% Define twelve medium sized asteroids along with their associated numbers
smallAst1 = asteroid;
smallAst1.num = 10;
smallAst1.type = 'small';

smallAst2 = asteroid;
smallAst2.num = 11;
smallAst2.type = 'small';

smallAst3 = asteroid;
smallAst3.num = 12;
smallAst3.type = 'small';

smallAst4 = asteroid;
smallAst4.num = 13;
smallAst4.type = 'small';

smallAst5 = asteroid;
smallAst5.num = 14;
smallAst5.type = 'small';

smallAst6 = asteroid;
smallAst6.num = 15;
smallAst6.type = 'small';

smallAst7 = asteroid;
smallAst7.num = 16;
smallAst7.type = 'small';

smallAst8 = asteroid;
smallAst8.num = 17;
smallAst8.type = 'small';

smallAst9 = asteroid;
smallAst9.num = 18;
smallAst9.type = 'small';

smallAst10 = asteroid;
smallAst10.num = 19;
smallAst10.type = 'small';

smallAst11 = asteroid;
smallAst11.num = 20;
smallAst11.type = 'small';

smallAst12 = asteroid;
smallAst12.num = 21;
smallAst12.type = 'small';

% List of asteroids that are currently in play
currentAsteroids = [largeAst1,largeAst2,largeAst3];
% List containing every asteroid
asteroidList = [largeAst1,largeAst2,largeAst3,medAst1,medAst2,medAst3,medAst4,medAst5,medAst6,smallAst1,smallAst2,smallAst3,smallAst4,smallAst5,smallAst6,smallAst7,smallAst8,smallAst9,smallAst10,smallAst11,smallAst12];

%% Variables

% These variables are altered by the keyboard callback functions
global shipVelocity rotShip laserPresent count initialVel

tic % timer when the game starts
t = 0;

% Laser Variables
laserLength = 1; % Time that a laser can be kept in play
deltaLaser = 0; % minimum time between two lasers being fired by ship
numOfLasers = 0; % Keeps track of number of lasers in play. (4 maximum)
laserPresent=0; % laserPresent=1 if user is pressing spacebar, otherwise it equals 0.

% Ship Variables
shipRecover = 0; % Gives time for ship to recover
shipAcceleration = 0.1; % Acceleration of ship
shipVelocity = 0; % ship velocity
frictionDeceleration = 1*shipVelocity; % Deceleration when user is not pressing up arrow key.
initialVel = 1.5; % initial velocity when user presses up arrow key
maxVel = 2.5; % max velocity of ship
count = false; % True if user is holding down up arrow key. Otherwise, it is false
rotShip = 0; % if rotShip = 1, user is holding down either right or left arrow key
shipPosition = [0,0]; % Center of ship that will be updated to update lines that make up ship
theta = 0; % Angle that ship is facing
%% Game

% This loop runs the game. It runs until the user has 0 lives left.
while lives>0
    
    % Time between loops. delta is used as time in kinematics equations.
    previousT = t;
    t = toc;
    delta = t - previousT; 
    
%% Update Ship Position
    
    theta = theta+rotShip; % Changes orientation angle of ship

    % If the user is holding down the up arrow key, the ship accelerates up to
    % a maximum velocity. If it has already reached this maxVelocity, it does
    % not accelerate.
    if count
        if shipVelocity <= maxVel
        shipVelocity = shipVelocity+(shipAcceleration*delta);
        end
    % If the user is not holding down the up arrow key and the ship is moving,
    % it decelerates until it has a velocity of 0. 
    elseif shipVelocity > 0
        frictionDeceleration = 1*shipVelocity;
        shipVelocity = shipVelocity - (frictionDeceleration*delta);
    else
        shipVelocity = 0;
    end

    % Update the ship's central coordinate.
    shipPosition = shipPosition + shipVelocity.*[cos(theta),sin(theta)]; 

    % Make ship wrap around the edges of the screen.
    if shipPosition(1) > 30
        shipPosition(1) = shipPosition(1)-60;
    elseif shipPosition(1) < -30
        shipPosition(1) = shipPosition(1)+60;
    end

    if shipPosition(2) > 30 
        shipPosition(2) = shipPosition(2)-60;
    elseif shipPosition(2) < -30
        shipPosition(2) = shipPosition(2)+60;
    end


    % Updates x and y coordinates of the lines that make up the ship
    x = [ shipPosition(1) + 1.5*cos(theta), ...
          shipPosition(1) + cos(theta + 2*pi/3), ...
          shipPosition(1) + cos(theta + 4*pi/3), ...
          shipPosition(1) + 1.5*cos(theta) ];
        
    y  = [ shipPosition(2) + 1.5*sin(theta), ...
          shipPosition(2) + sin(theta + 2*pi/3), ...
          shipPosition(2) + sin(theta + 4*pi/3), ...
          shipPosition(2) + 1.5*sin(theta)];

%% Update Laser Position

% Only fire another bullet if it has been at least 0.1 seconds since you 
% fired the last bullet
    if abs(t-deltaLaser) > 0.1
        deltaLaser = t; % Reset deltaLaser to current time

       % Fire laser if space bar was pressed and less than four lasers have are
       % currently in play.
        if (laserPresent==1 && numOfLasers<4) 
            numOfLasers = numOfLasers+1; % Increment number of lasers that are in play.
            fireLaser = find(laserTimers == 0,1); % find laser that will be shot;


            laserList(fireLaser).timer = delta; % Starts timer for laser.
            laserTimers(fireLaser) = delta; % adds the time to laserTimers array. 

            % Sets the properties of the laser
            laserList(fireLaser) = objChar(laserList(fireLaser),x(1),y(1),theta);

            % Adds this new laser to the currentLasers list
            if laserList(fireLaser).num == 1
                currentLasers(1) = laserList(fireLaser);
            elseif laserList(fireLaser).num == 2
                currentLasers(2) = laserList(fireLaser);
            elseif laserList(fireLaser).num == 3
                currentLasers(3) = laserList(fireLaser);
            else
                currentLasers(4) = laserList(fireLaser);
            end

        end
    end




    % This while loop will cause any laser that has been present for more than
    % one second to disappear by resetting its properties. 
    for i = 1:length(currentLasers)
        if currentLasers(i).timer>laserLength
             currentLasers(i) = reset(currentLasers(i));
             numOfLasers = numOfLasers - 1;
        end
    end


    % This for loop will increment the timer and positions for each laser
    for i = 1:length(currentLasers)
        if currentLasers(i).timer > 0
            currentLasers(i).timer = currentLasers(i).timer + delta; % update timers
            currentLasers(i) = move(delta,currentLasers(i)); % update positions
        end

    end


    %% Delete old Asteroid Images

    % All old asteroid images are deleted
    for i = 1:length(currentAsteroids)
        delete(currentAsteroids(i).image)
    end
    %% Ship-Asteroid Collisions


    % shipRecover is the amount of time since the user last lost a life or the
    % game screen has been reset. This gives the user a grace period where
    % he/she will not lose a life.
    shipRecover = shipRecover+delta;

    % if collide == 1, the ship has hit an asteroid and should lose a life
    collide = 0;

    % If the ship is not in its grace period (2.5 seconds), check if the ship is hitting an
    % asteroid.
    if shipRecover > 2.5 
        shipShape = polyshape([x(1),x(2),x(3)],[y(1),y(2),y(3)]);

        % This loop checks whether any asteroid is overlapping with the ship.
        % If an asteroid is hitting a ship, then collide = 1 and the code
        % breaks out of the loop.
        for i = 1:length(currentAsteroids)
               collision = overlaps(poly(currentAsteroids(i)),shipShape);
                if collision
                    collide = 1;
                    break
                end
        end

        % If the ship is hitting an asteroid, reset the ship to the original
        % position and subtract one from the player's lives.
        if collide == 1

            % Original ship values
            x = [1.5,-0.5,-0.5,1.5];
            y = [0,0.8660,-0.8660,0];
            theta = 0;
            shipRecover = 0;
            shipPosition = [0,0];
            shipVelocity = 0;
            % User loses a life
            lives = lives - 1;

            % Update scoreboard
            set(scoreBoard,'string',sprintf('Points: %2d\n Lives: %2d',points,lives));

        end
    end

    %% Asteroid-Laser Collisions


    % Define an empty array of laser objects
    lasersInPlay = [laser1];
    lasersInPlay(1) = [];

    % This loop creates an array of the lasers that are currently in play.
    for i = 1:length(currentLasers)
        if currentLasers(i).timer > 0
            lasersInPlay(end+1) = currentLasers(i);
        end
    end


    % Only go into this block of code if lasers and asteroids are in play
    if ~isempty(lasersInPlay) && ~isempty(currentAsteroids)
        % Find all lasers and asteroids involved in collisions
        [collidedLasers,collidedAsteroids] = laserAsteroidCollision(lasersInPlay,currentAsteroids); 

        % New list of current asteroids
        [newPoints,currentAsteroids] = newAsteroidList(points,collidedAsteroids,currentAsteroids,asteroidList);

        % If the user has shot asteroids, update points on scoreboard
        if newPoints > points
            points = newPoints;
            % update scoreboard
            set(scoreBoard,'string',sprintf('Points: %2d\n Lives: %2d',points,lives));
        end

        % Delete all of the lasers that hit asteroids and reset their timers
        for i = 1:length(collidedLasers)
            currentLasers(collidedLasers(i).num) = reset(currentLasers(collidedLasers(i).num));
             numOfLasers = numOfLasers - 1; % decrement numOfLasers
        end
    end

    %% Reset game screen
    % If all asteroids have been destroyed, reset to the original game screen
    % with three large asteroids and the ship in the center. 
    if isempty(currentAsteroids)
        currentAsteroids(1) = largeAst1;
        currentAsteroids(2) = largeAst2;
        currentAsteroids(3) = largeAst3;

        % Original Ship Position, direction of motion, and velocity
        x = [1.5,-0.5,-0.5,1.5];
        y = [0,0.8660,-0.8660,0];
        theta = 0;
        shipRecover = 0;
        shipPosition = [0,0];
        shipVelocity = 0;
    end


    % Update asteroid positions and create the new asteroid image for each
    % asteroid that is currently in play
    for i = 1:length(currentAsteroids)
        currentAsteroids(i) = move(currentAsteroids(i)); % update positions

        % Updating image requires knowledge of what type of asteroid is being
        % updated. (large,medium, or small)
        if strcmp(currentAsteroids(i).type,"large")
            sizeAst = largeAst;       
        elseif strcmp(currentAsteroids(i).type,"medium")
            sizeAst = medAst;
        else
            sizeAst = smallAst;
        end
        % Set asteroid image
        currentAsteroids(i).image = imagesc(currentAsteroids(i).xPos,currentAsteroids(i).yPos,sizeAst);
        setImage = set(currentAsteroids(i).image);
    end

    % Set the positions of each laser with its new position coordinates
    for i = 1:length(currentLasers)
        set(currentLasers(i).las,'Xdata',currentLasers(i).xPos,'Ydata',currentLasers(i).yPos)
    end

    % Update laserTimers array
    laserTimers = [currentLasers(1).timer,currentLasers(2).timer,currentLasers(3).timer,currentLasers(4).timer];

    % This loop is used to ensure that numOfLasers reflects the number of
    % lasers that are in play. 
    numOfLasers = 0;
    for i = 1:length(laserTimers)
        if laserTimers(i)>0
            numOfLasers = numOfLasers+1;
        end

    end

    set(ship,'Xdata',x,'Ydata',y) % Sets the ship with the new coordinates


    drawnow % Updates the game board as the loop runs

end


%% End Game Screen

str = {"Game Over"}; % End of game text

% Create textbox in the corner of the screen displaying points and lives
% left
gameOver = annotation('textbox', 'units', 'normal', 'position', [0.3 0.1 0.5 0.5], ...
         'string', str, 'color',  'white', 'fontsize', 40);   

%% Keyboard Callback Functions

% When the user presses one of the arrow keys, the cooresponding variable
% is altered that allows the ship to move. When the user presses the space
% key, the ship releases a laser.
function keyDownFcn(~, event)
global shipVelocity rotShip laserPresent count initialVel
    switch event.Key
        case 'uparrow'
            count = true; % count = true is used in the while loop to accelerate ship
            if shipVelocity < initialVel 
                shipVelocity = initialVel;
            end
        case 'rightarrow'  
            rotShip = -.1; % Clockwise 
        case 'leftarrow'
            rotShip = .1; % Counter-Clockwise
        case 'space'
            laserPresent = 1;
    end
end

% When the user releases a key, the corresponding variable is set to zero. 
function keyUpFcn(~, event)
global rotShip laserPresent count 
    switch event.Key
        case 'uparrow'    
            count = false; % count = false is used in while loop to decelerate ship.
        case 'rightarrow'  
            rotShip = 0; 
        case 'leftarrow'   
            rotShip = 0;
        case 'space'       
            laserPresent = 0;
    end
end
    