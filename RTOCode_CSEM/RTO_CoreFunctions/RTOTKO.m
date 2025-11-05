function RTO_Out = RTOTKO(RTOConfig, ModelConfig, DataConfig)

% RTO-TKO
%
% Inputs:
%   RTOConfig                 - Configuration of RTO-TKO
%   RTOConfig.nos             - Number of RTO-TKO samples
%
% Outputs:
%   RTO_Out.modelEst  - Posterior samples
%   RTO_Out.predRes   - Responses of posterior samples
%   RTO_Out.RMS       - RMS of posterior samples
%   RTO_Out.nos       - Number of posterior samples
    
% Pre-allocate arrays
nos = RTOConfig.nos;
Ms  = zeros(ModelConfig.nm,nos);
Ds  = zeros(DataConfig.nd,nos);
RMS = zeros(nos,1); 
mus = zeros(nos,1);

% Data and associated errors
d = DataConfig.d;
s = DataConfig.s;
y = s.\d;

% model and data sizes
nm = ModelConfig.nm;
nd = DataConfig.nd;

% starting value for mu
mu = RTOConfig.muStart;

% starting model
uo = RTOConfig.StartingModel;

% regularization matrix
D = getD(ModelConfig);

disp(' ')
fprintf('   RTO-TKO \n');
fprintf('========================\n');
for kk=1:nos
    %% RTO
    ypert = y+randn(nd,1);
    mp = randn(nm,1);
    mOpt = MyMinLS2(uo,ypert,mp,mu,ModelConfig,DataConfig,D);
    dpred = F(mOpt,ModelConfig,DataConfig);
    rmseOpt = sqrt(mean((s.\(d-dpred)).^2));

    %% Save
    RMS(kk)  = rmseOpt;
    Ms(:,kk) = mOpt;
    Ds(:,kk) = dpred;
    mus(kk)  = mu;

    if RTOConfig.TKOFlag == 1
        %% TKO
        ypert = y+randn(nd,1);
        mu = MyMinLS2hp(0,mOpt,mu,ypert,ModelConfig,DataConfig,RTOConfig);
    end

    %% Show progress
    % if mod(kk,10)==0
        fprintf(['Sample %g/%g. RMS = %g, ' char(956),' = %g \n'],kk,nos,RMS(kk),mus(kk))
    % end
end
fprintf('========================\n');


%% filter out bad models/failed optimization attempts
goodinds = find(RMS<RTOConfig.MaxRMS);
Ms = Ms(:,goodinds);
Ds = Ds(:,goodinds);
RMS = RMS(goodinds);

% Save to output struct
RTO_Out.modelEst = Ms;
RTO_Out.predRes = Ds;
RTO_Out.RMS = RMS;
RTO_Out.nos = length(RMS);


end