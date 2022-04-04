%% Train the ESN

% Trains the ESN on the generated training data. Also uses different log
% fractions of the training data
%
% The average of 5 ESNs is used as the final output

clear all
close all

warning('off','all')
addpath('freqGen')

fracData = 10./logspace(1,4,10);
fracData = fracData(1:end-1);
fracData = fracData(1);

for f = 1:length(fracData)

pathData = cd;
dirData = dir(fullfile(pathData, 'sol*'));

pathDataOut = fullfile(cd, 'data_pred');
pathEsnOut = fullfile(cd, 'esn');

%% Load the data 

load sol
[x, y] = fn_preproc_ac(sol);

% Convert to format for ESN
[nTrial, nInputUnits, nTime] = size(x);

xCell = cell(nTrial, 1);
yCell = cell(nTrial, 1);

for iTrial = 1:nTrial
    xCell{iTrial, 1} = squeeze(x(iTrial, :, :))';
    yCell{iTrial, 1} = squeeze(y(iTrial, :, :))';
end

iPerm = randperm(nTrial);

splitFrac = 0.8;
nTrain = splitFrac*length(iPerm);
nTest  = length(iPerm)-nTrain;

nTrain = floor(nTrain*fracData(f));

xTrain = xCell(iPerm(1:nTrain), :); 
yTrain = yCell(iPerm(1:nTrain), :);
xTest  = xCell(iPerm(nTrain+1:nTrain+nTest), :);
yTest  = yCell(iPerm(nTrain+1:nTrain+nTest), :);

%% Generate the ESN

nInternalUnits = 10; 
nOutputUnits   = 2; 

spectralRad     = 0.5;
inputScaling    = ones(nInputUnits, 1);
inputShift      = zeros(nInputUnits, 1);
teacherScaling  = ones(nOutputUnits, 1)*0.1;
teacherShift    = zeros(nOutputUnits, 1);
feedbackScaling = ones(nOutputUnits, 1)*0.1;
esnType         = 'leaky_esn';
learningMode    = 'offline_multipleTimeSeries';
methodCompute   = 'pseudoinverse';

nEsn = 5;
errors = zeros(nEsn, 2, 2);
for iEsn = 1:nEsn
    
    esn = generate_esn(nInputUnits, ...
    nInternalUnits, ...
    nOutputUnits, ...
    'spectralRadius', spectralRad, ...
    'inputScaling', inputScaling, ...
    'teacherScaling', teacherScaling, ...
    'teacherShift', teacherShift, ...
    'feedbackScaling', feedbackScaling, ...
    'type', esnType, ...
    'learningMode', learningMode);

esn.methodWeightCompute = 'pseudoinverse';
esn.internalWeights     = esn.internalWeights_UnitSR * esn.spectralRadius;

%% Train the ESN

[trainedEsn stateMatrix] = train_esn(xTrain, yTrain, esn, 0) ; 

predictedTrainOutput = stateMatrix * trainedEsn.outputWeights' ; 
nOutputPoints = length(predictedTrainOutput(:,1)) ; 
predictedTrainOutput = feval(esn.outputActivationFunction, predictedTrainOutput); 
predictedTrainOutput = predictedTrainOutput - repmat(esn.teacherShift',[nOutputPoints 1]) ; 
predictedTrainOutput = predictedTrainOutput / diag(esn.teacherScaling) ; 

tempTrainOutput = cat(1, yTrain{:});

trainError = compute_error(predictedTrainOutput(nTime:nTime:end, :), tempTrainOutput(nTime:nTime:end, :)); 
disp(sprintf('train NRMSE = %s', num2str(trainError)));
% plot teacher vs. network output
nPlotPoints = min([100, length(predictedTrainOutput(nTime:nTime:end, :))]) ; 
plot_sequence(tempTrainOutput(nTime:nTime:end, :), predictedTrainOutput(nTime:nTime:end, :), nPlotPoints,...
    'training: teacher sequence (red) vs predicted sequence (blue)');

%% Test the ESN

testInputSequence = cat(1, xTest{:});
testOutputSequence = cat(1, yTest{:});

lastTrainState = [stateMatrix(end,:)'; esn.teacherScaling * tempTrainOutput(end,1) + esn.teacherShift];
predictedTestOutput = test_esn(testInputSequence,  trainedEsn, ...
    0, 'startingState', lastTrainState) ; 
% compute NRMSE testing error
testError = compute_error(predictedTestOutput(nTime:nTime:end, :), testOutputSequence(nTime:nTime:end, :)); 
disp(sprintf('test NRMSE = %s', num2str(testError)));
% plot teacher vs. network output
nPlotPoints = 100; 
plot_sequence(testOutputSequence(nTime:nTime:end, :), predictedTestOutput(nTime:nTime:end, :), nPlotPoints, ...
    'testing: teacher sequence (red) vs predicted sequence (blue)') ; hold on;

disp(sprintf('average absolute output weights: %g', mean(abs(trainedEsn.outputWeights))));

trainedEsn.stateMatrix = stateMatrix;
trainedEsn.lastTrainState = lastTrainState;

allEsn(iEsn) = trainedEsn;
errors(iEsn, 1, :) = trainError;
errors(iEsn, 2, :) = testError;

end

save(fullfile(pathEsnOut, ['esn_' num2str(f) '.mat']), 'allEsn', 'errors', '-v7.3')

end

