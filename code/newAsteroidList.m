% This function takes in the user's points, the asteroids involved in 
% collisions, the asteroids currently in play, and the list of all 
% asteroids and returns a new list of asteroids by deleting the
% asteroids that were involved in collisions and adding two appropriate
% asteroids to currentAsteroids if necessary. The function also returns the 
% new amount of points the user has for destroying asteroids. 
function [newPoints,newList] = newAsteroidList(points,collidedAsteroids,currentAsteroids,asteroidList)

% astNums is an array of the asteroid numbers in order to keep track of the
% asteroid sizes.
astNums = zeros(1,length(currentAsteroids));
for i = 1:length(currentAsteroids)
    astNums(i) = currentAsteroids(i).num;
end

% This loop runs through each asteroid that collides with a laser. If the
% asteroid is large or medium, two new asteroids of a size that is one
% size smaller are added to currentAsteroids (large asteroid results 
% in two medium asteroids and a medium asteroid results in two small 
% asteroids).
for i = 1:length(collidedAsteroids)
    len = length(currentAsteroids);
    % if collided asteroid is large or medium, append two new asteroids of
    % a size that is one size smaller
    if strcmp(collidedAsteroids(i).type,'large')|| strcmp(collidedAsteroids(i).type,'medium')
        % 10 points for hitting a large asteroid
        points = points+10; 
        % Append two new asteroids to currentAsteroids
        currentAsteroids(len+1) = asteroidList(2*collidedAsteroids(i).num + 2);
        currentAsteroids(len+2) = asteroidList(2*collidedAsteroids(i).num + 3);
        % Set properties of these new asteroids
        currentAsteroids(len+1) = objProp(currentAsteroids(len+1),collidedAsteroids(i));
        currentAsteroids(len+2) = objProp(currentAsteroids(len+2),collidedAsteroids(i));
    elseif strcmp(collidedAsteroids(i).type,'medium')
        % 20 points for hitting a medium asteroid
        points = points+20; 
        % Append two new asteroids to currentAsteroids
        currentAsteroids(len+1) = asteroidList(2*collidedAsteroids(i).num + 2);
        currentAsteroids(len+2) = asteroidList(2*collidedAsteroids(i).num + 3);
        % Set properties of these new asteroids
        currentAsteroids(len+1) = objProp(currentAsteroids(len+1),collidedAsteroids(i));
        currentAsteroids(len+2) = objProp(currentAsteroids(len+2),collidedAsteroids(i));        
        
    else
        points = points + 50; % 50 points for hitting a small asteroid
    end
    
    % Find the index of the asteroid that needs to be deleted
    delAsteroid = (astNums == collidedAsteroids(i).num);
    % Delete the asteroid that collided
    currentAsteroids(delAsteroid) = [];
    % Delete the asteroid number of the asteroid that was deleted.
    astNums(delAsteroid) = [];
end
newList = currentAsteroids;
newPoints = points;

end
        


 


