function [forecast,S,mu] = Exp_smooth_trend(total_death,date_s, alpha, beta, np,nf)
% Initial level
% P = polyfit(datenum(date_s),total_death_s(1:5)',1);
n = length(total_death);
[P, S, mu] = polyfit(datenum(date_s(1:4)),total_death(1:4),1);
% f = polyval(p,datenum(date_s1),[],mu);

level_old = P(2);
trend_old = P(1);

forecast = zeros(1,n+np+nf);
forecast(1) = level_old + trend_old;
for i = 1:n
    level_new = alpha*total_death(i)+(1-alpha)*(level_old+trend_old);
    trend_new = beta*(level_new - level_old) + (1-beta)*trend_old;
    trend_old = trend_new;  level_old = level_new;
    forecast(i+1) = level_old + trend_old;
end

for j = n+2:n+np+nf
    forecast(j) = level_old + (j-n)*trend_old;
end

end