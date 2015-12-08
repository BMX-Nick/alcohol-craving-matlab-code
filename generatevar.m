function result = generatevar( train,test )


%%compare two method: simple 4 variable and 2-interaction;
%%give the best accuracy of one index
for method=1:2
    if method==1
%         traindata{method}=interaction2(train);
%         testdata{method}=interaction2(test);
        traindata{method}=simple(train);
        testdata{method}=simple(test);
        pred{method}=glm(traindata{method},testdata{method});
        accuarcy_all(method)=pred{method}.accuarcy_all;
        accuarcy_drink(method)=pred{method}.accuarcy_drink;
    end;
    if method==2
        traindata{method}=interaction2(train);
        testdata{method}=interaction2(test);
        pred{method}=glm(traindata{method},testdata{method});
        accuarcy_all(method)=pred{method}.accuarcy_all;
        accuarcy_drink(method)=pred{method}.accuarcy_drink;
    end;
end;
result.accuarcy_all=max(accuarcy_all);
result.accuarcy_drink=max(accuarcy_drink);
result.confusion.simple=pred{1}.confusion;
result.confusion.interaction=pred{2}.confusion;
result.idx=find(accuarcy_drink==result.accuarcy_drink);
result.train=traindata{result.idx(1)};
result.test=testdata{result.idx(1)};

end

