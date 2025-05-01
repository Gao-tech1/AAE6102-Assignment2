function [pos,el, az, dop] = leastSquarePos_RAIM(satpos,obs,settings,P_fa, P_md,sigma_pr)
%Function calculates the Least Square Solution.
%
%[pos, el, az, dop] = leastSquarePos(satpos, obs, settings);
%
%   Inputs:
%       satpos      - Satellites positions (in ECEF system: [X; Y; Z;] -
%                   one column per satellite)
%       obs         - Observations - the pseudorange measurements to each
%                   satellite corrected by SV clock error
%                   (e.g. [20000000 21000000 .... .... .... .... ....]) 
%       settings    - receiver settings
%
%   Outputs:
%       pos         - receiver position and receiver clock error 
%                   (in ECEF system: [X, Y, Z, dt]) 
%       el          - Satellites elevation angles (degrees)
%       az          - Satellites azimuth angles (degrees)
%       dop         - Dilutions Of Precision ([GDOP PDOP HDOP VDOP TDOP])

%--------------------------------------------------------------------------
%                           SoftGNSS v3.0
%--------------------------------------------------------------------------
%Based on Kai Borre
%Copyright (c) by Kai Borre
%Updated by Darius Plausinaitis, Peter Rinder and Nicolaj Bertelsen
%
% CVS record:
% $Id: leastSquarePos.m,v 1.1.2.12 2006/08/22 13:45:59 dpl Exp $
%==========================================================================

%=== Initialization =======================================================
if nargin < 4, P_fa = 1e-5; end
if nargin < 5, P_md = 1e-7; end
if nargin < 6, sigma_pr = 3; end % 默认伪距噪声3米

nmbOfIterations = 10;

dtr     = pi/180;
pos     = zeros(4, 1);   % center of earth
X       = satpos;
nmbOfSatellites = size(satpos, 2);
original_sats = 1:size(X,2); % 记录原始卫星索引
excluded_sats = [];          % 被排除的卫星


A       = zeros(nmbOfSatellites, 4);
omc     = zeros(nmbOfSatellites, 1);
az      = zeros(1, nmbOfSatellites);
el      = az;
W = zeros(nmbOfSatellites,nmbOfSatellites);
%=== Iteratively find receiver position ===================================
% --- RAIM主循环 ---
for raim_stage = 1:3 % 最多尝试排除3颗卫星
    for iter = 1:nmbOfIterations
    
        for i = 1:nmbOfSatellites
            if iter == 1
                %--- Initialize variables at the first iteration --------------
                Rot_X = X(:, i);
                trop = 2;
                W(i,i)=1; % add by Yixin
                x=[0 0 0 0]';
            else
                %--- Update equations -----------------------------------------
                rho2 = (X(1, i) - pos(1))^2 + (X(2, i) - pos(2))^2 + ...
                       (X(3, i) - pos(3))^2;
                traveltime = sqrt(rho2) / settings.c ;
    
                %--- Correct satellite position (do to earth rotation) --------
                % Convert SV position at signal transmitting time to position 
                % at signal receiving time. ECEF always changes with time as 
                % earth rotates.
                Rot_X = e_r_corr(traveltime, X(:, i));
                
                %--- Find the elevation angel of the satellite ----------------
                [az(i), el(i), ~] = topocent(pos(1:3, :), Rot_X - pos(1:3, :));
                W(i,i) = (sin(el(i)))^2; % add by Yixin
                
                if (settings.useTropCorr == 1)
                    %--- Calculate tropospheric correction --------------------
                    trop = tropo(sin(el(i) * dtr), ...
                                 0.0, 1013.0, 293.0, 50.0, 0.0, 0.0, 0.0);
                else
                    % Do not calculate or apply the tropospheric corrections
                    trop = 0;
                end
                
            end % if iter == 1 ... ... else 
    
            %--- Apply the corrections ----------------------------------------
            omc(i) = ( obs(i) - norm(Rot_X - pos(1:3), 'fro') - pos(4) - trop ); 
    
            %--- Construct the A matrix ---------------------------------------
            A(i, :) =  [ (-(Rot_X(1) - pos(1))) / norm(Rot_X - pos(1:3), 'fro') ...
                         (-(Rot_X(2) - pos(2))) / norm(Rot_X - pos(1:3), 'fro') ...
                         (-(Rot_X(3) - pos(3))) / norm(Rot_X - pos(1:3), 'fro') ...
                         1];
            
        end % for i = 1:nmbOfSatellites
        
        % These lines allow the code to exit gracefully in case of any errors
        if rank(A) ~= 4
            pos     = zeros(1, 4);
            dop     = inf(1, 5);
            fprintf('Cannot get a converged solotion! \n');
            return
        end
        if rank(A'*W*A) < 4
            pos = zeros(1,4); dop = inf(1,5); PL_3D = inf;
            return
        end
        %--- Find position update (in the weighted least squares sense)-----------------
        x   = (A'*W*A)^(-1)*A'*W*omc;
        % x   = A \ omc;
         % exclude isolate obs
    
        
        %--- Apply position update --------------------------------------------
        pos = pos + x;
      
        
    end % for iter = 1:nmbOfIterations
    
    % --- RAIM故障检测 ---
    residuals = omc; % 获得最终残差
    S = eye(size(A,1)) - A/(A'*W*A)*A'*W; % 残差敏感矩阵
    sigma_res = sigma_pr * sqrt(diag(S)); % 残差标准差
    normalized_res = abs(residuals)./sigma_res;
    
    % 计算测试统计量
    SSE = residuals' * W * residuals;
    threshold = chi2inv(1 - P_fa, size(A,1)-4); % 卡方阈值
    
    % --- 故障判断 ---
    if SSE < threshold
        break; % 无故障，退出RAIM循环
    else
        % 排除残差最大的卫星
        [~, worst_idx] = max(normalized_res);
        excluded_sats = [excluded_sats, original_sats(worst_idx)];
        
        % 更新卫星列表
        X(:,worst_idx) = [];
        original_sats(worst_idx) = [];
        obs(worst_idx) = [];
        
        % 检查剩余卫星数量
        if size(X,2) < 5
            warning('RAIM: 剩余卫星不足5颗，无法继续排除');
            break;
        end
    end
end

%--- Fixing resulut -------------------------------------------------------
pos = pos';

% --- 保护等级计算 ---

    k_fa = norminv(1 - P_fa/2);
    k_md = norminv(1 - P_md);
    lambda = (k_fa + k_md)^2;
    
    Q = inv(A'*W*A);
    s = sqrt(diag(A*Q*A'));
    PL_3D = max(s) * sigma_pr * sqrt(lambda);


AL_3D = 50; % 3D告警限值
if PL_3D > AL_3D
    warning('完整性风险：PL=%.2fm > AL=%.2fm', PL_3D, AL_3D);
end
figure;
plot(normalized_res, 'bo', 'MarkerFaceColor','b');
hold on;
plot(xlim, [sqrt(threshold)*[1 1]], 'r--');
xlabel('Satellite Index');
ylabel('Normalized Residual');
legend('残差','检测阈值');
%=== Calculate Dilution Of Precision ======================================
if nargout  == 4
    %--- Initialize output ------------------------------------------------
    dop     = zeros(1, 5);
    
    %--- Calculate DOP ----------------------------------------------------
    Q       = inv(A'*A);
    
    dop(1)  = sqrt(trace(Q));                       % GDOP    
    dop(2)  = sqrt(Q(1,1) + Q(2,2) + Q(3,3));       % PDOP
    dop(3)  = sqrt(Q(1,1) + Q(2,2));                % HDOP
    dop(4)  = sqrt(Q(3,3));                         % VDOP
    dop(5)  = sqrt(Q(4,4));                         % TDOP
end  % if nargout  == 4
