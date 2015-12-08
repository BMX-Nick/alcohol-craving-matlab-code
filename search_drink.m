function return_data = search_drink( patient , file )

%read survey data
%patient='1005';
data=calculate_survey(patient);
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
                    old_time_flag=time_flag;
                    if idx_flag<=size(part_data,1)
                        time_flag=part_data.actualtime(idx_flag);
                    else
                        time_flag=part_data.actualtime(size(part_data,1));
                    end;
                    if old_time_flag+2<time_flag && part_data.drink(m)==1
                        part_data.episode(m)=1;
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
        
moodtime=24;
for i = 1: size(date,1);
    mood_data=cleaned(strcmp(cleaned.StartTS,date{i}),:);
    
    %mark first episode
    for j=1:size(mood_data,1)
        if mood_data.episode(j)==1  
            mood_data.mood(j)=1;
            break;
        end;
    end;
    
    %deal with last day
    for l=1:size(mood_data,1)
        if mood_data.actualtime(l)< moodtime+2-24 && moodtime~=24
            mood_data.mood(l)=1;
            if mood_data.drink(l)==1
                moodtime=24+mood_data.actualtime(l);
            end;
        end;
    end;
    
    if mood_data.actualtime(j)>mood_data.time(j)
        time_flag=mood_data.time(j);
        time_flag=mood_data.actualtime(j)-24;
    else
        time_flag=mood_data.actualtime(j);
    end;
    
    idx_flag=j;
    if idx_flag<size(mood_data,1)
    while idx_flag<=size(mood_data,1)
        time=time_flag+2;
        tmp_upper=abs(time-mood_data.actualtime);
        idx_lower=idx_flag;
        [idx_upper idx_upper]=min(tmp_upper);

        
        if time<=mood_data.actualtime(size(mood_data,1))
            if mood_data.actualtime(idx_upper)<=time
                if (idx_lower+1)<=idx_upper
                    for m=idx_lower+1:idx_upper
                        if mood_data.drink(m)==1
                            idx_flag=m;
                            time_flag=mood_data.actualtime(idx_flag);
                            break;
                        end;
                    end;
                    mood_data.mood(idx_lower+1:m)=1;
                else
                    m=idx_lower+1;
                    idx_flag=m;
                    if idx_flag<=size(mood_data,1)
                        time_flag=mood_data.actualtime(idx_flag);
                    else
                        time_flag=mood_data.actualtime(size(mood_data,1));
                    end;
                end;
                
                
                
                %%next round
                if idx_upper<=m && mood_data.drink(m)==0
                    for t=idx_upper+1:size(mood_data,1)
                        if mood_data.episode(t)==1
                            mood_data.mood(t)=1;
                            break;
                        end;
                    end;
                    if t~=size(mood_data,1)
                        time_flag=mood_data.actualtime(t);
                        idx_flag=t;
                    else
                        time_flag=mood_data.actualtime(t);
                        idx_flag=t+1;
                    end;
                end;
            else
                if (idx_lower+1)<=(idx_upper-1)
                    for m=idx_lower+1:idx_upper-1
                        if mood_data.drink(m)==1
                            idx_flag=m;
                            time_flag=mood_data.actualtime(idx_flag);
                            %mood_data.mood(idx_lower+1:m)=1;
                            break;
                        end;
                    end;
                    mood_data.mood(idx_lower+1:m)=1;
                else
                    m=idx_lower+1;
                    idx_flag=m;
                    if idx_flag<=size(mood_data,1)
                        time_flag=mood_data.actualtime(idx_flag);
                    else
                        time_flag=mood_data.actualtime(size(mood_data,1));
                    end;
                end;
                %next round
                if ((idx_upper-1)<=m && mood_data.drink(m)==0) || mood_data.episode(m)==1
                    for t=idx_upper:size(mood_data,1)
                        if mood_data.episode(t)==1
                            mood_data.mood(t)=1;
                            break;
                        end;
                    end;
                    if t~=size(mood_data,1)
                        time_flag=mood_data.actualtime(t);
                        idx_flag=t;
                    else
                        time_flag=mood_data.actualtime(t);
                        idx_flag=t+1;
                    end;  
                end;
            end;
        else
            mood_data.mood(idx_lower:size(mood_data,1))=1;
            t=size(mood_data,1);
            time_flag=mood_data.actualtime(t);
            idx_flag=t+1;             
        end;
    end;
    moodtime=24;
    smalldata=mood_data.actualtime(mood_data.drink==1);
    if ~isempty(smalldata)
        moodtime=smalldata(end);
    end;    
    end;
    cleaned.mood(strcmp(cleaned.StartTS,date{i}))=mood_data.mood;
    %cleaned.mood(strcmp(cleaned.StartTS,date{i}))=part_data.mood;
end;

          
    

%for i=1:size(cleaned,1)
%    if i<=size(cleaned,1)-1
 %       if cleaned.drink(i)==1 && cleaned.drink(i+1)==1
  %              if abs(cleaned.drinktime(i+1)-cleaned.drinktime(i))<=2
   %                  cleaned.drink(i)=1;
    %                 cleaned.drink(i+1)=1;
     %           else 
      %              cleaned.drink(i)=1;
       %             cleaned.drink(i+1)=0;
        %        end;
%        end;
 %       if nominal(cleaned.StartTS(i))==nominal(cleaned.StartTS(i+1))
 %           if cleaned.drink(i)==0 && cleaned.drink(i+1)==1 
  %              if abs(cleaned.drinktime(i+1)-cleaned.drinktime(i))<=2
   %                  cleaned.drink(i)=0;
    %                 cleaned.drink(i+1)=0;
     %           else
      %              cleaned.drink(i)=0;
       %             cleaned.drink(i+1)=1;
        %        end;
         %   end;
%        end;
 %   end;
%end;

%%match to box data
%%%extract date information based on data name
%file='1001 pre-cleaned 10-03-14_clean';
%date=file(18:25);
%file='2/9/2015';
formatout= 'mm/dd/yyyy';
%date_box=datestr(datenum(date,'mm-dd-yy',2000),formatout);
cleaned.date=cellstr(datestr(cleaned.StartTS,formatout));
file=cellstr(datestr(file,formatout));

%%%select right time data
if sum(strcmp(cleaned.date,file))~=0
    cleaned(~strcmp(cleaned.date,file),:)=[];
else 
    cleaned=[];
end;

%%%return selected data
return_data=cleaned;

end

