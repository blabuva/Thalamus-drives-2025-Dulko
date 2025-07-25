function [timeCenters,speed] = calcualateSpeed_ela_241130(moveData,timeData)

% Constants
EncoderCPR = 100; % Counts per revolution
DegreesinaWheel = 360; % Degrees in a circle
Ball_Circumference = 66.04; % cm
distPulse = Ball_Circumference / EncoderCPR; % Distance per pulse in cm

% Determine the duration of 250 ms in timeData units
timeStep = 0.250; % 250 ms in seconds

% Initialize
numSteps = ceil((timeData(end) - timeData(1)) / timeStep);
speed = zeros(numSteps, 1); % Preallocate speed array
timeIntervals = timeData(1) : timeStep : timeData(end); % Define time bins

% Calculate speed in each 100 ms segment
for i = 1:numSteps
    % Define the time range for the current segment
    tStart = timeIntervals(i);
    tEnd = tStart + timeStep;
    
    % Find indices of movement within this time range
    idx = (timeData >= tStart) & (timeData < tEnd);
    
    % Count pulses in this time segment
    numPulses = sum(moveData(idx));
    
    % I noticed that the ball sends two pulses insted of one so we need to
    % divide 
    RealNumPulses = numPulses/2; 

    % Calculate speed (distance/time)
    distance = RealNumPulses * distPulse; % Total distance in cm
    speed(i) = distance / timeStep; % Speed in cm/s

    % Store the midpoint of the current time interval
    timeCenters(i) = (tStart + tEnd) / 2;
end




end 