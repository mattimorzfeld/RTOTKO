% Example of how to configure and execute RTO (and Occam)

clearvars; close all; clc

%% Paths to core functions and user specified functions
addpath('RTO_CoreFunctions/')           % Path to RTO Code
addpath('UserSpecifiedFunctions/')      % Path to user specified functions;
                                        % contains forward model and data
addpath('SummaryPlotting/')             % Path to plotting and summary routines                                       

%% Get model and data
%% ------------------------------------------------------------------------
ModelConfig = MakeModel;
DataConfig = MakeData;
%% ------------------------------------------------------------------------

%% Configure and run Occam 
%% ------------------------------------------------------------------------
% OccamConfig.TargetRMS = 1;     
% OccamConfig.muRange   = 0:.1:2;     
% OccamConfig.MaxIts    = 30;
% OccamConfig.tol       = 1e-1;
% % Run Occam
% Occam_Out = Occam(OccamConfig, ModelConfig, DataConfig);
% save('OccamResults.mat','Occam_Out','OccamConfig')
load('OccamResults.mat')
%% ------------------------------------------------------------------------

%% Configure & run RTO
%% ------------------------------------------------------------------------
% Configure RTO
RTOConfig.nos       = 50;
RTOConfig.muBounds  = [0.2 3]; 
RTOConfig.muStart   = 1.5;      % log scale 
RTOConfig.TKOFlag   = 0;        % search for mu or keep it 
RTOConfig.MaxRMS    = 3;        % throw out models with large RMS
RTOConfig.StartingModel = Occam_Out.modelEst(:,end);
% Run RTO
RTO_Out = RTOTKO(RTOConfig, ModelConfig, DataConfig);
%% ------------------------------------------------------------------------


%% Summarize & plot results
%% ------------------------------------------------------------------------
% RTO
PlotRTOPosterior(RTO_Out.modelEst,RTO_Out.predRes,RTO_Out.RMS,Occam_Out.modelEst(:,end),Occam_Out.predRes(:,end),1);

% Occam
PrintOutputOccam
PlotOccamResults
%% ------------------------------------------------------------------------
