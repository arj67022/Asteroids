% This function takes arrays of the lasers and asteroids that are in play
% and returns an array of lasers and an array of asteroids that have been 
% involved in collisions. 
function [lasers,asteroids] = laserAsteroidCollision(laserList,currentAsteroids)
% Create empty laser array
lasers = [laser];
lasers(1) = [];
% Create empty asteroid array
asteroids = [asteroid];
asteroids(1) = [];

% Create line segments for each laser
for i = 1:length(laserList)
    laserList(i).lineSegment = lineSeg(laserList(i));
end

% length of currentAsteroids and laserList arrays
currentAsteroids_length = length(currentAsteroids);
laserList_length = length(laserList);
j = 1;


% This loop checks for every possible collision combination. If a laser and
% an asteroid collide, the laser and asteroid are added to the output
% arrays. 
while j<=currentAsteroids_length
   i=1;
    while i<=laserList_length

        % Finds the intersection of an asteroid and laser
        [in,~] = intersect(poly(currentAsteroids(j)),laserList(i).lineSegment);

        % if a collision has occured, append the corresponding laser and
        % asteroid to the lists that are returned from this function.
        if ~isempty(in)
            lasers(end+1) = laserList(1);
            asteroids(end+1) = currentAsteroids(j);

            % Delete asteroid and laser from original lists to prevent
            % any double counting (two asteroids hit by one laser or one
            % laser hitting two asteroids). 
            currentAsteroids(j) = [];
            laserList(i) = [];
            % Decrement length of lists
            currentAsteroids_length = currentAsteroids_length - 1;
            laserList_length = laserList_length - 1;
            break
        end
        i = i+1;
    end
    j = j+1;   
end


end


	