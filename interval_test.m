function result = interval_test( time, test,prediction )
%prediction=[0;0;0;0;0;1;1;1;0;0;1;1;1;1;1;1;0;0;0;0];
%%%output pair matrix
%prediction=result_svm.reverse{1};
%time=short_test(:,1);
%test=short_test(:,end);
row=size(prediction,1);
test_row=size(test,1);
pred_new=[];
windows=ceil(test_row/row);
for i=1:row;
    if prediction(i)==0
       fix=zeros(windows,1);
    else if prediction(i)==1 && mod(windows,2)==0
        fix=[zeros(floor(windows/2)-1,1);1;zeros(floor(windows/2),1)];
    else if prediction(i)==1 && mod(windows,2)~=0
            fix=[zeros(floor(windows/2),1);1;zeros(floor(windows/2),1)];
            end;
        end;
    end;
    pred_new=[pred_new;fix];
end;
   %%add rest number of test
   pred_new_row=size(pred_new,1);
   diff=test_row-pred_new_row;
   if diff>0
      last_row=zeros(diff,1);
      pred_new=[pred_new;last_row];
   else if diff < 0
           last_row=zeros(-diff,1);   
           time=[time;last_row];
           test=[test;last_row];
       end;
   end;
    %make pair matrix   
result.pair=[time,test,pred_new];
result.pair(result.pair(:,1)==0,:)=[];



end

