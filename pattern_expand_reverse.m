function result= pattern_expand_reverse(prediction, test, windowsize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%windowsize=20;
%prediction=result_svm.result(:,2);
%test=test(:,end);
windows=2*windowsize+1;
output=tsmovavg(prediction,'s',windows,1);
row=size(prediction,1);
tmp_row=size(output,1);
output(end+windows)=0;
for i=1:row
    output(i)=output(i+windows);
end;
output(tmp_row+1:end)=[];

startpoint=size(output,1)-windows+1;
for i=startpoint:size(output,1)
    interval=size(output,1)-i;
    output(i)=mean(prediction(i:end));
end;

%%%add plot funtion in percentage

idx=find(test(:,end)==1);
drink=test(idx,:);

figure;
plot(test(:,1),output);
hold on;
%plot vertical line
x=drink(:,1);
y=0:0.1:1;
plot(x*ones(size(y)),y,'r','LineWidth',1);
title('percentage in window size');
xlabel('time');
ylabel('percentage');


%%%%%reverse to ground truth
max_percent=max(output)-0.1;
if max_percent~=0
    output=output>=max_percent;
end;
%compare=[output,transfer];


ci=floor(windows/2);
for i=1:row
    if output(i)==1 && (i-ci)>0
        b=zeros(windows,1);
        output((i-ci):(i+ci))=b;
        output(i)=1;
    else if output(i)==1 && (i-ci)<=0 
            b=zeros(i+ci,1);
            output(1:(i+ci))=b;
            output(i)=1;
        end;
    end;
end;

%%cut tail
new_row=size(output,1);
diff=new_row-row;
if diff >0
    output((end-diff+1:end),:)=[];    
    result=output;
else 
    result=output;
end;

end

