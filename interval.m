function interval = interval( data )
m=size(data(:,1),1);
time=data(:,1);
f={};
for i = 1:m
hour=floor(time(i));
minute=floor((time(i)-hour)*60);
second=floor((time(i)-hour-minute/60)*3600);
f(i)=cellstr(sprintf('%02d:%02d:%02d', hour,minute,second ));
end;
time=num2cell(time);
f=transpose(f);
for i=1:m
    time{i}=f{i};
end;
time=cell2table(time);
data=array2table(data);
data=[data,time];

for i=1:m
    data.time{i}=data.time{i}(1:end-3);
end;
data=grpstats(data,'time','mean');
data=table2array(data(:,3:end));
data(:,end)=ceil(data(:,end));    
interval=data;
end

