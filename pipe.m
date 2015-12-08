function result =  pipe(train,test,fit,sampleobs,halfwindowSize,graph,m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Main Pipeline
%%%        written by peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


train='1005 pre-cleaned 4-03-15';
test='1005 pre-cleaned 2-9-15';


%%preclean part using loess method
train_preclean=preclean(train);
test_preclean=preclean(test);

%%skin, ambulation, time, hr, br, drink

%%transfer into useful dataset
traindata=cleandata(train_preclean,train);
testdata=cleandata(test_preclean,test);
result.origin_traindata=traindata;
result.origin_testdata=testdata;

%%linear fit method
if strcmp(fit,'linear')
   traindata=fitlinear(traindata);
   testdata=fitlinear(testdata);
   %%output train and test data
   result.fitlinear.train=traindata;
   result.fitlinear.test=testdata;
%%spline fit method
else if strcmp(fit, 'spline')
        traindata=fitspline(traindata);
        testdata=fitspline(testdata);
        result.fitspline.train=traindata;
        result.fitspline.test=testdata;
    end;
end;

%short method
traindata=traindata(traindata(:,1)<=8|18<=traindata(:,1),:);
testdata=testdata(testdata(:,1)<=8|18<=testdata(:,1),:);

%%get numberofdrink in train and test
raw_train=traindata;
raw_test=testdata;
result.numberofdrink.train=sum(traindata(:,end));
result.numberofdrink.test=sum(testdata(:,end));




% Check number of inputs.
if nargin > 7
    error('TooManyInputs');
end

% Fill in unset optional values.
switch nargin
    case 5
        graph = 'noplot';
        m = 0;
end

%give the plot(option)
if strcmp(graph,'smooth')
    smooth(traindata,m);
    smooth(testdata,m);
end;

%%%%%generating training sample
%%expansion
samplevar={'simple','2interaction'};
machinelearning={'glm','tree','svm'};
halfwindowSize=30;
    if strcmp(sampleobs,'period');
        data=period(traindata,5,60,5);
        for ex = 1 : size(data.train,2)
            for var = 1: size(samplevar,2)
                if strcmp(samplevar{var},'simple')
                    data_preprocess{ex}{var} = simple(data.train{ex});
                    test_preprocess{var} = simple(testdata);
                end;
                if strcmp(samplevar{var},'2interaction')
                    data_preprocess{ex}{var} = interaction2(data.train{ex});
                    test_preprocess{var} = interaction2(testdata);
                end;
                for ml= 1: size(machinelearning,2)
                    %if strcmp(machinelearning{ml},'glm')
                    %        result.glm_extension(ex,var).glm=glm(data_preprocess{ex}{var},test_preprocess{var});
                    %        result.glm_extension(ex,var).reverse=period_test(raw_test(:,1),raw_test(:,end),result.glm_extension(ex,var).glm.result,5*ex);
                    %        [result.glm_extension(ex,var).eval, result.glm_extension(ex,var).report] = evaluation(result.glm_extension(ex,var).reverse.pair,halfwindowSize);
                   % end;
                    if strcmp(machinelearning{ml},'tree')
                            result.tree_extension(ex,var).tree=tree(data_preprocess{ex}{var},test_preprocess{var});
                            prune={'on','off'};
                            for p=1:size(prune,2)
                                for v=1:(size(data_preprocess{ex}{var},2)-1)
                                    result.tree_extension(ex,var).reverse{p}{v}=period_test(raw_test(:,1),raw_test(:,end),result.tree_extension(ex,var).tree.result{p}(:,v),5*ex);
                                    result.tree_extension(ex,var).reverse_train{p}{v}=period_test(raw_train(:,1),raw_train(:,end),result.tree_extension(ex,var).tree.training_result{p}(:,v),5*ex);
                                    [result.tree_extension(ex,var).eval{p}{v}, result.tree_extension(ex,var).report{p}{v}] = evaluation(result.tree_extension(ex,var).reverse{p}{v}.pair,halfwindowSize);
                                    [result.tree_extension(ex,var).eval_train{p}{v}, result.tree_extension(ex,var).report_train{p}{v}] = evaluation(result.tree_extension(ex,var).reverse_train{p}{v}.pair,halfwindowSize);
                                end;
                            end;
                    end;        
                    if strcmp(machinelearning{ml},'svm')
                            result.svm_extension(ex,var).svm=svm(data_preprocess{ex}{var},test_preprocess{var});
                            kernel={'rbf','linear','polynomial'};
                            for ke=1:size(kernel,2)
                                result.svm_extension(ex,var).reverse{ke}=period_test(raw_test(:,1),raw_test(:,end),result.svm_extension(ex,var).svm.result(:,ke),5*ex);
                                result.svm_extension(ex,var).reverse_train{ke}=period_test(raw_train(:,1),raw_train(:,end),result.svm_extension(ex,var).svm.training_result(:,ke),5*ex);
                                [result.svm_extension(ex,var).eval{ke}, result.svm_extension(ex,var).report{ke}] = evaluation(result.svm_extension(ex,var).reverse{ke}.pair,halfwindowSize);
                                [result.svm_extension(ex,var).eval_train{ke}, result.svm_extension(ex,var).report_train{ke}] = evaluation(result.svm_extension(ex,var).reverse_train{ke}.pair,halfwindowSize);
                            end;
                    end;
                end;
            end;
        end;  
    else if strcmp(sampleobs,'shrink');
        data=intervalrow(traindata,testdata,20,50,10);
        for shrink = 1 : size(data.train,2)
            for var = 1: size(samplevar,2)
                if strcmp(samplevar{var},'simple')
                    data_preprocess{shrink}{var} = simple(data.train{shrink});
                    test_preprocess{shrink}{var} = simple(data.test{shrink});
                end;
                if strcmp(samplevar{var},'2interaction')
                    data_preprocess{shrink}{var} = interaction2(data.train{shrink});
                    test_preprocess{shrink}{var} = interaction2(data.test{shrink});
                end;
                for ml= 1: size(machinelearning,2)
                    %if strcmp(machinelearning{ml},'glm')
                    %        result.glm_shrink(shrink,var).glm=glm(data_preprocess{shrink}{var},test_preprocess{shrink}{var});
                    %        result.glm_shrink(shrink,var).reverse=interval_test(raw_test(:,1),raw_test(:,end),result.glm_shrink(shrink,var).glm.result);
                    %        [result.glm_shrink(shrink,var).eval, result.glm_shrink(shrink,var).report] = evaluation(result.glm_shrink(shrink,var).reverse.pair,halfwindowSize);
                    %end;
                    %if strcmp(machinelearning{ml},'tree')
                    %        result.tree=tree(traindata,testdata);
                    %end;        
                    if strcmp(machinelearning{ml},'svm')
                            result.svm_shrink(shrink,var).svm=svm(data_preprocess{shrink}{var},test_preprocess{shrink}{var});
                            result.svm_shrink(shrink,var).reverse=interval_test(raw_test(:,1),raw_test(:,end),result.svm_shrink(shrink,var).svm.result);
                            [result.svm_shrink(shrink,var).eval, result.svm_shrink(shrink,var).report] = evaluation(result.svm_shrink(shrink,var).reverse.pair,halfwindowSize);
                    end;
                end;
            end;
        end;
        end;
    end;

    %%%%%%%report
    result.report=report(result);
    
    
    
    
            
%sampling
%if strcmp(samplevar,'simple');
%    traindata=simple(traindata);
%    testdata=simple(testdata);
%    result.train=traindata;
%    result.test=testdata;
%else if strcmp(samplevar,'2interaction');
%        traindata=interaction2(traindata);
%       testdata=interaction2(testdata);
%        result.train=traindata;
%        result.test=testdata;
%else if strcmp(samplevar,'3interaction')
%        traindata=interaction3(traindata);
%        testdata=interaction3(testdata);
%        result.train=traindata;
%        result.test=testdata;
%    end;
%    end;
%end;        
        
        
        
        
%        traindata=data.train;
%        testdata=data.test;
 %       result.generatetraining.period.train=traindata;
 %       result.generatetraining.period.test=testdata;
%        result.generatetraining.period.idx=data.idx;
%%shrink
%    else if strcmp(sampleobs,'interval')
%            traindata=interval(traindata);
%            testdata=interval(testdata);
 %           result.generatetraining.interval.train=traindata;
%            result.generatetraining.interval.test=testdata;
 %       else if strcmp(sampleobs,'intervalrow')
%            data=intervalrow(traindata,testdata);
%            traindata=data.train;
%            testdata=data.test;
%{           result.generatetraining.intervalrow.train=traindata;
%            result.generatetraining.intervalrow.test=testdata;
%            result.generatetraining.intervalrow.idx=data.bestidx;
%            end;
%        end;
%    end;
%}
%%different kinds of interaction    
%    data=generatevar(traindata,testdata);
%    traindata=data.train;
%    testdata=data.test;
%    result.generatevar.confusion=data.confusion;
%    result.generatevar.bestidx=data.idx;
%    result.generatevar.train=traindata;
%    result.generatevar.test=testdata;

%supervised learning
%if strcmp(machine,'randomforest')
    %result.rf=randomforest(traindata,testdata);
%end;
%if strcmp(machine,'glm')
%    result.glm=glm(traindata,testdata);
%end;
%if strcmp(machine,'decision tree')
%    result.tree=tree(traindata,testdata);
%end;
 %   result.svm=svm(traindata,testdata);

%%3 results from different machine learning method

%unsupervised learning
% if strcmp(machine,'kmeans')
%     result.kmeans=k_means(traindata);
% end;


%%evaluate result;
%if strcmp(sampleobs,'period');
%result.pair_period_glm=period_test(raw_test(:,1),raw_test(:,end),result.glm.result);
%result.pair_period_tree=period_test(raw_test(:,1),raw_test(:,end),result.tree.result);
%%result.pair_period_rf=period_test(raw_test(:,1),raw_test(:,end),result.rf.result);
%result.pair_period_svm=period_test(raw_test(:,1),raw_test(:,end),result.svm.result);
%[result.pair_period_glm.eval, result.pair_period_glm.rtn] = evaluation(result.pair_period_glm.pair,halfwindowSize);
%[result.pair_period_tree.eval, result.pair_period_tree.rtn] = evaluation(result.pair_period_tree.pair,halfwindowSize);
%[result.pair_period_svm.eval, result.pair_period_svm.rtn] = evaluation(result.pair_period_svm.pair,halfwindowSize);
%else if strcmp(sampleobs,'intervalrow');
%result.pair_interval_glm=interval_test(raw_test(:,1),raw_test(:,end),result.glm.result);
%result.pair_interval_tree=interval_test(raw_test(:,1),raw_test(:,end),result.tree.result);
%result.pair_interval_rf=interval_test(raw_test(:,1),raw_test(:,end),result.rf.result);
%result.pair_interval_svm=interval_test(raw_test(:,1),raw_test(:,end),result.svm.result);
%[result.pair_interval_glm.eval, result.pair_interval_glm.rtn] = evaluation(result.pair_interval_glm.pair,halfwindowSize);
%[result.pair_interval_tree.eval, result.pair_interval_tree.rtn] = evaluation(result.pair_interval_tree.pair,halfwindowSize);
%[result.pair_interval_svm.eval, result.pair_interval_svm.rtn] = evaluation(result.pair_interval_svm.pair,halfwindowSize);
%    end;
%end;




end

