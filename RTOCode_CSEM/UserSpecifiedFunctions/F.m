function [ModelOutput,J] = F(m,ModelConfig,DataConfig)

ModelOutput = callCSEM(m,DataConfig,ModelConfig);

% Jacobian
if nargout == 2
    J = Jac(m,0.05,ModelConfig,DataConfig);
end

end


