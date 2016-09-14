clear all;
close all;
% data analysis
feat = xlsread('Dataset.xlsx', 2);
data = xlsread('Dataset.xlsx');
data = data(:,2); %% remove time vector
feat=feat(:,2:end); %% remove time vector 

%% No features 

%hist(diff(data), 1000);
MeanDiff = mean(diff(data));
%% a such operation enables to study the variations of the share price without looking at any feature i.e supposing that the data
%% the prices variations are purely random : This approach clearly shows that there is a higher probability that this share
%% price goes up (mean = 0.69)
%% 

%% remove volumes for features
feat(:,4)=[];
feat(:,8)=[];
feat(:,12)=[];
feat(:,end)=[];
csvwrite('features.csv', feat);
csvwrite('target.csv', data);
%% remove mean
for l=1:size(feat, 2)
    featdiff(:,l)=diff(feat(:,l));
    featdiff(featdiff(:,l)>=0,l)=1;
    featdiff(featdiff(:,l)<0,l)=-1;
end

%% We perform a regression between diff(data(t)) and diff(feat(0 -> t-l)) l =1:100 
y=diff(data);
y(diff(data)>=0)=1;
y(diff(data)<0)=-1;
y(end)=[];
for l=1:100
l
CVO = cvpartition(size(y, 1),'kfold',5);
err = zeros(CVO.NumTestSets,1);
for i = 1:CVO.NumTestSets
    trIdx = CVO.training(i);
    teIdx = CVO.test(i);
    [u, B] = regression(y(trIdx,:),featdiff(trIdx,:),l);
    ytest = [ones(length(featdiff(teIdx,:)),1) featdiff(teIdx, :)]*B'+u;
    err(i) = (norm(ytest - y(teIdx)))^2/norm(y(teIdx))^2;
end
cvErr(l) = sum(err)/sum(CVO.TestSize);
end
plot(cvErr);

[u,B] = regression(y,featdiff(1:size(featdiff, 1)-1, :),1); %%
yreg =([ones(length(featdiff)-1,1) featdiff(1:size(featdiff)-1,:)]*B'+u);
yreg(yreg>=0)=1;
yreg(yreg<0)=-1;
Rsq=var(yreg)/mean((yreg-mean(y)).^2) 

%% Here we can see that we obtain an Rsquare = 0.95, which means that our data 
%% fits well in a Linear Model

%% We can therefore work on a trading strategy : 
%% The predicted change in stock prices will therefore serve as a trading strategy 
%% 






