function period = period( train, min, max, step)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this function will expand label for 
%drinking episode in order to see how
%long the alcohol works for person.
%it will test different parameter for
%time period and see result;
%
%written by peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %train=traindata;
        %min=5;
        %max=10;
        %step=5;
        %test=testdata;
        
        %extract period data
        
        train_period=train(train(:,end)==1,:);
        m1=size(train_period,1);
        
        %test_period=test(test(:,end)==1,:);
        %m2=size(test_period,1);
        
        %if do not have drinking episode
        if m1==0
            period.train=train;
        else 
            flag=1;
            for t1=min/60:step/60:max/60
                %train
                for i=1:m1
                    endtime=train_period(m1,1)+t1;
                    starttime=train_period(m1,1);
                    train(train(:,1)<=endtime&train(:,1)>=starttime,end)=1;
                end;
                training{flag}=train;
                flag=flag +1;
            end;
            period.train=training;
        end;
        
        %if m2==0
        %    period.test=test;
        %end;
        
        %if have

            
                    
                    
                    
                    
                    
                %%test should not make any change
                %    endtime=test_period(m2,1)+t1;
                %    starttime=test_period(1,1)-t2;
                %    test(test(:,1)<=endtime&test(:,1)>=starttime,end)=1;
                %fit glm to see correlation for test
 %               glm=fitglm(train(:,2:end-1),train(:,end),'linear','Distribution','binomial','link','logit');
 %               pred=predict(glm,test(:,2:end-1));
 %               pred=pred>=0.5;
                
                %make confusion matrix in differenet situation
                %test can not be all 1 but can be all 0
                %pred can be all 1 or all 0
  %              if sum(test(:,end))~=0 || sum(pred)~=0
  %                  confusion{flag}=confusionmat(double(pred),test(:,end));
  %                  accuracy_all(flag)=(confusion(1,1)+confusion(2,2))/length(pred);
  %                  accuracy_true(flag)=confusion(2,2)/sum(confusion(2,:));
  %                  flag=flag+1;   
  %              end;
  %              if sum(test(:,end))==0 && sum(pred)==0
  %                  confusion{flag}=[size(pred,1),0;0,0];
  %                  accuracy_all(flag)=(confusion{flag}(1,1)+confusion{flag}(2,2))/length(pred);
  %                  accuracy_true(flag)=confusion{flag}(2,2)/sum(confusion{flag}(2,:));
  %                  flag=flag+1;   
  %              end;
  %          end;
  %      end;

  %          best_idx=find(max(accuracy_all));
        %give best train data
  %      if m1~=0
  %          endtime=train_period(m1,1)+(5*best_idx)/60;
  %          starttime=train_period(1,1);
  %          train(train(:,1)<=endtime&train(:,1)>=starttime,end)=1;
  %          period.train=train;
  %      end;

        %return raw test data
  %      period.test=test;
        
        %return result
  %      period.confusion=confusion{best_idx};
  %      period.idx=(5*best_idx)/60;

end

