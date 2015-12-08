function  summary=mood( patient )
%%search mood information 

directory='C:\Users\pp\Desktop\new data\survey';
%patient='1024';
full_filename=fullfile(directory,patient);
data=readsurvey([full_filename '.csv']);


%shrink data size 
data(strcmp(data.Sadness,''),:)=[];
data(strcmp(data.Sadness,'0'),:)=[];

%extract useful information
select=data(:,[1:10,185:189]);


%time
[tmpdate tmptime]=strtok(select.StartTS,' ');
select.StartTS=tmpdate;
select.EndTS=tmptime;

%modify column name
select.Properties.VariableNames([10])={'starttime'};

%feature selection
data=select(:,{'ID','Type1','StartTS','starttime','Positive','Negative','Fear','Hostility','Sadness'});

for i =1 : size(data,1)
    data.hour(i)=hour(data.starttime(i));
end;

subdata=data(:,[5:10]);
%positive,negative,fear,hostility,sadness
sorted=sortrows(subdata,'hour');

for i=1:5
    for j=1:size(sorted,1)
        subsorted(j,i)=str2num(cell2mat(table2array(sorted(j,i))));
    end;
end;

subsorted=array2table(subsorted);

subsorted.Properties.VariableNames([1:5])={'Positive','Negative','Fear','Hostility','Sadness'};

subsorted.hour=sorted.hour;
group_data=grpstats(subsorted,'hour','mean');


group_data.Properties.VariableNames([3:7])={'Positive','Negative','Fear','Hostility','Sadness'};

plot_data=table2array(group_data);


%%%%drink summary
data=drink_summary(patient);

for i =1 : size(data,1)
    data.hour(i)=floor(data.drinktime(i));
end;

subdata=data(:,[2,12,14,15,16]);
sorted=sortrows(subdata,'hour');

subsorted=sorted(:,2:5);
subsorted=table2array(subsorted);
time=unique(subsorted(:,4));
output=[];
for j = 1 : size(time,1)
    part_data=subsorted(subsorted(:,4)==time(j),:);
    a=sum(part_data(:,1));
    b=sum(part_data(:,2));
    c=sum(part_data(:,3));
    d=time(j);
    combine=[a,b,c,d];
    output=[output;combine];
end;

%figure
%%%plot both plot
[ax,b,p]=plotyy(output(:,4),output(:,1:3),plot_data(:,1),plot_data(:,3:7),'bar','plot');   


%%make attribute for plots
legend('numbers of drink','drink times','episode times','Positive','Negative','Fear','Hostility','Sadness');


ax(1).XLim=[-1 24];
ax(2).XLim=[-1 24];
ax(1).YLim=[0 15];
ax(2).YLim=[0 5];
ax(1).XTick=0:2:24;
ax(2).XTick=0:2:24;
ax(1).YTick=0:2:15;
ax(2).YTick=0:2:5;

xlabel('Time');
ylabel(ax(1),'Drink');
ylabel(ax(2),'mean of Mood');
title(patient);    


summary.drinknum=sum(output(:,1));
summary.drinks=sum(output(:,2));
summary.episode=sum(output(:,3));
summary.numperEpisode=summary.drinknum/summary.episode;


end

