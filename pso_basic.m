% Particle Swarm Optimization (PSO) in MATLAB

% --- PSO PARAMETERS ---
numParticles = 30;      % Number of particles
numDimensions = 2;      % Problem dimensionality (change as needed)
maxIterations = 100;    % Max number of iterations

w = 0.7;                % Inertia weight
c1 = 1.5;               % Cognitive (personal) weight
c2 = 2.0;               % Social (global) weight

lb = -10;               % Lower bound for all dimensions
ub = 10;                % Upper bound

% --- OBJECTIVE FUNCTION ---
objFun = @(x) sum(x.^2, 2);   % Sphere function (min at [0,0,...,0])

% --- INITIALIZATION ---
% Random positions and velocities
X = lb + (ub - lb) * rand(numParticles, numDimensions); % Positions
V = zeros(numParticles, numDimensions);                 % Velocities

% Initialize personal bests
pBest = X;
pBestVal = objFun(X);

% Initialize global best
[gBestVal, idx] = min(pBestVal);
gBest = pBest(idx, :);

% --- PSO LOOP ---
for iter = 1:maxIterations
    % Update velocity
    r1 = rand(numParticles, numDimensions);
    r2 = rand(numParticles, numDimensions);
    V = w*V ...
        + c1*r1.*(pBest - X) ...
        + c2*r2.*(repmat(gBest, numParticles, 1) - X);
    
    % Update position
    X = X + V;
    X = min(max(X, lb), ub); % Keep within bounds
    
    % Evaluate
    fVals = objFun(X);
    
    % Update personal bests
    improved = fVals < pBestVal;
    pBest(improved, :) = X(improved, :);
    pBestVal(improved) = fVals(improved);
    
    % Update global best
    [newGBestVal, idx] = min(pBestVal);
    if newGBestVal < gBestVal
        gBestVal = newGBestVal;
        gBest = pBest(idx, :);
    end
    
    % (Optional) Show progress
    fprintf('Iteration %d: Best Value = %.6f\n', iter, gBestVal);
end

% --- RESULTS ---
fprintf('Global Best Value: %.6f\n', gBestVal);
fprintf('Global Best Position: %s\n', mat2str(gBest, 4));
