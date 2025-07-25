% Simulated encoder signals (replace these with your actual data)
A = mouseMoveRed;  % A channel
B =mouseMoveBlue;  % B channel

% Ball circumference in centimeters
ball_circumference_cm = 66.04;

% Initialize variables
current_state = 0;
decoded_data = [];
distance_traveled_cm = 0;

% Decode quadrature signals and calculate distance traveled
for i = 1:length(A)
    current_state = current_state * 2 + A(i);
    current_state = mod(current_state, 4);
    
    % Determine direction based on B channel
    if B(i) == 1
        current_state = current_state + 1;
    else
        current_state = current_state - 1;
    end
    
    current_state = mod(current_state, 4);
    
    % Convert to binary and store the decoded data
    binary_value = de2bi(current_state, 2, 'left-msb');
    decoded_data = [decoded_data; binary_value];
    
    % Calculate distance traveled based on quadrature signals
    distance_traveled_cm = distance_traveled_cm + (ball_circumference_cm / 4) * (binary_value(1) * 2 - 1);
end

disp('Decoded Binary Values:');
disp(decoded_data);
disp(['Distance Traveled: ' num2str(distance_traveled_cm) ' cm']);
