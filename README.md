# Particle Swarm Optimization (PSO) in MATLAB

## Overview

This repository contains a simple, self-contained implementation of **Particle Swarm Optimization (PSO)** in MATLAB, designed for continuous function optimization. The default example minimizes the **Sphere function**, but you can easily adapt it to any other objective function.

## What is PSO?

**Particle Swarm Optimization** is a population-based stochastic optimization algorithm inspired by the social behavior of birds flocking or fish schooling.  
It was introduced by James Kennedy and Russell Eberhart in 1995.

## Algorithm Summary

- **Swarm**: A group of particles (candidate solutions), each with a position and velocity in the search space.
- **Personal Best (pBest)**: The best position found by each particle.
- **Global Best (gBest)**: The best position found by the entire swarm.
- Particles update their velocity and position based on their own experience and the swarm’s best-known position.

## PSO Update Formulas

1. **Velocity Update:**

    \[
    v_{i}^{(t+1)} = w \cdot v_{i}^{(t)} + c_1 \cdot r_1 \cdot (pBest_{i} - x_{i}^{(t)}) + c_2 \cdot r_2 \cdot (gBest - x_{i}^{(t)})
    \]

    - \( v_{i}^{(t+1)} \): New velocity of particle \(i\) at iteration \(t+1\)
    - \( w \): Inertia weight (controls exploration vs. exploitation)
    - \( c_1 \): Cognitive (personal) coefficient
    - \( c_2 \): Social (global) coefficient
    - \( r_1, r_2 \): Random values in [0, 1]
    - \( pBest_{i} \): Best position found by particle \(i\)
    - \( gBest \): Best position found by the swarm
    - \( x_{i}^{(t)} \): Current position of particle \(i\)

2. **Position Update:**

    \[
    x_{i}^{(t+1)} = x_{i}^{(t)} + v_{i}^{(t+1)}
    \]

    - \( x_{i}^{(t+1)} \): Updated position of particle \(i\)
    - \( v_{i}^{(t+1)} \): Updated velocity

## Implementation Details

### Parameters

- `numParticles`: Number of particles in the swarm (e.g., 30)
- `numDimensions`: Number of variables to optimize (problem dimensionality)
- `maxIterations`: Maximum number of PSO iterations
- `w`: Inertia weight (e.g., 0.7)
- `c1`: Cognitive coefficient (e.g., 1.5)
- `c2`: Social coefficient (e.g., 2.0)
- `lb`, `ub`: Lower and upper bounds for search space

### Objective Function

By default, the algorithm minimizes the **Sphere function**:
\[
f(x) = \sum_{j=1}^{n} x_j^2
\]
- Minimum is at \(x = [0, 0, \ldots, 0]\) with \(f(x) = 0\)

You can substitute any other function by modifying the `objFun` line in the code.

### Steps

1. **Initialization**
    - Randomly initialize particle positions (`X`) within bounds.
    - Set initial velocities (`V`) to zero.
    - Set each particle's personal best (`pBest`) to its initial position.
    - Set the global best (`gBest`) as the best among all personal bests.

2. **Main PSO Loop**
    - For each iteration:
        - Generate random matrices `r1` and `r2` for stochastic updates.
        - **Update velocity** using the formula above.
        - **Update position** by adding velocity to current position.
        - **Clamp positions** within bounds.
        - **Evaluate fitness** for all particles.
        - **Update personal bests** for particles that have improved.
        - **Update global best** if any particle's best improves the swarm’s best.

3. **Results**
    - Print the global best value and the corresponding position found by the swarm.

## MATLAB Code

```matlab
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
    r1 = rand(numParticles, numDimensions);
    r2 = rand(numParticles, numDimensions);
    V = w*V ...
        + c1*r1.*(pBest - X) ...
        + c2*r2.*(repmat(gBest, numParticles, 1) - X);
    
    X = X + V;
    X = min(max(X, lb), ub); % Clamp within bounds
    
    fVals = objFun(X);
    
    improved = fVals < pBestVal;
    pBest(improved, :) = X(improved, :);
    pBestVal(improved) = fVals(improved);
    
    [newGBestVal, idx] = min(pBestVal);
    if newGBestVal < gBestVal
        gBestVal = newGBestVal;
        gBest = pBest(idx, :);
    end
    
    fprintf('Iteration %d: Best Value = %.6f\n', iter, gBestVal);
end

fprintf('Global Best Value: %.6f\n', gBestVal);
fprintf('Global Best Position: %s\n', mat2str(gBest, 4));
