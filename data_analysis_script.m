clear all;
close all;
% data analysis
feat = xlsread('Dataset.xlsx', 2);
data = xlsread('Dataset.xlsx');
data = data(:,2); %% remove time vector
feat=feat(:,2:end) %% remove time vector 

%% No features 

%hist(diff(data), 1000);
MeanDiff = mean(diff(data));
%% a such operation enables to study the variations of the share price without looking at any feature i.e supposing that the data
%% the prices variations are purely random : This approach clearly shows that there is a higher probability that this share
%% price goes up (mean = 0.69)
%% 

%% regression analysis

beta = inv(feat'*feat)*feat'*data;
u = mean(data)-mean(beta'*feat');
MSE = sum((data - u - feat*beta).^2)/sum(data.^2);


%% regression : data = feat*beta + u  at each time
%% IMPORTANT : low MSE measure (1.7e-06 )-> data and features are correlated at time t

%% We perform a regression between data(t+1) and (feat(t-a)) a =1:100 
for l=1:100
l
[beta_t{l},u_t{l}, MSE_t(l)] =regression(data, feat, l);
end
plot(MSE_t)
%% We perform a regression between data(t+1) and (feat(a:t)) for each value of a (1 to 100)

