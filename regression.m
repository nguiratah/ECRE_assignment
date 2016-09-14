function [u, B]= regression(data, feat, l)
data_t=data(l+1:end);
feat_t=feat(1:size(feat, 1)-l, :);
feat_t = [ones(length(feat_t),1) feat_t];
B = data_t\feat_t;
u = mean(data_t)-mean((B*feat_t'));
