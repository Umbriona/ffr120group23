function [pos, vel] = UpdateAgentState(pos, vel, inputVectors, T1, W12, T2, W23, maxTurningAngle, stepLength, deltaT, fieldSize)
% computes turn according to NN and updates positions/velocities

nnOutputs = NeuralNetworkComputation(inputVectors, T1, W12, T2, W23);

vel = mod(vel + nnOutputs*maxTurningAngle, 2*pi);

dispX = pos(:,1) + stepLength*cos(vel);
pos(:,1) = mod(dispX,fieldSize);


dispY = pos(:,2) + stepLength*sin(vel);
pos(:,2) = mod(dispY,fieldSize);
