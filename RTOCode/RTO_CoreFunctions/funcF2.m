function r = funcF2(u,ypert,mp,mu,ModelConfig,DataConfig,D)
s = DataConfig.s;
r =[s.\F(u,ModelConfig,DataConfig)-ypert;
    sqrt(10^mu)*D*u-mp];