function [MMean,MMode,p5_RTO,p95_RTO]=PlotRTOPosterior(Ms,Ds,RMS,mOccam,dOccam,PlotFlag)
Color = brewermap(8,'Dark2');

% load('CSEMdata.mat');
% 
% d = [MTdata.TEappRes' ; MTdata.TEphase'];         % data, log apparent resistivity and phase
% f = MTdata.freqs'; nf = length(f);                % frequencies
% s = [MTdata.TEappResErr' ; MTdata.TEphaseErr'];   % errors, log domain

lt = 20;                                          % layer thickness, (m)
z = lt:lt:1200;     

nlayers = length(z);
brho = [-1 3];
rhoBins = brho(1):0.05:brho(2);

rhoAxis = (rhoBins(2:end)+rhoBins(1:end-1))/2;
nBins = length(rhoBins)-1;

posteriorPDF_RTO = zeros(nlayers,nBins);
p5_RTO = zeros(nlayers,1);
p95_RTO = zeros(nlayers,1);

for ilayer=1:nlayers
   figure(99)
   tmpinds = imag(Ms(ilayer,:))==0; tmp = Ms(ilayer,tmpinds);
   a = histogram(tmp,rhoBins,'Normalization','pdf');
   posteriorPDF_RTO(ilayer,:) = a.Values;
   p5_RTO(ilayer) = prctile(tmp,5);
   p95_RTO(ilayer) = prctile(tmp,95);
   close 99
end

MMean = mean(Ms,2);
[~,minRMSind]=min(RMS);
MMode = Ms(:,minRMSind);

if PlotFlag == 1

    figure
    histogram(RMS,'Normalization','pdf','FaceColor',[.2 .2 .2],'FaceAlpha',.2);
    set(gcf,'Color','w')
    set(gca,'FontSize',16)
    xlabel('RMS')
    ylabel('pdf')
    xlim([0.8 2])
    box off

    randinds = randi(size(Ms,2),200,1);
    figure, hold on
    stairs(Ms(end:-1:1,randinds),(z'-z(end))*ones(1,200),'Color',Color(1,:),'LineWidth',1);
    stairs(mOccam(end:-1:1),(z'-z(end))*ones(1,200),'Color',Color(2,:),'LineWidth',3);
    ylabel('Depth (m)');xlabel('Log_{10} resistivity (\Omega m)');
    set(gcf,'color','w')
    set(gca,'FontSize',20)
    box off
    xlim([-1 3])


    % figure
    % subplot(121), hold on
    % plot(1./f,Ds(1:nf,randinds),'Color',Color(1,:),'LineWidth',1)
    % plot(1./f,dOccam(1:nf),'Color',Color(2,:),'LineWidth',4)
    % errorbar(1./f, d(1:nf), 2*s(1:nf), 'ko');
    % xlabel('Period (s)');ylabel('Log_{10} \rho_a (\Omega m)');
    % set(gcf,'color','w')
    % set(gca,'XScale','log')
    % set(gca,'FontSize',20)
    % box off
    % 
    % subplot(122), hold on
    % plot(1./f,Ds(nf+1:end,randinds),'Color',Color(1,:),'LineWidth',1)
    % plot(1./f,dOccam(nf+1:end),'Color',Color(2,:),'LineWidth',4)
    % errorbar(1./f, d(nf+1:end), 2*s(nf+1:end),'ko');
    % xlabel('Period (s)');ylabel('phase (^o)');
    % set(gcf,'color','w')
    % set(gca,'XScale','log')
    % set(gca,'FontSize',20)
    % box off

    figure
    fhand = pcolor(rhoAxis,z,log10(posteriorPDF_RTO));
    mycolormap = magma(256); %mycolormap(1:5,:) = 1; 
    colormap(mycolormap)
    set(fhand,'EdgeColor','none')
    set(gca,'YDir','reverse')
    colorbar
    hold on
    MMean = [MMean(1,end); MMean(1:end-1,end)];
    p5_ = [p5_RTO(1); p5_RTO(1:end-1)]; p95_ = [p95_RTO(1); p95_RTO(1:end-1)];
    stairs(MMean,z,'Color',Color(8,:),'linewidth',3)
    stairs(p5_,z,'Color',Color(4,:),'linewidth',2)
    stairs(p95_,z,'Color',Color(4,:),'linewidth',2)
    stairs(mOccam,z,'w','linewidth',4)
    xlabel('Log_{10} \rho_a (\Omega m)')
    ylabel('Depth (m)')
    set(gca,'FontSize',16)
    % set(gcf,'position',[560 238 478 710])
    set(gcf,'Color','w')
    xlim([-1 3])

    % FileName = strcat('./RTOPDF.png');
    % saveas(gcf,FileName)
end