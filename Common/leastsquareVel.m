function receiver_velocity = leastsquareVel(satellite_positions, satellite_velocities, receiver_position, doppler_shifts,activeChnList,settings)
    % Arguments:
    % satellite_positions - 3xN matrix of satellite positions [x, y, z]
    % satellite_velocities - 3xN matrix of satellite velocities [vx, vy, vz]
    % receiver_position - 1x3 vector of receiver position [x, y, z]
    % doppler_shifts - Nx1 vector of Doppler shift measurements
    % noise_covariance - NxN noise covariance matrix
    % Calculate the receiver velocity of one epoch
    % Copyright (C) by GAO Yixin
    % Updated: 2025/03/11 23:04:09
    %% =================Initilization of receiver and satellite parameters=========
    CLIGHT = settings.c; % c - Speed of light in m/s ;
    OMGE = 7.2921151467E-5;  % earth angular velocity (IS-GPS) (rad/s)
    lamda = CLIGHT/1.57542e9; % lamda - wavelength of GPS L1 signal; 
    y= lamda * doppler_shifts; %y is the range rate measurement
    % Number of satellites
    N = length(activeChnList);
    receiver_velocity = [0; 0; 0];
    % Iteration settings
    max_iterations = 100;
    tolerance = 1e-3;

    % Form the design matrix
    H = zeros(N, 4);
    distances = zeros(N, 1);
    residue=[];
    for i =1:N
            distances(i) = sqrt(sum((satellite_positions(:,i) - receiver_position(1:3)').^2));% Compute the geometric distances
            e(:,i) = (satellite_positions(:,i) - receiver_position(1:3)') ./ distances(i);
            H(i, 1:3) = -(satellite_positions(:, i)' - receiver_position(1:3)) / distances(i);
            H(i, 4) = 1;
    end

    
    for i=1:max_iterations
    % Compute the relative velocities reference RTKLIB Manual 2.4.2
    % x = [v cddt]' 4*1 vector
    % x(i+1)=x(i) + inv(H'H)*H'*(y-h(x(i))) 
    % Weight Matrix is I
    % h(x(i)) = e*(vs-vr)+omega/c*(vsy*xr+ys*vrx-vsx*yr-xs*vry);
        if i==1 
            x0(1:3)= receiver_velocity;
            x0(4) = 0;
            for j =1:N
             doppler_residue(j)   = y(j) - (e(:,j)'*(satellite_velocities(:,j)'-x0(1:3))' + OMGE/CLIGHT*(satellite_velocities(2,j)*receiver_position(1)-...
                                          satellite_velocities(1,j)*receiver_position(2)));
            end
            x0=x0+(H'*H)^-1*H'*doppler_residue';
            for j =1:N
             doppler_residue(j)   = y(j) - (e(:,j)'*(satellite_velocities(:,j)'-x0(1:3))' + OMGE/CLIGHT*(satellite_velocities(2,j)*receiver_position(1)...
                                    +satellite_positions(2,j)*x0(1)-satellite_velocities(1,j)*receiver_position(2)-satellite_positions(1,j)*x0(2)));
            end
        else
            x1=x0+(H'*H)^-1*H'*doppler_residue';
            x0=x1;
            for j =1:N
             doppler_residue(j)   = y(j) - (e(:,j)'*(satellite_velocities(:,j)'-x0(1:3))' + OMGE/CLIGHT*(satellite_velocities(2,j)*receiver_position(1)...
                                    +satellite_positions(2,j)*x0(1)-satellite_velocities(1,j)*receiver_position(2)-satellite_positions(1,j)*x0(2)));
            end
        end
        residue=[residue norm(doppler_residue)];
        if norm(doppler_residue)< tolerance
                break;
        end
    end
    receiver_velocity=x1(1:3);