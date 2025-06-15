% main.m — Transfer characteristic analysis

%  Load the CSV data exported from the oscilloscope
data = readmatrix('scope_0.csv');

%  1) Remove any rows containing NaN values
data = data(~any(isnan(data),2), :);

%  2) Extract channels: CH1 = input (vI), CH2 = output (vO)
vI = data(:,2);
vO = data(:,3);

%  3) Sort input and align output for a clean transfer curve
[vI_s, idx] = sort(vI);
data_transfer = [vI_s, zeros(size(vI_s)), vO(idx)];

%  4) Call the plotting/analysis routine
analyse_transfer_function(data_transfer);
