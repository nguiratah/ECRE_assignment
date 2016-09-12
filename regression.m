function [beta_t, u_t, MSE_t]= regression(data, feat, l)
data_t=data(l+1:end);
feat_t=feat(1:size(feat, 1)-l, :);
beta_t = inv(feat_t'*feat_t)*feat_t'*data_t;
u_t = mean(data_t)-mean(beta_t'*feat_t');
MSE_t = sum((data_t - u_t - feat_t*beta_t).^2)/sum(data_t.^2);
