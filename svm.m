function  result_svm=svm( train, test )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Support Vector Machine(Simple)
%%%        written by peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%list kernel parameter%%%%%%%
kernel={'rbf','linear','polynomial'};

%train=data3.origin_traindata;
%test=data3.origin_testdata;
for i= 1:size(kernel,2)
    %%%%%%%training function%%%%%%%
    svmmodel=fitcsvm(train(:,1:end-1),train(:,end),'KernelFunction',kernel{i});

    %%%%%%%predict function%%%%%%%
    result(:,i)=predict(svmmodel,test(:,1:end-1));
    training(:,i)=predict(svmmodel,train(:,1:end-1));

    %%%%%%%test error%%%%%%%
    confusion{i}=confusionmat(test(:,end),result(:,i));
    confusion_training{i}=confusionmat(train(:,end),training(:,i));
    
    if size(confusion{i},1)==2 && size(confusion{i},2)==2
        accuracy_drink(i)=confusion{i}(2,2)/sum(confusion{i}(2,:));
        accuracy_all(i)=(confusion{i}(1,1)+confusion{i}(2,2))/length(result(:,i));
        confusion_matrix{i}=confusion{i};
    else if size(confusion{i},1)==1 && size(confusion{i},2) == 1
            %%%%all 0
            accuracy_drink(i)=0;
            accuracy_all(i)=1;
            confusion_matrix{i}=[size(test,1),0;0,0];
        
        else if size(confusion{i},1)==1 && size(confusion{i},2) ==2
            %%%test is all 0 but pred has 1
            accuracy_drink(i)=0;
            accuracy_all(i)=confusion{i}(1,1)/length(result(:,i));
            confusion_matrix{i}=[confusion{i};0,0];
        
            else if size(confusion{i},1)==2 && size(confusion{i},2) ==1
            %%%test has 1 but pred is all 0
                    accuracy_drink(i)=0;
                    accuracy_all(i)=confusion{i}(1,1)/length(result(:,i));
                    confusion_matrix{i}=[confusion{i}(1,1),0;confusion{i}(2,1),0];
                end;
            end;
        end;
    end;
end;


%%%%%%%count test information%%%%%%%   
drink_count=sum(test(:,end));

%%output
result_svm.accuracy_all=accuracy_all;
%result_svm.index=find(accuracy_drink==result_svm.accuracy_drink);
result_svm.accuracy_drink=accuracy_drink;
result_svm.training_result=training;
result_svm.result=result;
result_svm.confusion_fake=confusion;
result_svm.confusion=confusion_matrix;
result_svm.confusion_training=confusion_training;


end

