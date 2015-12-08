
short_train=traindata(traindata(:,1)<=8|18<=traindata(:,1),:);
short_test=testdata(testdata(:,1)<=8|18<=testdata(:,1),:);
windows=30;
train=moving_check(short_train,12,windows);
test=moving_check(short_test,12,0);


%%%%%%%%%svm
result_svm=svm(train,test);
raw_test=short_test;
for ke=1:3
    result_svm.reverse{ke}=pattern_expand_reverse(result_svm.result(:,ke),test,windows);
    result_svm.reverse2{ke}=interval_test(raw_test(:,1),raw_test(:,end),result_svm.reverse{ke});
    [result_svm.eval{ke}, result_svm.report{ke}] = evaluation(result_svm.reverse2{ke}.pair,60);
end;




%%%%%%%tree
result_tree=tree(train,test);
prune={'on','off'};
for p=1:size(prune,2)
    for v=1:(size(train,2)-1)
    result_tree.reverse{p}{v}=pattern_expand_reverse(result_tree.result{p}(:,v),test,windows);
    result_tree.reverse2{p}{v}=interval_test(raw_test(:,1),raw_test(:,end),result_tree.reverse{p}{v});
    [result_tree.eval{p}{v}, result_tree.report{p}{v}] = evaluation(result_tree.reverse2{p}{v}.pair,60);
    end;
end;







result.svm_extension.reverse_train=period_test(raw_train(:,1),raw_train(:,end),result.svm_extension(ex,var).svm.training_result(:,ke),2*ex);
[result.svm_extension.eval, result.svm_extension.report] = evaluation(result.svm_extension(ex,var).reverse{ke}.pair,halfwindowSize);
[result.svm_extension.eval_train, result.svm_extension.report_train] = evaluation(result.svm_extension(ex,var).reverse_train{ke}.pair,halfwindowSize);











kernel={'rbf','linear','polynomial'};
for ke=1:size(kernel,2)
result.svm_extension(ex,var).reverse{ke}=period_test(raw_test(:,1),raw_test(:,end),result.svm_extension(ex,var).svm.result(:,ke),2*ex);
result.svm_extension(ex,var).reverse_train{ke}=period_test(raw_train(:,1),raw_train(:,end),result.svm_extension(ex,var).svm.training_result(:,ke),2*ex);
[result.svm_extension(ex,var).eval{ke}, result.svm_extension(ex,var).report{ke}] = evaluation(result.svm_extension(ex,var).reverse{ke}.pair,halfwindowSize);
[result.svm_extension(ex,var).eval_train{ke}, result.svm_extension(ex,var).report_train{ke}] = evaluation(result.svm_extension(ex,var).reverse_train{ke}.pair,halfwindowSize);
end;