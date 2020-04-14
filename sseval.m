function sse = sseval(x,tdata,ydata,np,nf)
alpha = x(1);
beta = x(2);
[forecast,~,~] = Exp_smooth_trend(ydata,tdata, alpha, beta,np,nf);
sse = mean((ydata - forecast(1:end-np-nf)').^2); % Mean Squared Error
% sse = mean(abs(ydata - forecast(1:end-10)')); % Mean Absolute Error
% sse = mean(abs(ydata - forecast(1:end-10)')./ydata); Mean absolute percentage error
end