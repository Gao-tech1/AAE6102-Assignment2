function [x_est, P_est] = gnss_ekf(x_est, P_est, vel, obs, sat_pos, settings)
    % Define constants
    dt = settings.navSolPeriod/1000;  % ms to s
    num_satellites = length(sat_pos); % Example number of satellites
    sat_pos=sat_pos';
    
    % State transition matrix
    F = [1 0 0 dt 0 0 0;
         0 1 0 0 dt 0 0;
         0 0 1 0 0 dt 0;
         0 0 0 1 0 0 0;
         0 0 0 0 1 0 0;
         0 0 0 0 0 1 0;
         0 0 0 0 0 0 1];
    
    % Control input matrix
    B = [0 0 0;
         0 0 0;
         0 0 0;
         dt 0 0;
         0 dt 0;
         0 0 dt;
         0 0 0];
    
    % Process noise covariance
    % Q = diag([100, 100, 100, 10, 10, 10, 100]); % for open
    Q = diag([1000, 1000, 1000, 100, 100, 100, 1000]); % for urban
    
    % Measurement noise covariance
    R = diag(ones(1, num_satellites) * 10);
    
    
    % EKF Prediction Step
    x_pred = F * x_est + B * vel;
    P_pred = F * P_est * F' + Q;
    
    % EKF Update Step
    for i = 1:num_satellites
        % Calculate predicted pseudorange
        rho = norm(sat_pos(i, :)' - x_pred(1:3));
        z_pred = rho + x_pred(7);
        
        % Measurement residual
        y = obs(i) - z_pred;
        
        % Jacobian of the measurement model
        H = [-(sat_pos(i, 1) - x_pred(1)) / rho, ...
             -(sat_pos(i, 2) - x_pred(2)) / rho, ...
             -(sat_pos(i, 3) - x_pred(3)) / rho, ...
             0, 0, 0, 1];
        
        % Kalman gain
        S = H * P_pred * H' + R(i, i);
        K = P_pred * H' / S;
        
        % Update state estimate
        x_pred = x_pred + K * y;
        
        % Update estimate covariance
        P_pred = (eye(7) - K * H) * P_pred;
    end
    
    % Updated state and covariance
    x_est = x_pred;
    P_est = P_pred;
    
    disp('Updated state:');
    disp(x_est);
end