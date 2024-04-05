close all
clear
clc

% -------------------------------------------------------------------------
% Programmed by: Josef Manlutac, 201922513
% ME527 Coursework 2024
%
% Code to collate data for surrogate model for expensive model
% -------------------------------------------------------------------------

expSamples = [];
expOptVals = [];

for runNumber = 1:9
    fileName = sprintf('exp_data_part_%d.mat', runNumber);
    if exist(fileName, 'file')
        load(fileName, 'setSamples', 'setOptVals');
        expSamples = [expSamples; setSamples];
        expOptVals = [expOptVals; setOptVals];
    else
        warning('File %s does not exist.', fileName);
    end
end

% Save the concatenated dataset
save('exp_dataset.mat', 'expSamples', 'expOptVals');
disp('Total dataset saved.');
