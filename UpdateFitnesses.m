function [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen)
% run a number of simulations to fill in the missing fitnesses in our
% fitnessMatrix, then record a competition between 

fprintf("\nGeneration %d\n----\n", gen);

[rows, cols] = find(~fitnessMatrix); % selects all (i,j) where fitnessMatrix(i,j)==0
preyPopulationParfor = preyPopulation(rows,:);
predatorPopulationParfor = predatorPopulation(cols,:);
fitnessParfor = zeros(1, length(rows));
for i = 1:length(rows)
    fprintf("Evaluating prey %2d vs predator %2d ...\n", rows(i), cols(i));
    fitness = 0;
    for n = 1:nCompetitions
        thisFitness = Compete(preyPopulationParfor(i,:), ...
                              nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulationParfor(i,:), ...
                              nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, gen, false);
        fitness = fitness + thisFitness;
    end
    fitnessParfor(i) = fitness/nCompetitions;
end

for i = 1:length(rows)
    row = rows(i);
    col = cols(i);
    fitnessMatrix(row,col) = fitnessParfor(i);
end

preyFitnesses = mean(fitnessMatrix, 2)';
predatorFitnesses = -mean(fitnessMatrix, 1);

[fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses);

thisFitness = Compete(preyPopulation(1,:), ...
                      nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                      nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                      predatorPopulation(1,:), ...
                      nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                      nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                      deltaT, maxTime, fieldSize, captureDistance, gen, true);