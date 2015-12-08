function result = moving_check( data, windows ,expand)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%data=traindata;
%windows=12;
%expand=5;
row=size(data,1);
col=size(data,2);


%%%label group
for i=1:ceil(row/windows)
    data(((i-1)*windows+1):(i*windows),col+1)=i;
end;

%%%cut tail
data(data(:,1)==0,:)=[];
    
stat_mean=grpstats(data(:,2:6),data(:,col+1),'mean');
stat_var=grpstats(data(:,2:5),data(:,col+1),'var');

label=unique(data(:,col+1));
for i=1:size(label,1)
    subdata=data(data(:,col+1)==i,:);
    time(i,1)=subdata(1,1);
    %slope
    for j=2:5
        slope(i,j-1)=(subdata(end,j)-subdata(1,j))/(windows-1);
    end;
end;

%%%%add 2-interaction
part_data=[time,stat_mean(:,1:5)];
mean_data=interaction2(part_data);
%%%combine to new data
newdata=[mean_data(:,1:(end-1)),stat_var,slope,stat_mean(:,5)];

newdata(:,2)=round(newdata(:,2));
newdata(:,4:6)=round(newdata(:,4:6));
newdata(:,end)=ceil(newdata(:,end));

%%%expand drink time
%interval=floor(expand/2);
tmp=find(newdata(:,end)==1);
tmp_row=size(tmp,1);

if tmp_row==0
    result=newdata;
else
    for i=1:tmp_row
        newdata((tmp(i)-expand):(tmp(i)+expand),end)=1;
    end;
    result=newdata;
end;





end

