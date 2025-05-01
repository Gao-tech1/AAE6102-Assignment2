function [Updated_mat, Detect_results] = chi2_detector(y, W, G, Nr_sat,isolation_mat)
    % ==============Inputs================ %
    % isolation_mat: define a certain fault mode
    % ==============Outputs=============== %
    % Update_mat: return the processed W, G matrices that stand to the certain fault mode
    % Detect_results: return the value of test statistics and the Threshold under the certain fault model
    P_fa = 1e-2;

    % if nargin == 4
    %     isolation_mat = ones(Nr_sat, 1);
    % end

    %% prepare I, P, G, W, y to calculate WSSE
    % P = G*K = G(G^T*W*G)^(-1)*G^T*W
    % Update measurement vector/ weighting matrix/ observation matrix
    y = isolation_mat .* y;
    W = W * diag(isolation_mat);
    G = diag(isolation_mat) * G;
    % Calculate K and P
    K = inv(G'*W*G)*G'*W;
    P = G*K;
    % modify I_nn
    I = eye(Nr_sat);   
    I = I * diag(isolation_mat);


    Updated_mat.W = W;
    Updated_mat.G = G;


    %% calculate WSSE
    if sum(isolation_mat) > 4
        Thres = sqrt(chi2inv(1-P_fa, sum(isolation_mat)-4));
    else
        Thres = NaN;
    end

    % if allSettings.sys.raim_type == 0  % RAIM
    %     WSSE_sqrt = sqrt(y'*W*(I-P)*y ./ (sum(isolation_mat)-4));
    % elseif allSettings.sys.raim_type == 1  % Weighted RAIM
        WSSE_sqrt = sqrt(y'*W*(I-P)*y);
    % end
    
    Detect_results.WSSE_sqrt = WSSE_sqrt;
    Detect_results.Thres = Thres;
    Detect_results.fault_confirmed = (WSSE_sqrt>Thres);
end
