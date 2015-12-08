function return_data = summary_drink( patient)

%patient='1005';
data=readtable([patient 'drink.csv']);
%modify column name
data.Properties.VariableNames([13 14 15 16])={'id_drink','rs_drink','rs_numberofdrink','df_drink'};
%feature selection
data=data(:,{'ID','Type_1','StartTS','starttime','id_drink','rs_drink','df_drink'});

%have useful dataset
data(strcmp(data.Type_1,''),:)=[];
for i=1:size(data,1)
   if strcmp(data.Type_1(i),'ID') || strcmp(data.Type_1(i),'DF') || strcmp(data.Type_1{i}(1:2),'RS')==1
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
cleaned.Properties.VariableNames(8)={'time'};




%selection for drink time
for i=1:size(cleaned,1)
    %initial drink
    switch cleaned.id_drink(i)
        case 1
           cleaned.drinktime(i)=cleaned.time(i);
        case 2
           cleaned.drinktime(i)=cleaned.time(i)-15/60;
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case 3
           cleaned.drinktime(i)=cleaned.time(i)-30/60;
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case 4
           cleaned.drinktime(i)=cleaned.time(i)-45/60;
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case 5
           cleaned.drinktime(i)=cleaned.time(i)-1;
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        case 6
           cleaned.drinktime(i)=cleaned.time(i)-1.5;
           if cleaned.drinktime(i)<0
               cleaned.drinktime(i)=cleaned.drinktime(i)+24;
           end;
        otherwise
           cleaned.drinktime(i)=0;
    end;
  
    %random survey
        if cleaned.rs_drink(i)==1
            cleaned.drinktime(i)=cleaned.time(i);
        end;
    %drink follow up
        if cleaned.df_drink(i)==1
            cleaned.drinktime(i)=cleaned.time(i);
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

date=unique(cleaned.StartTS);

for i=1:size(cleaned,1)
    cleaned.episode(i)=0;
end;
%%this function can deal with more than 2 drink greater than 2 hours in one day!
for i = 1: size(date,1);
    part_data=cleaned(strcmp(cleaned.StartTS,date{i}),:);
    for j=1:size(part_data,1)
        if part_data.drink(j)==1
            part_data.episode(1:(j-1))=0;
            part_data.episode(j)=1;
            break;
        end;
    end;
    time_flag=part_data.drinktime(j);
    idx_flag=j;
    while idx_flag<=size(part_data,1)
        time=time_flag+2;
        tmp_lower=abs(time_flag-part_data.time);
        tmp_upper=abs(time-part_data.time);
        [idx_lower idx_lower]=min(tmp_lower);
        [idx_upper idx_upper]=min(tmp_upper);
        if time<=part_data.time(size(part_data,1))
            for t=idx_upper:size(part_data,1)
                if part_data.drink(t)==1
                    part_data.episode((idx_lower+1):(t-1))=0;
                    part_data.episode(t)=1;
                    break;
                end;
            end;
        else
            t=size(part_data,1);
            part_data.episode(t)=0;
        end;
            
         time_flag=part_data.drinktime(t);
         idx_flag=t+1;
    end;
    cleaned.episode(strcmp(cleaned.StartTS,date{i}))=part_data.episode;
end;    


%%%return selected data
return_data=cleaned;

end


