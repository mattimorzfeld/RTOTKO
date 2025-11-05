function [p5,p95,post_mean]=plotMarginalPosteriors(X,z,rhoBins,PlotFlag)


nlayers = length(z);
rhoAxis = (rhoBins(2:end)+rhoBins(1:end-1))/2;
nBins = length(rhoBins)-1;

posteriorPDF = zeros(nlayers,nBins);
post_mean = zeros(nlayers,1);
p50 = zeros(nlayers,1);
p5 = zeros(nlayers,1);
p95 = zeros(nlayers,1);

for ilayer=1:nlayers
   figure(99)
   tmpinds = imag(X(ilayer,:))==0; tmp = X(ilayer,tmpinds);
   a = histogram(tmp,rhoBins,'Normalization','pdf');
   posteriorPDF(ilayer,:) = a.Values;
   post_mean(ilayer) = mean(tmp);
   p50(ilayer) = prctile(tmp,50);
   p5(ilayer) = prctile(tmp,5);
   p95(ilayer) = prctile(tmp,95);
   close 99
end

p5 = [p5(1); p5(1:end-1)]; 
p95 = [p95(1); p95(1:end-1)];
p50 = [p50(1); p50(1:end-1)]; 
post_mean = [post_mean(1); post_mean(1:end-1)];

if PlotFlag == 1
    figure
    fhand = pcolor(rhoAxis,z,log10(posteriorPDF));
    colormap(viridis(100))
    
    set(fhand,'EdgeColor','none')
    set(gca,'YDir','reverse')
    colorbar
    hold on
    
    stairs(p5,z,'-r','linewidth',2)
    stairs(p95,z,'-r','linewidth',2)
    stairs(post_mean,z,'-k','linewidth',2)
    xlabel('log(\rho) (ohm-m)')
    ylabel('z (m)')
    set(gca,'FontSize',14)
    set(gcf,'position',[560 238 478 710])
end