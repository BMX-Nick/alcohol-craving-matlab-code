function return_data = drink_summary( patient )

%read survey data
directory='C:\Users\pp\Desktop\new data\survey';
%patient='1007';
full_filename=fullfile(directory,patient);
data=readsurvey([full_filename '.csv']);

%extract useful information
select=data(:,[1:10,80,81,133,134,181,191]);
%time
[tmpdate tmptime]=strtok(select.StartTS,' ');
select.StartTS=tmpdate;
select.EndTS=tmptime;

%modify column name
select.Properties.VariableNames([10:16])={'starttime','id_drink','id_drinknum','rs_drink','rs_drinknum','df_drinknum','rs_drinktime'};

%feature selection
data=select(:,{'ID','Type1','StartTS','starttime','id_drink','id_drinknum','rs_drink','rs_drinknum','rs_drinktime','df_drinknum'});

%have useful dataset
data(strcmp(data.Type1,''),:)=[];
for i=1:size(data,1)
   if strcmp(data.Type1(i),'ID') || strcmp(data.Type1(i),'DF') || strcmp(data.Type1{i}(1:2),'RS')==1
       data1(i,:)=data(i,:);
   end;
end; 
data1(data1.ID==0,:)=[];
data1(strcmp(data1.StartTS,''),:)=[];

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
cleaned.Properties.VariableNames(11)={'time'};

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
                break;
            end;
        end;
    end;
    time_flag=part_data.drinktime(j);
    idx_flag=j;
    if idx_flag<size(part_data,1)
    while idx_flag<=size(part_data,1)
        time=time_flag+2;
        tmp_upper=abs(time-part_data.time);
        idx_lower=idx_flag;
        [idx_upper idx_upper]=min(tmp_upper);

        
        if time<=part_data.time(size(part_data,1))
            if part_data.time(idx_upper)<=time
                if (idx_lower+1)<=idx_upper
                    for m=idx_lower+1:idx_upper
                        if part_data.drink(m)==1
                            idx_flag=m;
                            time_flag=part_data.drinktime(idx_flag);
                            part_data.episode(m)=0;
                            break;
                        end;
                    end;
                else
                    m=idx_lower+1;
                    idx_flag=m;
                    if idx_flag<=size(part_data,1)
                        time_flag=part_data.drinktime(idx_flag);
                    else
                        time_flag=part_data.drinktime(size(part_data,1));
                    end;
                end;
                if m==idx_upper && part_data.drink(m)==0
                    for t=idx_upper+1:size(part_data,1)
                        if part_data.drink(t)==1
                        %part_data.episode((idx_upper+1):(t-1))=0;
                            part_data.episode(t)=1;
                            break;
                        end;
                    end;
                    time_flag=part_data.drinktime(t);
                    idx_flag=t+1; 
                end;
            else
                if (idx_lower+1)<=(idx_upper-1)
                    for m=idx_lower+1:idx_upper-1
                        if part_data.drink(m)==1
                            idx_flag=m;
                            time_flag=part_data.drinktime(idx_flag);
                            part_data.episode(m)=0;
                            break;
                        end;
                    end;
                else
                    m=idx_lower+1;
                    idx_flag=m;
                    if idx_flag<=size(part_data,1)
                        time_flag=part_data.drinktime(idx_flag);
                    else
                        time_flag=part_data.drinktime(size(part_data,1));
                    end;
                end;
                if (idx_upper-1)<=m && part_data.drink(m)==0
                    for t=idx_upper:size(part_data,1)
                        if part_data.drink(t)==1
                        %part_data.episode((idx_upper+1):(t-1))=0;
                            part_data.episode(t)=1;                         
                            break;
                        end;
                    end;
                    time_flag=part_data.drinktime(t);
                    idx_flag=t+1;   
                end;
            end;
        else
            part_data.episode(idx_lower+1:size(part_data,1))=0;
            t=size(part_data,1);
            time_flag=part_data.drinktime(t);
            idx_flag=t+1;             
        end;
    end;
    lasttime=24;
    smalldata=part_data.drinktime(part_data.drink==1);
    if ~isempty(smalldata)
        lasttime=smalldata(end);
    end;
    end;
    cleaned.episode(strcmp(cleaned.StartTS,date{i}))=part_data.episode;
end;    

return_data=cleaned;
end

