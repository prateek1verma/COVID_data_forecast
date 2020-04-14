function var_forecast = prediction_int(ydata,yforecast, alpha,beta,np,nf)
var_y = mean((ydata-yforecast).^2);
c = (alpha*(1+(1:(np+nf))*beta)).^2;
var_forecast = var_y.*(1 + cumsum(c));
end