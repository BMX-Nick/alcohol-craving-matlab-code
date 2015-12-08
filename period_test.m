function result = period_test( time, test,prediction, windowsize)
%prediction=[0;0;0;0;0;1;1;1;0;0;1;1;1;1;1;1;0;0;0;0];
%time=test(:,1);
%test=test(:,end);
%prediction=result_tree.result{1}(:,1);
%windowsize=5;
windows=windowsize*12+1;
%windows=4;
output=tsmovavg(prediction,'s',windows,1);
row=size(prediction,1);
output(end+windows-1)=0;
for i=1:row
    output(i)=output(i+windows-1);
end;
output=output>=0.50;
for i=1:row
    if output(i)==1
        b=zeros(windows-1,1);
        output(i+1:i+windows-1)=b;
    end;
end;

output(end-windows+2:end,:)=[];

        

result.pair=[time,test,output];
       

end

