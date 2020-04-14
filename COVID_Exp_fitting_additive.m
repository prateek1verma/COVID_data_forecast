clc; clear; close all;

%% Data Extraction
Data = readtable('full_data.csv'); % Load the data from .csv file to table format

% Extracting the data of a particular country
% user can input country name inthe form of string
country_name = input('Input the name of the country: ', 's'); 
np = input('Input the number of days to be forecasted with data: '); 
nf = input('Input the number of days to be forecasted without data: '); 

%Index = find(contains(Data.location,country_name)); % index where the input country data exist
Index = find(strcmp(Data.location,country_name));

% Extracted data of input country
Data_country = Data(Index,:);

date_s = table2array(Data_country(:, 1));        % date data
total_death_s0 = table2array(Data_country(:, 6)); % cummulative death data
total_cases_s0 = table2array(Data_country(:, 5)); % cummulative cases data

ind_01 = find(total_death_s0,1);             % index where data becomes non-zero
total_death_s = total_death_s0(ind_01:end-np);  % reformating death-data by removing zeros entry
date_s1 = date_s(ind_01:end-np);               % reformating death-date-data by removing zeros entry    

ind_02 = find(total_cases_s0,1);             % index where data becomes non-zero
total_cases_s = total_cases_s0(ind_02:end-np);  % reformating cases-data by removing zeros entry
date_s2 = date_s(ind_02:end-np);               % reformating cases-date-data by removing zeros entry

% New variable dates for forcasting (done for next 10 days)
f_date_s1 = date_s1(end) + caldays(1:np+nf);
f_date_s2 = date_s2(end) + caldays(1:np+nf);

%% Forcasting and Error optimization
fun = @(x)sseval(x,date_s1,total_death_s,np,nf); % making tempory function
% x0 = rand(2,1);     % initialization for optimazing error
% Look in the region where x has positive values and alpha/beta < 1
lb = [0,0];
ub = [1,1];

% There are no linear constraints on alpha/beta, so set those arguments to [].
A = [];
b = [];
Aeq = [];
beq = [];
x0 = ((lb + ub)/2);
nonlcon = [];
% options = optimoptions(@fmincon,'Algorithm','sqp','MaxIterations',1500);
% options = optimoptions('fmincon','Display','iter','Algorithm','active-set');
options = optimoptions(@fmincon,'Algorithm','sqp','Display','off');
% options = optimoptions('fmincon')
bestx1 = fmincon(fun,x0',A,b,Aeq,beq,lb,ub,nonlcon,options); % best value of alpha and beta;

alpha = bestx1(1);  % Value taken arbitarily but they have to be optimized to get minimum error^2
beta = bestx1(2);   % Value taken arbitarily but they have to be optimized to get minimum error^2
%alpha = 0.2;  % Value taken arbitarily but they have to be optimized to get minimum error^2
%beta = 0.9;   % Value taken arbitarily but they have to be optimized to get minimum error^2
[f_death,S,mu] = Exp_smooth_trend(total_death_s,date_s1, alpha, beta,np,nf);
% [f_death_fit,delta] = polyval(p,datenum(date_s1),S,mu);
var_forecast_death = prediction_int(total_death_s',f_death(1:end-np-nf), alpha,beta,np,nf);

%% For Number of Cases
fun2 = @(x)sseval(x,date_s2,total_cases_s,np,nf); % making tempory function
bestx2 = fmincon(fun2,x0',A,b,Aeq,beq,lb,ub,nonlcon,options); % best value of alpha and beta;
alpha2 = bestx2(1);  % Value taken arbitarily but they have to be optimized to get minimum error^2
beta2 = bestx2(2);   % Value taken arbitarily but they have to be optimized to get minimum error^2
[f_cases,S2,mu2] = Exp_smooth_trend(total_cases_s,date_s2, alpha2, beta2,np,nf);
var_forecast_cases = prediction_int(total_cases_s',f_cases(1:end-np-nf), alpha2,beta2,np,nf);

%% Output
%% subplots for deaths
% subplot(2,1,2)
% Plotting data - 10 days
figure()
% Plotting training data
plot(date_s1, total_death_s,'-ok',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on

col1 = [0.90 .90 .90];
col2 = [0.85 .85 .85];

% Plotting pridiction Interval 95% confidence
y11 = f_death((end-np-nf+1):end) + 1.96*sqrt(var_forecast_death);
y21 = f_death((end-np-nf+1):end) - 1.96*sqrt(var_forecast_death);
inBetween1 = [y11 , fliplr(y21)];
x21 = [f_date_s1 fliplr(f_date_s1)];

rectangle('Position',[length(date_s1),0,np,y11(end)],'FaceColor',col1,'EdgeColor',col1,...
    'LineWidth',1)
rectangle('Position',[length(date_s1)+np,0,nf,y11(end)],'FaceColor',col2,'EdgeColor',col1,...
    'LineWidth',1)

% Plotting data for + np days
plot(date_s(end-np+1:end),total_death_s0(end-np+1:end),'om','MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.8,0.2,0.2])

% Plotting pridiction Interval 95% confidence
fill(x21, inBetween1, 'g','facealpha',.3);

% Plotting forecast for np days
plot(f_date_s1,f_death((end-np-nf+1):end),'-r','LineWidth',2)

% % fitted data
% plot(date_s1, f_death(1:end-10),'-ob',...
%     'LineWidth',2,...
%     'MarkerSize',5,...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor',[0.5,0.5,0.5])

set (gca, 'FontSize' , 14)
grid on
ylabel('Cumulative Deaths','Fontsize',16)
xlabel('Days','Fontsize',16)
title(['Deaths: ',country_name])
legend('training data','real data','95% prediction interval','forecast','Location','NorthWest','Fontsize',16)
ylim([0,y11(end)])
xlim([date_s1(1),f_date_s1(end)])
filename1 = ['Deaths_',country_name,'.png'];
print(filename1,'-dpng','-r150')

%% subplots for cases
% subplot(2,1,1)
figure()
% col1 = [0.9 .9 .9];
% col2 = [0.6 .6 .6];
% Plotting training data
plot(date_s2, total_cases_s,'-ok',...
    'LineWidth',2,...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on

y12 = f_cases((end-np-nf+1):end) + 1.96*sqrt(var_forecast_cases);
y22 = f_cases((end-np-nf+1):end) - 1.96*sqrt(var_forecast_cases);
inBetween2 = [y12 , fliplr(y22)];
x22 = [f_date_s2 fliplr(f_date_s2)];

% Plotting pridiction Interval 95% confidence
rectangle('Position',[length(date_s2),0,np,y12(end)],'FaceColor',col1,'EdgeColor',col1,...
    'LineWidth',1)
rectangle('Position',[length(date_s2)+np,0,nf,y12(end)],'FaceColor',col2,'EdgeColor',col1,...
    'LineWidth',1)

% Plotting data for + 10 days
plot(date_s(end-np+1:end),total_cases_s0(end-np+1:end),'om','MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.8,0.2,0.2])

% Plotting pridiction Interval 95% confidence
fill(x22, inBetween2, 'g','facealpha',.3);

% Plotting forecast for 10 days
plot(f_date_s2,f_cases((end-np-nf+1):end),'-r','LineWidth',2)

set (gca, 'FontSize' , 14)
grid on
ylabel('Cumulative Cases','Fontsize',16)
xlabel('Days','Fontsize',16)
title(['Cases: ',country_name])
legend('training data','real data','95% prediction interval','forecast','Location','NorthWest','Fontsize',16)
ylim([0,y12(end)])
xlim([date_s2(1),f_date_s2(end)])
filename2 = ['Cases_',country_name,'.png'];
print(filename2,'-dpng','-r150')