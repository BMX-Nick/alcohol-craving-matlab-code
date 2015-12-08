function result_tree = tree( train, test )
%train=data3.origin_traindata;
%test=data3.origin_testdata;
col=size(train,2);
%%train
for i=1:2
    if i==1
        for j=1:col-1
            tree=fitctree(train(:,1:end-1),train(:,end),'Prune', 'off', 'NumVariablesToSample', j);
            pred_tree{i}(:,j)=predict(tree,test(:,1:end-1));
            training_tree{i}(:,j)=predict(tree,train(:,1:end-1));
            confusion{i,j}=confusionmat(test(:,end),pred_tree{i}(:,j));
            confusion_training{i,j}=confusionmat(train(:,end),training_tree{i}(:,j));
            
            if size(confusion{i,j})==[2,2]
                accuracy_drink(i,j)=confusion{i,j}(2,2)/sum(confusion{i,j}(2,:));
                accuracy_all(i,j)=(confusion{i,j}(1,1)+confusion{i,j}(2,2))/length(pred_tree{i}(:,j));
                confusion_matrix{i,j}=confusion{i,j};
                else if size(confusion{i,j},1)==1 && size(confusion{i,j},2) == 1
                        %%%%all 0
                        accuracy_drink(i,j)=0;
                        accuracy_all(i,j)=1;
                        confusion_matrix{i,j}=[size(test,1),0;0,0];
                    else if size(confusion{i,j},1)==1 && size(confusion{i,j},2) ==2
                            %%%test is all 0 but pred has 1
                            accuracy_drink(i,j)=0;
                            accuracy_all(i,j)=confusion{i,j}(1,1)/length(pred_tree{i}(:,j));
                            confusion_matrix{i,j}=[confusion{i,j};0,0];
        
                        else if size(confusion{i,j},1)==2 && size(confusion{i,j},2) ==1
                                %%%test has 1 but pred is all 0
                                accuracy_drink(i,j)=0;
                                accuracy_all(i,j)=confusion{i,j}(1,1)/length(pred_tree{i}(:,j));
                                confusion_matrix{i,j}=[confusion{i,j}(1,1),0;confusion{i,j}(2,1),0];
                            end;
                        end;
                    end;
                end;
        end;   
    else if i==2
            for j=1:col-1
                tree=fitctree(train(:,1:end-1),train(:,end),'Prune', 'on', 'NumVariablesToSample', j);
                pred_tree{i}(:,j)=predict(tree,test(:,1:end-1));
                training_tree{i}(:,j)=predict(tree,train(:,1:end-1));
                confusion{i,j}=confusionmat(test(:,end),pred_tree{i}(:,j));
                confusion_training{i,j}=confusionmat(train(:,end),training_tree{i}(:,j));
            if size(confusion{i,j})==[2,2]
                accuracy_drink(i,j)=confusion{i,j}(2,2)/sum(confusion{i,j}(2,:));
                accuracy_all(i,j)=(confusion{i,j}(1,1)+confusion{i,j}(2,2))/length(pred_tree{i}(:,j));
                confusion_matrix{i,j}=confusion{i,j};
                else if size(confusion{i,j},1)==1 && size(confusion{i,j},2) == 1
                        %%%%all 0
                        accuracy_drink(i,j)=0;
                        accuracy_all(i,j)=1;
                        confusion_matrix{i,j}=[size(test,1),0;0,0];
                    else if size(confusion{i,j},1)==1 && size(confusion{i,j},2) ==2
                            %%%test is all 0 but pred has 1
                            accuracy_drink(i,j)=0;
                            accuracy_all(i,j)=confusion{i,j}(1,1)/length(pred_tree{i}(:,j));
                            confusion_matrix{i,j}=[confusion{i,j};0,0];
        
                        else if size(confusion{i,j},1)==2 && size(confusion{i,j},2) ==1
                                %%%test has 1 but pred is all 0
                                accuracy_drink(i,j)=0;
                                accuracy_all(i,j)=confusion{i,j}(1,1)/length(pred_tree{i}(:,j));
                                confusion_matrix{i,j}=[confusion{i,j}(1,1),0;confusion{i,j}(2,1),0];
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

%%output
result_tree.accuarcy_drink=accuracy_drink;
result_tree.accuracy_all=accuracy_all;
result_tree.confusion=confusion_matrix;
result_tree.training_result=training_tree;
result_tree.result=pred_tree;
result_tree.confusion_fake=confusion;
result_tree.confusion_training=confusion_training;
end

