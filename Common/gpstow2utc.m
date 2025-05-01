function utc_time = gpstow2utc(gps_week, tow)
    % GPSTOW2UTC 将GPS周和TOW转换为UTC时间
    %   UTC_TIME = GPSTOW2UTC(GPS_WEEK, TOW) 将GPS周和TOW转换为UTC时间
    %
    % 输入:
    %   GPS_WEEK - GPS周数 (整数)
    %   TOW - 一周内的秒数 (0到604800秒)
    %
    % 输出:
    %   UTC_TIME - UTC时间 (datetime对象)
    % Writen by：GAO Yixin 2025/03/11

    % GPS时间从1980年1月6日开始
    gps_epoch = datetime('1980-01-06 00:00:00', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
    
    % 计算从GPS时间起点到当前GPS周的总秒数
    total_seconds = (gps_week * 7 * 24 * 3600) + tow;
    
    % 转换为UTC时间（不考虑闰秒）
    utc_candidate = gps_epoch + seconds(total_seconds);
    
    % 获取当前GPS周的UTC偏移量（闰秒）
    utc_offset = get_utc_offset(gps_week);
    
    % 调整UTC时间以考虑闰秒
    utc_time = utc_candidate - seconds(utc_offset);
    
    % 设置输出时间格式
    utc_time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
end

function offset = get_utc_offset(gps_week)
    % GET_UTC_OFFSET 获取给定GPS周的UTC偏移量（闰秒）
    %   OFFSET = GET_UTC_OFFSET(GPS_WEEK) 返回GPS周对应的UTC偏移量（秒）
    
    % 闰秒表（截至2023年，总共有37个闰秒）
    leap_seconds = [10, 17, 24, 31, 38, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99, 102, 105, 108, 111, 114, 117, 120, 123, 126, 129, 132, 135, 137];
    leap_weeks = [780, 883, 1001, 1116, 1290, 1415, 1509, 1603, 1697, 1883, 2009, 2185, 2374, 2563, 2752, 2940, 3129, 3317, 3506, 3695, 3883, 4072, 4261, 4449, 4638, 4826, 5015, 5203, 5392, 5581, 5769, 5958, 6146, 6335, 6523, 6712, 6901, 7089, 7278, 7467, 7655];
    
    % 找到小于等于当前GPS周的最大闰秒周
    idx = find(leap_weeks <= gps_week, 1, 'last');
    
    % 如果没有找到，则偏移量为0
    if isempty(idx)
        offset = 0;
    else
        offset = leap_seconds(idx);
    end
end