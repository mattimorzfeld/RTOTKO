function d_out = callCSEM(rho,DataConfig,ModelConfig)

   % allocate output E-field array
   Efield = zeros(length(DataConfig.f),size(DataConfig.CSEM.stRx.X,1));
   
   % get the model in the form required by Dipole1D
   z = [ -100d3 ; 0.0 ; ModelConfig.waterDepth ; (ModelConfig.z + ModelConfig.waterDepth)' ];
   rho = [ 1d12 ; 10^(ModelConfig.waterRho) ; 10.^(rho) ; 10.^(rho(end)) ];
   model = [ z rho ];
   
   % get transmitter/receiver geometry arrays in right form for Dipole1D
   Rx = [ DataConfig.CSEM.stRx.X DataConfig.CSEM.stRx.Y DataConfig.CSEM.stRx.Z ];
   Tx = [ DataConfig.CSEM.stTx.X DataConfig.CSEM.stTx.Y DataConfig.CSEM.stTx.Z DataConfig.CSEM.stTx.Azimuth DataConfig.CSEM.stTx.Dip ];
   
   % compute the electric fields
   for k=1:length(DataConfig.f)
      allFields = Dipole1D(Tx,DataConfig.f(k),model,Rx,0,0,DataConfig.CSEM.stTx.Length,3);
      Efield(k,:) = allFields(:,5); %column 5 is the inline E-field
   end

   % compute Er amplitude and phase
   Er = log10(abs(Efield));
   Phase = (180/pi)*atan2(imag(Efield),real(Efield));
   
   % load the field responses into the output array
   tmp1 = reshape(Er,size(Er,1)*size(Er,2),1);
   tmp2 = reshape(Phase,size(Phase,1)*size(Phase,2),1);
   d_out = [tmp1; tmp2];  
end

