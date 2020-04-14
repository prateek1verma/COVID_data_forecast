function var_forecast = prediction_int_mul(ydata,yforecast, alpha,beta,np,nf)
n = length(ydata);
var_y = mean(((ydata-yforecast(1:n))./yforecast(1:n)).^2);
c = (alpha*(1+(1:(np+nf))*beta)).^2;
theta = yforecast(n+1:n+np+nf).^2;
theta(1) = yforecast(n+1).^2;
    for h = 2:(np+nf)
    for j = 1:(h-1)
        theta(h) = theta(h) + var_y * c(j)*theta(h-j);
    end
    end
var_forecast = (var_y+1).*theta - yforecast(n+1:n+np+nf).^2;
end
