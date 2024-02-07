# COVID Data Forecast

This repository contains MATLAB code for forecasting cases and deaths due to COVID-19 using exponential smoothing approaches for a chosen country.

## Main MATLAB Files

- `COVID_Exp_fitting_additive.m`: Main MATLAB file for forecasting using additive exponential smoothing approach.
- `COVID_Exp_fitting_multiplicative.m`: Main MATLAB file for forecasting using multiplicative exponential smoothing approach.

## Dependent Files

- `Exp_smooth_trend.m`: Dependent MATLAB file for exponential smoothing with trend (additive).
- `Exp_smooth_trend_mul.m`: Dependent MATLAB file for exponential smoothing with trend (multiplicative).
- `prediction_int.m`: Dependent MATLAB file for calculating prediction intervals (additive).
- `prediction_int_mul.m`: Dependent MATLAB file for calculating prediction intervals (multiplicative).
- `sseval.m`: Dependent MATLAB file for evaluating sum of squares.

## Data File

- `full_data.csv`: CSV file containing COVID-19 infection and death data country-wise and date-wise.

## Instructions

1. Download or clone the repository to your local machine.
2. Ensure you have MATLAB installed.
3. Open MATLAB and navigate to the directory containing the downloaded files.
4. Run either `COVID_Exp_fitting_additive.m` or `COVID_Exp_fitting_multiplicative.m` based on your preferred exponential smoothing approach.
5. Follow the prompts to select the country and specify any additional parameters.
6. The script will generate forecasts and plot the results.

## Note

- Ensure that the `full_data.csv` file is in the same directory as the main MATLAB files.
- Adjust parameters and refine the forecasting model as necessary for your specific requirements.
- For any issues or questions, please open an issue in this repository.

## License

This project is licensed under the [MIT License](LICENSE).
