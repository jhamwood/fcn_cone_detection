function [net] = initNet(pximds)

tbl = countEachLabel(pximds);
numberPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / numberPixels;
classWeights = 1 ./ frequency;
classNames = ["background" "cone"];

layers = [
    imageInputLayer([144 144 1],'Name','input')
    
    convolution2dLayer(3,32,'Padding','same','Name','conv_1_1')
    batchNormalizationLayer('Name','BN_1_1')
    reluLayer('Name','relu_1_1')
    convolution2dLayer(3,32,'Padding','same','Name','conv_1_2')
    batchNormalizationLayer('Name','BN_1_2')
    reluLayer('Name','relu_1_2')
    maxPooling2dLayer(2,'Stride',2,'Name','pool_1')
    
    convolution2dLayer(3,32,'Padding','same','Name','conv_2_1')
    batchNormalizationLayer('Name','BN_2_1')
    reluLayer('Name','relu_2_1')
    convolution2dLayer(3,32,'Padding','same','Name','conv_2_2')
    batchNormalizationLayer('Name','BN_2_2')
    reluLayer('Name','relu_2_2')
    maxPooling2dLayer(2,'Stride',2,'Name','pool_2')
    
    convolution2dLayer(3,32,'Padding','same','Name','conv_3_1')
    batchNormalizationLayer('Name','BN_3_1')
    reluLayer('Name','relu_3_1')
    convolution2dLayer(3,32,'Padding','same','Name','conv_3_2')
    batchNormalizationLayer('Name','BN_3_2')
    reluLayer('Name','relu_3_2')
    maxPooling2dLayer(2,'Stride',2,'Name','pool_3')
    
    convolution2dLayer(3,256,'Padding','same','Name','conv_4_1')
    batchNormalizationLayer('Name','BN_4_1')
    reluLayer('Name','relu_4_1')
    convolution2dLayer(3,256,'Padding','same','Name','conv_4_2')
    batchNormalizationLayer('Name','BN_4_2')
    reluLayer('Name','relu_4_2')
    dropoutLayer(0.5,'Name','drop_4')
    
    transposedConv2dLayer(4,128,'Stride',2,'Cropping',[1 1],'Name','convt_3u')
    depthConcatenationLayer(2,'Name','concat_3u')
    convolution2dLayer(3,128,'Padding','same','Name','deconv_3_1u')
    batchNormalizationLayer('Name','BN_3_1u')
    reluLayer('Name','relu_3_1u')
    convolution2dLayer(3,128,'Padding','same','Name','deconv_3_2u')
    batchNormalizationLayer('Name','BN_3_2u')
    reluLayer('Name','relu_3_2u')
    
    transposedConv2dLayer(4,64,'Stride',2,'Cropping',[1 1],'Name','convt_2u')
    depthConcatenationLayer(2,'Name','concat_2u')
    convolution2dLayer(3,128,'Padding','same','Name','deconv_2_1u')
    batchNormalizationLayer('Name','BN_2_1u')
    reluLayer('Name','relu_2_1u')
    convolution2dLayer(3,128,'Padding','same','Name','deconv_2_2u')
    batchNormalizationLayer('Name','BN_2_2u')
    reluLayer('Name','relu_2_2u')
    
    transposedConv2dLayer(4,32,'Stride',2,'Cropping',[1 1],'Name','convt_1u')
    depthConcatenationLayer(2,'Name','concat_1u')
    convolution2dLayer(3,128,'Padding','same','Name','deconv_1_1u')
    batchNormalizationLayer('Name','BN_1_1u')
    reluLayer('Name','relu_1_1u')
    convolution2dLayer(3,128,'Padding','same','Name','deconv_1_2u')
    batchNormalizationLayer('Name','BN_1_2u')
    reluLayer('Name','relu_1_2u')
    
    convolution2dLayer(1,2,'Name','classifier')
    softmaxLayer('Name','softmax')
    pixelClassificationLayer('Name','classOutput','ClassWeights',classWeights)];

net = layerGraph(layers);

net = connectLayers(net,'relu_1_2','concat_1u/in2');
net = connectLayers(net,'relu_2_2','concat_2u/in2');
net = connectLayers(net,'relu_3_2','concat_3u/in2');