function ModelConfig = MakeModel()
%% 1D grid (uniform)
depth          = 1200;                                  % depth
ModelConfig.lt = 20;                                    % layer thickness                                     
ModelConfig.z  = ModelConfig.lt:ModelConfig.lt:depth;   % grid  
ModelConfig.nm = length(ModelConfig.z);                 % number of layers
ModelConfig.h  = ModelConfig.lt*ones(ModelConfig.nm,1); % helper vector

%% For CSEM
ModelConfig.waterDepth = 34.22;      % depth to the seafloor (this matters A LOT for CSEM)
ModelConfig.waterRho = -0.62;        % log(ohm-m), resistivity of seawater. Likewise matters A LOT

%% Required: the initial model
ModelConfig.mo = 2*ones(ModelConfig.nm,1);              % initial model
