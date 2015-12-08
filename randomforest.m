function arracy = randomforest( train,test )
%%randomforest
row=size(test(:,end),1);
num=size(train(:,2:end-1),1);
for i=1:num
    rffit=TreeBagger(50,train(:,2:end-1),train(:,end),'NvarToSample',i,'Method','classification','oobpred','on');
    pred=predict(rffit,test(:,2:end-1));
    result(:,i)=double(nominal(pred))-1;
    confusion{i}=confusionmat(test(:,end),result(:,i));
    accuracy_drink(i)=confusion{i}(2,2)/sum(confusion{i}(2,:));
    accuracy_all(i)=(confusion{i}(1,1)+confusion{i}(2,2))/length(result(:,i));
end;
%%count test information   
drink_count=sum(test(:,end));
benchmark=drink_count/size(test,1);

%%output
arracy.accuracy_drink=max(accuracy_drink);
arracy.index=find(accuracy_drink==arracy.accuracy_drink);
arracy.accuracy_all=accuracy_all(arracy.index);
arracy.result=result(:,arracy.index);
arracy.benchmark=1-benchmark;
arracy.confusion=confusion{arracy.index(1)};
arracy.good_or_not=arracy.accuracy_all>arracy.benchmark;
end

