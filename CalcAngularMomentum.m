function angularMomentum = CalcAngularMomentum(displacementVec, displacementNorm, vel, speed)

nAgents = length(vel);
[~, centralAgent] = min(sum(displacementNorm));
displacements = displacementVec(centralAgent, :, :);
centeredDisplacements = reshape(displacements-mean(displacements, 2), nAgents, []);
rVec = [centeredDisplacements zeros(nAgents, 1)]; % displacement relative to centroid (in 3D)
velVec = speed*[cos(vel) sin(vel) zeros(nAgents, 1)]; % velocity in Cartesian coords (in 3D)
allCrossProduct = mean(cross(rVec, velVec, 2), 1);
angularMomentum = abs(allCrossProduct(3));