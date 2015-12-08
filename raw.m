function rtn =  raw(train,test,fit,sampleobs,graph,m)
%pipeline implementation 
traindata=ricky(train);
testdata=ricky(test);
rtn.numberofdrink.train=sum(traindata(:,end));
rtn.numberofdrink.test=sum(testdata(:,end));

%cleaned method
if strcmp(fit,'linear')
   traindata=fitlinear(traindata);
   testdata=fitlinear(testdata);
   rtn.fitlinear.train=traindata;
   rtn.fitlinear.test=testdata;
else if strcmp(fit, 'spline')
        traindata=fitspline(traindata);
        testdata=fitspline(testdata);
        rtn.fitspline.train=traindata;
        rtn.fitspline.test=testdata;
    end;
end;

testset = testdata;
% Check number of inputs.
if nargin > 6
    error('TooManyInputs');
end

% Fill in unset optional values.
switch nargin
    case 4
        graph = 'noplot';
        m = 0;
end

%give the plot(option)
if strcmp(graph,'smooth')
    smooth(traindata,m);
    smooth(testdata,m);
end;

    
    data=generatevar(traindata,testdata);
    traindata=data.train;
    testdata=data.test;
    rtn.generatevar.confusion=data.confusion;
    rtn.generatevar.bestidx=data.idx;
    rtn.generatevar.train=traindata;
    rtn.generatevar.test=testdata;
    
%     rtn.rf=randomforest(traindata,testdata);
    
    rtn.glm=glm(traindata,testdata);
    rtn.tree=tree(traindata,testdata);
    rtn.svm=svm(traindata,testdata);
    
    rtn.glm.compareFile = [testset(:,1),testset(:,end),rtn.glm.result];
    rtn.tree.compareFile = [testset(:,1),testset(:,end),rtn.tree.result];
    rtn.svm.compareFile = [testset(:,1),testset(:,end),rtn.svm.result];
    
%     [rtn.glm.eval, rtn.glm.rtn] = evaluation(rtn.glm.compareFile,halfwindowSize);
%     [rtn.tree.eval, rtn.tree.rtn] = evaluation(rtn.tree.compareFile,halfwindowSize);
%     [rtn.svm.eval, rtn.svm.rtn] = evaluation(rtn.svm.compareFile,halfwindowSize);

end

