function result =  graphTest(train,test,fit,graph,m)
%pipeline implementation 
traindata=ricky(train);
testdata=ricky(test);
result.numberofdrink.train=sum(traindata(:,end));
result.numberofdrink.test=sum(testdata(:,end));

%cleaned method
if strcmp(fit,'linear')
   traindata=fitlinear(traindata);
   testdata=fitlinear(testdata);
else if strcmp(fit, 'spline')
        traindata=fitspline(traindata);
        testdata=fitspline(testdata);
    end;
end;
% Check number of inputs.
if nargin > 8
    error('TooManyInputs');
end

% Fill in unset optional values.
switch nargin
    case 6
        graph = 'noplot';
        m = 0;
end

%give the plot(option)
if strcmp(graph,'smooth')
    smooth(traindata,m);
%     smooth(testdata,m);
end;

end

