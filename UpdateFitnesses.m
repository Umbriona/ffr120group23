function [fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = UpdateFitnesses(fitnessMatrix, ...
                              preyPopulation, nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation, nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, nCompetitions, gen)
% run a number of simulations to fill in the missing fitnesses in our
% fitnessMatrix

fprintf("\nGeneration %d\n----\n", gen);

[rows, cols] = find(~fitnessMatrix); % selects all (i,j) where fitnessMatrix(i,j)==0
for i = 1:length(rows)
    row = rows(i);
    col = cols(i);
    fprintf("Evaluating prey %2d vs predator %2d ... ", row, col);
    fitness = 0;
    for n = 1:nCompetitions
        thisFitness = Compete(preyPopulation(row,:), ...
                              nPreyAgents, nPreyNeighbors, maxPreyTurningAngle, preyStepLength, ...
                              nPreyNNInputs, nPreyNNHidden, nPreyNNOutputs, ...
                              predatorPopulation(col,:), ...
                              nPredatorAgents, nPredatorNeighbors, maxPredatorTurningAngle, predatorStepLength, ...
                              nPredatorNNInputs, nPredatorNNHidden, nPredatorNNOutputs, ...
                              deltaT, maxTime, fieldSize, captureDistance, gen);
        fitness = fitness + thisFitness;
    end
    fitnessMatrix(row,col) = fitness/nCompetitions;
    fprintf("average time elapsed = %6.2fs\n", fitnessMatrix(row,col));
end

preyFitnesses = mean(fitnessMatrix, 2)';
predatorFitnesses = -mean(fitnessMatrix, 1);

[fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses] = SortPopulation(fitnessMatrix, preyPopulation, preyFitnesses, predatorPopulation, predatorFitnesses);

%TODO: create RecordExemplaryContest function and record contest between best
%      prey and best predator in the population to a GIF