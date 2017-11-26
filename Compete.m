function timeElapsed = Compete(preyNN, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                               nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                               predatorNN, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                               nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                               deltaT, maxTime, fieldSize, captureDistance, thisGeneration)
% runs one full simulation based on prey and predator chromosomes and
% simulation parameters, returning the time elapsed before one of the stop
% conditions was met
tic
[preyT1, preyW12, preyT2, preyW23] = DecodeChromosome(preyNN, nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs);
[predatorT1, predatorW12, predatorT2, predatorW23] = DecodeChromosome(predatorNN, nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs);

[preyPos, preyVel] = RandomSpawn(nPreyAgents, fieldSize, [(3/4) (1/2)]);
[predatorPos, predatorVel] = RandomSpawn(nPredatorAgents, fieldSize, [1/4 1/2]);

[preyObj, predatorObj] = InitializePlot(preyPos, predatorPos, fieldSize, thisGeneration);

timeElapsed = single(0);
captured = single(0);

toc
tic
    gpuPreyPos = gpuArray(single(preyPos));
    gpuPreyVel = gpuArray(single(preyVel));
    
    gpuPredatorPos = gpuArray(single(predatorPos));
    gpuPredatorVel = gpuArray(single(predatorVel));
    gpuNPredatorAgents = gpuArray(single(nPredatorAgents));
    gpuNPredatorNeighbors = gpuArray(single(nPredatorNeighbors));
    
    %gpuPreyInputVectors = gpuArray(single(preyInputVectors));
    
    gpuPreyT1 = gpuArray(single(preyT1));
    gpuPreyW12 = gpuArray(single(preyW12));
    gpuPreyT2 = gpuArray(single(preyT2));
    gpuPreyW23 = gpuArray(single(preyW23));
    
    gpuPredatorT1 = gpuArray(single(predatorT1));
    gpuPredatorW12 = gpuArray(single(predatorW12));
    gpuPredatorT2 = gpuArray(single(predatorT2));
    gpuPredatorW23 = gpuArray(single(predatorW23));
    
    gpuMaxPreyTurningAngle =gpuArray(single(maxPreyTurningAngle));
    gpuPreyStepLength =gpuArray(single(preyStepLength));
    
    gpuMaxPredatorTurningAngle =gpuArray(single(maxPredatorTurningAngle));
    gpuPredatorStepLength =gpuArray(single(predatorStepLength));
    
    gpuDeltaT = gpuArray(single(deltaT));
    gpuFieldSize = gpuArray(single(fieldSize));
    gpuNPreyNeighbors = gpuArray(single(nPreyNeighbors));
    gpuCaptureDistance = gpuArray(single(captureDistance));
    gpuTimeElapsed = gpuArray(single(0));
    
while (timeElapsed < maxTime) && ~captured
%     tic
%     preyPreyParameters = GetFriendParameters(preyPos, preyVel, nPreyNeighbors,fieldSize);
%     [preyPredatorParameters, predatorPreyParameters] = GetFoeParameters(preyPos, preyVel, predatorPos, predatorVel, nPredatorAgents, nPredatorNeighbors,fieldSize);
%     predatorPredatorParameters = GetFriendParameters(predatorPos, predatorVel, nPredatorAgents-1,fieldSize);
%     preyInputVectors = [preyPreyParameters ; preyPredatorParameters];
%     predatorInputVectors = [predatorPreyParameters ; predatorPredatorParameters];
%     [preyPos, preyVel] = UpdateAgentState(preyPos, preyVel, preyInputVectors, preyT1, preyW12,...
%         preyT2, preyW23, maxPreyTurningAngle, preyStepLength, deltaT, fieldSize);
%     %[preyPolarization, preyAngularMomentum] = GetFlockStats(preyPos, preyVel, nPreyAgents);
%     [predatorPos, predatorVel] = UpdateAgentState(predatorPos, predatorVel, predatorInputVectors, predatorT1, predatorW12, predatorT2, predatorW23, maxPredatorTurningAngle, predatorStepLength, deltaT, fieldSize);
%     %[predatorPolarization, predatorAngularMomentum] = GetFlockStats(predatorPos, predatorVel, nPredatorAgents);
%     captured = CheckCaptured(preyPos, predatorPos, captureDistance);
%     timeElapsed = timeElapsed + deltaT;
%     toc
    
    gpuPreyPreyParameters = GetFriendParameters(gpuPreyPos, gpuPreyVel, gpuNPreyNeighbors,gpuFieldSize);
    [gpuPreyPredatorParameters, gpuPredatorPreyParameters] = GetFoeParameters(gpuPreyPos, gpuPreyVel, gpuPredatorPos, gpuPredatorVel, gpuNPredatorAgents, gpuNPredatorNeighbors,gpuFieldSize);
    gpuPredatorPredatorParameters = GetFriendParameters(gpuPredatorPos, gpuPredatorVel, gpuNPredatorAgents-1,gpuFieldSize);
    gpuPreyInputVectors = [gpuPreyPreyParameters ; gpuPreyPredatorParameters];
    gpuPredatorInputVectors = [gpuPredatorPreyParameters ; gpuPredatorPredatorParameters];
    [gpuPreyPos, gpuPreyVel] = UpdateAgentState(gpuPreyPos, gpuPreyVel, gpuPreyInputVectors, gpuPreyT1, gpuPreyW12,...
        gpuPreyT2, gpuPreyW23, gpuMaxPreyTurningAngle, gpuPreyStepLength, gpuDeltaT, gpuFieldSize);
    %%[preyPolarization, preyAngularMomentum] = GetFlockStats(preyPos, preyVel, nPreyAgents);
    [gpuPredatorPos, gpuPredatorVel] = UpdateAgentState(gpuPredatorPos, predatorVel, gpuPredatorInputVectors, gpuPredatorT1, gpuPredatorW12, gpuPredatorT2, gpuPredatorW23, gpuMaxPredatorTurningAngle, gpuPredatorStepLength, gpuDeltaT, gpuFieldSize);
    %%[predatorPolarization, predatorAngularMomentum] = GetFlockStats(predatorPos, predatorVel, nPredatorAgents);
    gpuCaptured = CheckCaptured(gpuPreyPos, gpuPredatorPos, gpuCaptureDistance);
    gpuTimeElapsed = gpuTimeElapsed + gpuDeltaT;
    
    timeElapsed = gather(gpuTimeElapsed);
    captured = gather(gpuCaptured);
  
    
    
    
    
   % myTitle = sprintf('Gen = %d, t = %5.2f',thisGeneration, round(timeElapsed,2));
    %PlotAgentStates(preyObj, preyPos, predatorObj, predatorPos, myTitle);
end
toc
clf;