% A sample script for generating  training and testing data; 
% training and testing an ESN on a frequency generator task.
% The training input is a slow sinewave of period length superPeriod. 
% The training output is a fast sinewave whose period length varies
% with the amplitude of the input, in a range set by outMinPeriod and
% outMaxPeriod.
% This script is used to generate the example for the Encyclopedia 
% of Computational Intelligence article on ESN

% Created H. Jaeger, June 23, 2007 from demoScript in this toolbox


% clear all; 
close all;

%%%% generate the training data

sequenceLength = 5000;
% 
% disp('Generating data ............');
% disp(sprintf('Sequence Length %g', sequenceLength ));

outMinPeriod = 4 ; outMaxPeriod = 16; % output period length range
superPeriod = 200; % input period length
[inputSequence outputSequence] = ...
    generate_freqGen_sequence(sequenceLength , outMinPeriod, outMaxPeriod, superPeriod) ; 

figure(4); clf; set(4, 'Position', [ 58   728   236   191]);
plot(inputSequence(101:300,2));
figure(5); clf; set(5, 'Position', [ 58   728   236   191]);
plot(outputSequence(101:300,1));

%%%% split the data into train and test

train_fraction = 0.8 ; % use train_fraction of data in training, rest in testing
[trainInputSequence, testInputSequence] = ...
    split_train_test(inputSequence,train_fraction);
[trainOutputSequence,testOutputSequence] = ...
    split_train_test(outputSequence,train_fraction);



%%%% generate an esn 
nInputUnits = 2; nInternalUnits = 200; nOutputUnits = 1; 
% 
esn = generate_esn(nInputUnits, nInternalUnits, nOutputUnits, ...
    'spectralRadius',0.8,'inputScaling',[0.01; 0.5],'inputShift',[0;0], ...
    'teacherScaling',[0.95],'teacherShift',[0.025], 'feedbackScaling', 1, ...
    'outputActivationFunction', 'identity', 'inverseOutputActivationFunction', 'identity',...
    'type', 'plain_esn');

esn.inputScaling = [0.01; 3];
esn.feedbackScaling = 0.8; 
esn.spectralRadius = 0.25; esn.internalWeights = esn.internalWeights_UnitSR * esn.spectralRadius;
esn.noiseLevel = 0.001;
esn.teacherScaling = 1.4;
esn.teacherShift = -0.7;
esn.outputActivationFunction = 'tanh';
esn.inverseOutputActivationFunction = 'atanh';
esn.methodWeightCompute = 'wiener_hopf';
esn.type = 'plain_esn';
% esn.leakage = 0.3;


%%%% train the ESN
nForgetPoints = 100 ; % discard the first 100 points
[trainedEsn stateMatrix] = ...
    train_esn(trainInputSequence, trainOutputSequence, esn, nForgetPoints) ; 

trainedEsn.noiseLevel = 0;

%%%% save the trained ESN
% save_esn(trainedEsn, 'esn_freqGen_demo_1'); 

%%%% plot the internal states of 4 units
nPoints = 300 ; 
plot_states(stateMatrix, [1 2 3 4], nPoints, 1) ; 

% %% create reservoir state drawings for scholarpedia article
% for unitNr = 1:10
%     nPoints = 200 ; 
%     plot_states(stateMatrix, [unitNr], nPoints, []) ; 
%     set(gcf, 'Position', [58   728   236   191]);
% end

%%%% compute training error (from teacher-forced outputs)
predictedTrainOutput = stateMatrix * trainedEsn.outputWeights' ; 
nOutputPoints = length(predictedTrainOutput(:,1)) ; 
predictedTrainOutput = feval(esn.outputActivationFunction, predictedTrainOutput); 
predictedTrainOutput = predictedTrainOutput - repmat(esn.teacherShift',[nOutputPoints 1]) ; 
predictedTrainOutput = predictedTrainOutput / diag(esn.teacherScaling) ; 
% compute NRMSE training error
trainError = compute_error(predictedTrainOutput, trainOutputSequence(nForgetPoints+1:end,:)); 
disp(sprintf('train NRMSE = %s', num2str(trainError)));
% plot teacher vs. network output
nPlotPoints = 500 ; 
plot_sequence(trainOutputSequence(nForgetPoints+1:end,:), predictedTrainOutput, nPlotPoints,...
    'training: teacher sequence (red) vs predicted sequence (blue)');

%%%% compute testing error on continuation started with last state of
%%%% trained network
lastTrainState = [stateMatrix(end,:)'; esn.teacherScaling * trainOutputSequence(end,1) + esn.teacherShift];
predictedTestOutput = test_esn(testInputSequence,  trainedEsn, ...
    0, 'startingState', lastTrainState) ; 
% compute NRMSE testing error
testLength = 500;
testError = compute_error(predictedTestOutput(1:testLength, :), testOutputSequence(1:testLength, :)); 
disp(sprintf('test NRMSE = %s', num2str(testError)));
% plot teacher vs. network output
nPlotPoints = 1000 ; 
plot_sequence(testOutputSequence, predictedTestOutput, nPlotPoints, ...
    'testing: teacher sequence (red) vs predicted sequence (blue)') ; hold on;
plot(testInputSequence(1:1000,2));


disp(sprintf('average absolute output weights: %g', mean(abs(trainedEsn.outputWeights))));

