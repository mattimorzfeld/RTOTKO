function r = funcF2hp(u,m,muRef,y,ModelConfig,DataConfig)
s = DataConfig.s;
m_mu = 10^(.5*(muRef-u))*m;
r = s.\F(m_mu,ModelConfig,DataConfig)-y;
