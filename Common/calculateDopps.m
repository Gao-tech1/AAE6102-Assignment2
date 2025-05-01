function dopps = ...
             calculateDopps(trackResults, currMeasSample, ...
             channelList, settings)
         
%calculateDopps finds relative doppler shifts for all satellites
%listed in CHANNELLIST at the specified millisecond of the processed
%signal. The pseudoranges contain unknown receiver clock offset. It can be
%found by the least squares position search procedure. 
%
% [dopps] = ...
%             calculateDopps(trackResults,subFrameStart,currMeasSample, ...
%             channelList, settings)
%
%   Inputs:
%       trackResults    - output from the tracking function
%       subFrameStart   - the array contains positions of the first
%                       preamble in each channel. The position is ms count 
%                       since start of tracking. Corresponding value will
%                       be set to 0 if no valid preambles were detected in
%                       the channel: 
%                       1 by settings.numberOfChannels
%       currMeasSample  - current measurement sample location(measurement time)
%       channelList     - list of channels to be processed
%       settings        - receiver settings
%
%   Outputs:
%       dopps           - doppler shifts to the satellites. 
% Copyright(c) by GAO Yixin
% Updated: 2025/03/11 20:44:30
    
% Transmitting Time of all channels at current measurement sample location
transmitTime = inf(1, settings.numberOfChannels);

%--- For all channels in the list ... 
for channelNr = channelList
    for index = 1: length(trackResults(channelNr).absoluteSample)
        if(trackResults(channelNr).absoluteSample(index) > currMeasSample )
            break
        end 
    end
    index=index-1;
    dopps(channelNr)   =   trackResults(channelNr).carrFreq(index) - settings.IF;
end


