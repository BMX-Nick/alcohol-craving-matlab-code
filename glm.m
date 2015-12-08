function result_glm = glm( train,test )
%%generlized linear model
%%logistical model
    glm=fitglm(train(:,1:end-1),train(:,end),'linear','Distribution','binomial','link','logit');
    pred_glm=predict(glm,test(:,1:end-1));
    predcut=pred_glm>=0.5;
    confusion=confusionmat(test(:,end),double(predcut));
    if size(confusion,1)==2 && size(confusion,2)==2 
%%accuracy is percentage of true positive
        accuracy_drink=confusion(2,2)/sum(confusion(2,:));
        accuracy_all=(confusion(1,1)+confusion(2,2))/length(predcut);
    else if size(confusion,1)==1 && size(confusion,2) == 1
            %%%%all 0
            accuracy_drink=0;
            accuracy_all=size(test,1)/length(predcut);
        
        else if size(confusion,1)==1 && size(confusion,2) ==2
            %%%test is all 0 but pred has 1
            accuracy_drink=0;
            accuracy_all=confusion(1,1)/length(predcut);
        
            else if size(confusion,1)==2 && size(confusion,2) ==1
            %%%test has 1 but pred is all 0
            accuracy_drink=0;
            accuracy_all=confusion(1,1)/length(predcut);
                end;
            end;
        end;
    end;
            

%%count test information   
drink_count=sum(test(:,end));
benchmark=drink_count/size(test,1);
    
%%output
result_glm.glminfo=glm;
result_glm.accuarcy_drink=accuracy_drink;
result_glm.accuarcy_all=accuracy_all;
result_glm.result=predcut;
result_glm.drink_percentage_in_test=benchmark;
result_glm.confusion_matrix=confusion;
end


