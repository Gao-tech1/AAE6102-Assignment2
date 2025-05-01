function x = rec_vel(navSolutions,trackResults,settings,t)
% calculate receiver velocity with raw doppler
% Created by. YMD 2025/03/10
% Updated by GAO Yixin 2025/3/11

wavelength = settings.c/1.57542e9;
sat_poss=navSolutions.satPositions;
sat_velo=navSolutions.satVelocity;
rec_poss=[navSolutions.X;navSolutions.Y;navSolutions.Z];
rec_velini=zeros(3,1);

pseudoranges=navSolutions.correctedP(:, t);
pseudoranges=pseudoranges(~isinf(abs(pseudoranges)));
dt=1;

% decide the time for doppler measurements
times_dp=[];dopplers=[];
for k=1:length(trackResults)
    if(trackResults(k).status=='T')
        time_dp=trackResults(k).absoluteSample/settings.samplingFreq;
        dopp=trackResults(k).carrFreq-settings.IF;
        times_dp=[times_dp;time_dp];
        dopplers=[dopplers;dopp];
    end
end

dopplers_avg=[];

doppler_avg=zeros(size(times_dp,1),1);
for k=1:size(times_dp,1)
    % index=find(abs(times_dp(k,:)-t)<=0.001);
    index_p=find(abs(times_dp(k,:)-t+0.5)<=0.0005);
    index_l=find(abs(times_dp(k,:)-t-0.5)<=0.0005);
    doppler_avg(k)=mean(dopplers(k,index_p:index_l));
end
dopplers_avg=[dopplers_avg,doppler_avg];

est_vel=[];

sats_pos=sat_poss{t};
rec_pos=rec_poss(:,t);

% init matrix
u=(repmat(rec_pos,1,size(times_dp,1))-sats_pos)./repmat(pseudoranges,1,3)';
B=[u',ones(size(u,2),1)];
C=[];
for i=1:size(times_dp,1)
    C0=u(:,i)'*sat_velo{t}(:,i)+wavelength*dopplers_avg(i);
    C=[C;C0];
end
x=(B'*B)\(B'*C);