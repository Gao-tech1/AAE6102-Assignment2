function plot_skymask(navSolutions)
    % 读取skymask数据（示例CSV格式：第一列为Az，第二列为El）
    M = readmatrix('../skymask_A1_urban.csv');
    az = M(:,1);
    el = M(:,2);
    
    % 预处理：将Az四舍五入到整数并插值到0-360度
    maskElVec = nan(361,1);
    for i = 1:numel(az)
        a = round(mod(az(i), 360));  % 确保方位角在0-359范围内
        maskElVec(a+1) = el(i);      % MATLAB索引从1开始
    end
    
    % 线性插值填充缺失值
    idx = find(~isnan(maskElVec));
    maskElVec = interp1(idx-1, maskElVec(idx), (0:360)', 'linear', 'extrap');
    
    % 创建极坐标
    theta = deg2rad(0:360);       % 方位角（0-360度转弧度）
    r = 90 - maskElVec;           % 高度角转换为半径（El=90在中心，El=0在边缘）
    
    % 绘制设置
    fig = figure();
    ax = polaraxes(fig);
    
    % 极坐标轴参数调整
    ax.ThetaZeroLocation = 'top';     % 0度指向正北
    ax.ThetaDir = 'clockwise';        % 顺时针方向增加角度
    ax.RLim = [0 90];                 % 半径范围（对应El=90到0）
    ax.RTick = 0:15:90;               % 半径刻度
    ax.RTickLabel = compose('%d°',90:-15:0); % 显示实际高度角标签
    
    % 绘制skymask轮廓
    hold(ax, 'on');
    polarplot(ax, theta, r, 'k-', 'LineWidth', 1.5);
    
    % 填充遮挡区域（转换为笛卡尔坐标）
    [x,y] = pol2cart(theta, r);
    %fill(ax, x, y, [1 0.5 0.5], 'FaceAlpha', 0.3, 'EdgeColor','none');
    
    % 添加参考圆（地平线）
    polarplot(ax, theta, ones(size(theta))*90, 'k--', 'LineWidth', 0.5);
        satellites = [navSolutions.az(1:4,end), navSolutions.el(1:4,end)];
    
    % 绘制每个卫星
    for i = 1:size(satellites,1)
        Az = satellites(i,1);
        El = satellites(i,2);
        
        % 坐标转换
        theta_rad = deg2rad(Az); 
        r = 90 - El;                  % 半径转换
        
        % 计算卫星坐标
        x = r * cos(theta_rad);
        y = r * sin(theta_rad);
        x=theta_rad;
        y=r;
        % 判断卫星是否可见
        az_idx = round(mod(Az,360)) + 1;
        if El > maskElVec(az_idx)
            color = [0 0.8 0]; % 可见卫星用绿色
        else
            color = [0.8 0 0]; % 被遮挡卫星用红色
        end
        
        % 绘制卫星标记
        polarplot(ax, x, y, 'o', 'MarkerSize', 10, ...
            'MarkerFaceColor', color, 'MarkerEdgeColor', 'k');
        
        % 添加卫星标签
        text(ax, x, y, sprintf('SV%d', navSolutions.PRN(i,end)),...
            'Color', color, 'FontWeight','bold',...
            'HorizontalAlignment','left', 'VerticalAlignment','bottom');
    end

    % 添加标题和图例
    title(ax, 'Skymask Visualization');
    legend(ax, 'Skymask', 'Not Visible', 'Horizon', 'Location','southoutside');
end


