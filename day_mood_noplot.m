function result = day_mood_noplot( patient )
directory='C:\Users\pp\Desktop\new data\survey';
%patient='1008';
full_filename=fullfile(directory,patient);
data=readsurvey([full_filename '.csv']);


%extract useful information
select=data(:,[1:10,80,81,133,134,181,191,185:189]);
%time
[tmpdate tmptime]=strtok(select.StartTS,' ');
select.StartTS=tmpdate;
select.EndTS=tmptime;

%modify column name
select.Properties.VariableNames([10:21])={'starttime','id_drink','id_drinknum','rs_drink','rs_drinknum','df_drinknum','rs_drinktime','Positive','Negative','Fear','Hostility','Sadness'};

%feature selection
data=select(:,{'ID','Type1','StartTS','starttime','id_drink','id_drinknum','rs_drink','rs_drinknum','rs_drinktime','df_drinknum','Positive','Negative','Fear','Hostility','Sadness'});

%have useful dataset
data(strcmp(data.Type1,''),:)=[];



for i=1:size(data,1)
   if strcmp(data.Type1(i),'ID') || strcmp(data.Type1(i),'DF') || strcmp(data.Type1{i}(1:2),'RS')==1 || (~strcmp(data.Sadness(i),'') && ~strcmp(data.Sadness(i),'0'))
       %drink & mood
       data1(i,:)=data(i,:);
   end;
end; 

%drink
data1(data1.ID==0,:)=[];
data1(strcmp(data1.StartTS,''),:)=[];

%nondrink

%convert time format
for i=1:size(data1,1)
    h=hour(data1.starttime(i));
    m=minute(data1.starttime(i));
    s=second(data1.starttime(i));
    time_num(i,1)=h+m/60+s/3600;
end;
time_num=array2table(time_num);

%%strtok();


%make a new data(complete)
cleaned=[data1 time_num];
cleaned.Properties.VariableNames(end)={'time'};

for i=1:size(cleaned,1);
    cleaned.drinknum(i)=0;
end;

%selection for drink time

for i=1:size(cleaned,1)
    %initial drink time
    switch char(cleaned.id_drink(i))
        case '1'
           cleaned.drinktime(i)=cleaned.time(i);
           cleaned.drinknum(i)=str2num(cell2mat(cleaned.id_drinknum(i)));
        case '2'
           cleaned.drinktime(i)=cleaned.time(i)-15/60;
           cleaned.drinknum(i)=str2num(cell2mat(cleaned.id_drinknum(i)));
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case '3'
           cleaned.drinktime(i)=cleaned.time(i)-30/60;
           cleaned.drinknum(i)=str2num(cell2mat(cleaned.id_drinknum(i)));
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case '4'
           cleaned.drinktime(i)=cleaned.time(i)-45/60;
           cleaned.drinknum(i)=str2num(cell2mat(cleaned.id_drinknum(i)));
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case '5'
           cleaned.drinktime(i)=cleaned.time(i)-1;
           cleaned.drinknum(i)=str2num(cell2mat(cleaned.id_drinknum(i)));
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case '6'
           cleaned.drinktime(i)=cleaned.time(i)-1.5;
           cleaned.drinknum(i)=str2num(cell2mat(cleaned.id_drinknum(i)));
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        otherwise
           cleaned.drinktime(i)=0;
    end;
  
    %random survey
        if strcmp(cleaned.rs_drink(i),'1')
            cleaned.drinknum(i)=str2num(cell2mat(cleaned.rs_drinknum(i)));
            switch char(cleaned.rs_drinktime(i))
                case '1'
                    cleaned.drinktime(i)=cleaned.time(i);
                case '2'
                    cleaned.drinktime(i)=cleaned.time(i)-15/60;
                    if cleaned.drinktime(i)<0
                        cleaned.drinktime(i)=cleaned.drinktime(i)+24;
                    end;
                case '3'
                    cleaned.drinktime(i)=cleaned.time(i)-30/60;
                    if cleaned.drinktime(i)<0
                        cleaned.drinktime(i)=cleaned.drinktime(i)+24;
                    end;
                case '4'
                    cleaned.drinktime(i)=cleaned.time(i)-45/60;
                    if cleaned.drinktime(i)<0
                        cleaned.drinktime(i)=cleaned.drinktime(i)+24;
                    end;
                case '5'
                    cleaned.drinktime(i)=cleaned.time(i)-1;
                    if cleaned.drinktime(i)<0
                        cleaned.drinktime(i)=cleaned.drinktime(i)+24;
                    end;
                case '6'
                    cleaned.drinktime(i)=cleaned.time(i)-1.5;
                    if cleaned.drinktime(i)<0
                        cleaned.drinktime(i)=cleaned.drinktime(i)+24;
                    end;
                case '-1'
                    cleaned.drinktime(i)=0;
                otherwise
                    cleaned.drinktime(i)=cleaned.time(i);
             end;
        end;
    %drink follow up
        if ~strcmp(cleaned.df_drinknum(i),'0') && ~strcmp(cleaned.df_drinknum(i),'')
            cleaned.drinktime(i)=cleaned.time(i);
            cleaned.drinknum(i)=str2num(cell2mat(cleaned.df_drinknum(i)));
        end;
end;

%%make drink time
for i =1:size(cleaned,1)
    if cleaned.drinktime(i)~=0
        cleaned.drink(i)=1;
    else
        cleaned.drink(i)=0;
    end;
end;

date=unique(cleaned.StartTS,'stable');

%%make a real compare time
for i=1:size(cleaned,1)
    if cleaned.drinktime(i)==0;
        cleaned.actualtime(i)=cleaned.time(i);
    else
        cleaned.actualtime(i)=cleaned.drinktime(i);
    end;
end;

for i=1:size(cleaned,1)
    cleaned.episode(i)=0;
end;



lasttime=24;
for i = 1: size(date,1);
    part_data=cleaned(strcmp(cleaned.StartTS,date{i}),:);
    for j=1:size(part_data,1)
        if part_data.drink(j)==1  
            if ~strcmp(part_data.Type1(j),'DF') || (part_data.drinktime(j) > lasttime+2-24 && (part_data.drinktime(j)-part_data.time(j))<12)
                part_data.episode(1:(j-1))=0;
                part_data.episode(j)=1;
                %part_data.mood(j)=1;
                break;
            end;
        end;
    end;
    
    if part_data.actualtime(j)>part_data.time(j)
        time_flag=part_data.time(j);
        time_flag=part_data.actualtime(j)-24;
    else
        time_flag=part_data.actualtime(j);
    end;
    
    idx_flag=j;
    if idx_flag<size(part_data,1)
    while idx_flag<=size(part_data,1)
        time=time_flag+2;
        tmp_upper=abs(time-part_data.actualtime);
        idx_lower=idx_flag;
        [idx_upper idx_upper]=min(tmp_upper);

        
        if time<=part_data.actualtime(size(part_data,1))
            if part_data.actualtime(idx_upper)<=time
                if (idx_lower+1)<=idx_upper
                    for m=idx_lower+1:idx_upper
                        if part_data.drink(m)==1
                            idx_flag=m;
                            time_flag=part_data.actualtime(idx_flag);
                            part_data.episode(m)=0;
                            %part_data.mood(idx_lower+1:m)=1;
                            break;
                        end;
                    end;
                else
                    m=idx_lower+1;
                    idx_flag=m;
                    if idx_flag<=size(part_data,1)
                        time_flag=part_data.actualtime(idx_flag);
                    else
                        time_flag=part_data.actualtime(size(part_data,1));
                    end;
                end;
                if m==idx_upper && part_data.drink(m)==0
                    for t=idx_upper+1:size(part_data,1)
                        if part_data.drink(t)==1
                        %part_data.episode((idx_upper+1):(t-1))=0;
                            part_data.episode(t)=1;
                            %part_data.mood(t)=1;
                            break;
                        end;
                    end;
                    time_flag=part_data.actualtime(t);
                    idx_flag=t+1; 
                end;
            else
                if (idx_lower+1)<=(idx_upper-1)
                    for m=idx_lower+1:idx_upper-1
                        if part_data.drink(m)==1
                            idx_flag=m;
                            time_flag=part_data.actualtime(idx_flag);
                            part_data.episode(m)=0;
                            %part_data.mood(idx_lower+1:m)=1;
                            break;
                        end;
                    end;
                else
                    m=idx_lower+1;
                    idx_flag=m;
                    if idx_flag<=size(part_data,1)
                        time_flag=part_data.actualtime(idx_flag);
                    else
                        time_flag=part_data.actualtime(size(part_data,1));
                    end;
                end;
                if (idx_upper-1)<=m && part_data.drink(m)==0
                    for t=idx_upper:size(part_data,1)
                        if part_data.drink(t)==1
                        %part_data.episode((idx_upper+1):(t-1))=0;
                            part_data.episode(t)=1; 
                            %part_data.mood(t)=1;
                            break;
                        end;
                    end;
                    time_flag=part_data.actualtime(t);
                    idx_flag=t+1;   
                end;
            end;
        else
            part_data.episode(idx_lower+1:size(part_data,1))=0;
            %part_data.mood(idx_lower+1:size(part_data,1))=1;
            t=size(part_data,1);
            time_flag=part_data.actualtime(t);
            idx_flag=t+1;             
        end;
    end;
    lasttime=24;
    smalldata=part_data.actualtime(part_data.drink==1);
    if ~isempty(smalldata)
        lasttime=smalldata(end);
    end;
    end;
    cleaned.episode(strcmp(cleaned.StartTS,date{i}))=part_data.episode;
    %cleaned.mood(strcmp(cleaned.StartTS,date{i}))=part_data.mood;
end;


%%%%mark drink mood


for i=1:size(cleaned,1)
    cleaned.mood(i)=0;
end;
        
for i = 1: size(date,1);
    mood_data=cleaned(strcmp(cleaned.StartTS,date{i}),:);
    
    %mark first episode
    for j=1:size(mood_data,1)
        if mood_data.episode(j)==1  
            mood_data.mood(1:end)=1;
        end;
    end;
    cleaned.mood(strcmp(cleaned.StartTS,date{i}))=mood_data.mood;
    %cleaned.mood(strcmp(cleaned.StartTS,date{i}))=part_data.mood;
end;

%split data into two parts
drink=cleaned(cleaned.mood==1,:);
nodrink=cleaned(cleaned.mood==0,:);

drink_day=size(unique(drink.StartTS),1);
nodrink_day=size(unique(nodrink.StartTS),1);

%make plot for each
for i =1 : size(drink,1)
    drink.hour(i)=hour(drink.starttime(i));
end;

for i =1 : size(nodrink,1)
    nodrink.hour(i)=hour(nodrink.starttime(i));
end;

subdata_drink=drink(:,[11:15,23]);
subdata_nodrink=nodrink(:,[11:15,23]);
%positive,negative,fear,hostility,sadness
sorted_drink=sortrows(subdata_drink,'hour');
sorted_nodrink=sortrows(subdata_nodrink,'hour');


for i=1:5
    for j=1:size(sorted_drink,1)
        if ~strcmp(table2array(sorted_drink(j,i)),'')
            subsorted_drink(j,i)=str2num(cell2mat(table2array(sorted_drink(j,i))));
        else
            subsorted_drink(j,i)=0;
        end;
    end;
end;

for i=1:5
    for j=1:size(sorted_nodrink,1)
        if ~strcmp(table2array(sorted_nodrink(j,i)),'')
            subsorted_nodrink(j,i)=str2num(cell2mat(table2array(sorted_nodrink(j,i))));
        else
            subsorted_nodrink(j,i)=0;
        end;
    end;
end;


subsorted_drink=array2table(subsorted_drink);
subsorted_nodrink=array2table(subsorted_nodrink);

subsorted_drink.Properties.VariableNames([1:5])={'Positive','Negative','Fear','Hostility','Sadness'};
subsorted_nodrink.Properties.VariableNames([1:5])={'Positive','Negative','Fear','Hostility','Sadness'};


subsorted_drink.hour=sorted_drink.hour;
subsorted_nodrink.hour=sorted_nodrink.hour;


group_data_drink=grpstats(subsorted_drink,'hour','mean');
group_data_nodrink=grpstats(subsorted_nodrink,'hour','mean');

group_data_drink.Properties.VariableNames([3:7])={'Positive','Negative','Fear','Hostility','Sadness'};
group_data_nodrink.Properties.VariableNames([3:7])={'Positive','Negative','Fear','Hostility','Sadness'};


plot_data_drink=table2array(group_data_drink);
plot_data_nodrink=table2array(group_data_nodrink);



%%%%drink summary
%data_sample=drink_summary(patient);


subdata_drink_episode=drink(:,[2,17,19,21,23]);
subdata_nodrink_episode=nodrink(:,[2,17,19,21,23]);

sorted_drink_episode=sortrows(subdata_drink_episode,'hour');
sorted_nodrink_episode=sortrows(subdata_nodrink_episode,'hour');



subsorted_drink_episode=sorted_drink_episode(:,2:5);
subsorted_nodrink_episode=sorted_nodrink_episode(:,2:5);


subsorted_drink_episode=table2array(subsorted_drink_episode);
subsorted_nodrink_episode=table2array(subsorted_nodrink_episode);



time=unique(subsorted_drink_episode(:,4));
output_drink_episode=[];
for j = 1 : size(time,1)
    part_data=subsorted_drink_episode(subsorted_drink_episode(:,4)==time(j),:);
    a=mean(part_data(:,1));
    b=mean(part_data(:,2));
    c=mean(part_data(:,3));
    d=time(j);
    combine=[a,b,c,d];
    output_drink_episode=[output_drink_episode;combine];
end;

time=unique(subsorted_nodrink_episode(:,4));
output_nodrink_episode=[];
for j = 1 : size(time,1)
    part_data=subsorted_nodrink_episode(subsorted_nodrink_episode(:,4)==time(j),:);
    a=mean(part_data(:,1));
    b=mean(part_data(:,2));
    c=mean(part_data(:,3));
    d=time(j);
    combine=[a,b,c,d];
    output_nodrink_episode=[output_nodrink_episode;combine];
end;

result.drink=drink;
result.nodrink=nodrink;
result.whole=cleaned;
result.drinkplot=output_drink_episode;
result.nodrinkplot=output_nodrink_episode;
result.moodplot=plot_data_drink;
result.nomoodplot=plot_data_nodrink;
result.drinkdays=drink_day;
result.nodrinkdays=nodrink_day;
end

