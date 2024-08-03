function      [X , y]=DatasetCreate(numSamples,numFeatures,numClass)

X=randn(numSamples,numFeatures);
y=randi(numClass, numSamples,1);

end