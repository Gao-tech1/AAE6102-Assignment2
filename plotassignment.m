clc
clear
close all
% load navSolutions_urban_LS.mat
% lat_ls=navSolutions.latitude;
% lon_ls=navSolutions.longitude;
% alt_ls=navSolutions.height;
% E_ls=navSolutions.E;
% N_ls=navSolutions.N;
% U_ls=navSolutions.U;
% clear navSolutions_urban_WLS.mat
% lat_wls=navSolutions.latitude;
% lon_wls=navSolutions.longitude;
% alt_wls=navSolutions.height;
% E_wls=navSolutions.E;
% N_wls=navSolutions.N;
% U_wls=navSolutions.U;
% load trackingResults.mat
% 
% 
% 
% utc_time = gpstow2utc(settings.gpsweek, navSolutions.localTime)
% figure("Name",'Position obtained from LS and WLS')
% % plot(lat_ls,lon_ls,'b.');hold on;
% plot(lon_wls,lat_wls,'.');hold on;
% plot(114.209101777778,22.3198722, '*');
% legend('WLS','Ground Truth');
% xlabel('Longitude(°E)');
% ylabel(['Latitude(°N)']);
% %legend('LS','WLS','Ground Truth');
% title('Position obtained from LS and WLS','FontWeight','bold');
% set(gca,'Fontname','Times New Roman');
% 
% 
% 
% 
% 
% figure("Name",'Velocity Result obtained from EKF and WLS')
% title ('Velocity Result obtained from EKF and WLS','FontWeight','bold');
% subplot(3,1,1)
% plot(utc_time,navSolutions.Vx_ekf);hold on;
% plot(utc_time,navSolutions.Vx,'-.');hold on;
% legend('Vx_{EKF}','Vx');
% xlabel ('Time');
% ylabel ('Velocity_x (m/s)');
% subplot(3,1,2)
% plot(utc_time,navSolutions.Vy_ekf);hold on;
% plot(utc_time,navSolutions.Vy,'-.');hold on;
% legend('Vy_{EKF}','Vy');
% xlabel ('Time');
% ylabel ('Velocity_y (m/s)');
% subplot(3,1,3)
% plot(utc_time,navSolutions.Vz_ekf);hold on;
% plot(utc_time,navSolutions.Vz,'-.');hold on;
% legend('Vz_{EKF}','Vz');
% xlabel ('Time');
% ylabel ('Velocity_z (m/s)');
% 
% figure("Name",'Velocity Result obtained from EKF and WLS')
% title ('Velocity Result obtained from EKF and WLS','FontWeight','bold');
% subplot(2,1,1)
% plot(utc_time,navSolutions.Vx_ekf);hold on;
% plot(utc_time,navSolutions.Vy_ekf);hold on;
% plot(utc_time,navSolutions.Vz_ekf);hold on;
% legend('Vx_{EKF}','Vy_{EKF}','Vz_{EKF}');
% xlabel ('Time');
% ylabel ('Velocity_{EKF} (m/s)');
% subplot(2,1,2)
% plot(utc_time,navSolutions.Vx);hold on;
% plot(utc_time,navSolutions.Vy);hold on;
% plot(utc_time,navSolutions.Vz);hold on;
% legend('Vx','Vy','Vz');
% xlabel ('Time');
% ylabel ('Velocity_{WLS} (m/s)');
% 
% 
% % Generate correlation plots for the tracking results
% figure("Name",'Multicorrelator');
% for i=1:fix(settings.msToProcess/10000)
%     subplot(2,2,i)
%     for j=1:4
%         for k=1:length(trackResults(j).I_multi{i*10000})
%             mag(k)=sqrt(trackResults(j).I_multi{i*10000}(k)^2+trackResults(j).Q_multi{i*10000}(k)^2);
%         end
%         plot(mag,'-o', 'LineWidth', 1); hold on;
%     end
%     xlabel ('Chip');
%     ylabel ('Amplitude');
%     % title(['Correlator Outputs with Multiple Offsets at ', num2str(10*i), 's']);
%     % legend('Channel 1','Channel 2', 'Channel 3', 'Channel 4', 'Channel 5');
%     title([num2str(10*i), 's']);
% end
% legend('Channel 1','Channel 2', 'Channel 3', 'Channel 4');
% 
% figure("Name",'WLS_EKF_basemap')
% geobasemap('streets-light'); % 设置底图类型为街道图
% plot(22.3198722, 114.209101777778,'k+');
% geoscatter(navSolutions.latitude,navSolutions.longitude,'b.');hold on;
% geoscatter(mean(navSolutions.latitude),mean(navSolutions.longitude),'r.');hold on;
% geoscatter(navSolutions.latitude_ekf,navSolutions.longitude_ekf,'g*');hold on;
% geoscatter(mean(navSolutions.latitude_ekf),mean(navSolutions.longitude_ekf),'*');hold on;
% legend('Ground Truth','WLS','mean WLS','EKF','mean EKF');

%% LLA2ENU
load navSolutions_opensky.mat
figure;
for i=1:length(navSolutions.latitude)
    LLA(i,:)=[navSolutions.latitude(i),navSolutions.longitude(i),navSolutions.height(i)];
    LLA_GT=[22.328444770087565,114.1713630049711,3];
    ENU(i,:)=lla2enu(LLA(i,:),LLA_GT,'flat');
    ENU_error(i)=norm(ENU(i,:));
    PL_3d(i)=navSolutions.raim(3,i);
end    
AL_3D=50;
scatter(ENU_error, PL_3d,'filled'); hold on;
plot([0, 60], [0, 60], 'k--', 'LineWidth', 2);  
plot([0, 60], [AL_3D, AL_3D], 'k--', 'LineWidth', 2);  % 水平线
plot([AL_3D, AL_3D], [0, 60], 'k--', 'LineWidth', 2);  % 垂直线
ylabel('3D Position Error (m)'); 
xlabel('3D Protection Level (m)');  
title('Stanford Chart for RAIM Integrity Monitoring');  
legend('Epochs', 'Alarm Limit', 'Location', 'northwest');  
grid on;
