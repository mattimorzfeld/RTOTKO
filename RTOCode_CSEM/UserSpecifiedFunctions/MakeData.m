function DataConfig = MakeData()
load('CSEMdata.mat');                                        % Load MT data and get it into a structure
% DataConfig.d = [MTdata.TEappRes' ; MTdata.TEphase'];         % data, log apparent resistivity and phase
% DataConfig.s = [MTdata.TEappResErr' ; MTdata.TEphaseErr'];   % errors, log domain
% DataConfig.f = MTdata.freqs';                                % frequencies
% DataConfig.nd = length(DataConfig.d);                        % number of data


DataConfig.CSEM = csem;
tmp1 = reshape(csem.stDat.Er,size(csem.stDat.Er,1)*size(csem.stDat.Er,2),1);
tmp2 = reshape(csem.stDat.Phase,size(csem.stDat.Phase,1)*size(csem.stDat.Phase,2),1);
DataConfig.d = [tmp1; tmp2];
tmp1 = reshape(csem.stDat.ErErr,size(csem.stDat.ErErr,1)*size(csem.stDat.ErErr,2),1);
tmp2 = reshape(csem.stDat.PhaseErr,size(csem.stDat.PhaseErr,1)*size(csem.stDat.PhaseErr,2),1);
DataConfig.s = [tmp1; tmp2];
DataConfig.f = csem.stDat.Freqs;
DataConfig.nd = length(DataConfig.d);
