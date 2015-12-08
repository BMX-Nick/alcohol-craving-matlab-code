data1001=readtable('1001drink.csv');
%modify column name
data1001.Properties.VariableNames([13 14 15 16])={'id_drink','rs_drink','rs_numberofdrink','df_drink'};
%feature selection
data=data1001(:,{'ID','Type_1','StartTS','starttime','id_drink','rs_drink','df_drink'});

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
        case 3
           cleaned.drinktime(i)=cleaned.time(i)-30/60;
        case 4
           cleaned.drinktime(i)=cleaned.time(i)-45/60;
        case 5
           cleaned.drinktime(i)=cleaned.time(i)-1;
        case 6
           cleaned.drinktime(i)=cleaned.time(i)-1.5;
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

for i=1:size(cleaned,1)
    if i<=size(cleaned,1)-1
        if cleaned.drink(i)==1 && cleaned.drink(i+1)==1
                if abs(cleaned.drinktime(i+1)-cleaned.drinktime(i))<=0.6
                     cleaned.drink(i)=1;
                     cleaned.drink(i+1)=0;
                else 
                    cleaned.drink(i)=1;
                    cleaned.drink(i+1)=1;
                end;
        end;
        if nominal(cleaned.StartTS(i))==nominal(cleaned.StartTS(i+1))
            if cleaned.drink(i)==0 && cleaned.drink(i+1)==1 
                if abs(cleaned.drinktime(i+1)-cleaned.drinktime(i))<=0.6
                     cleaned.drink(i)=0;
                     cleaned.drink(i+1)=0;
                else
                    cleaned.drink(i)=0;
                    cleaned.drink(i+1)=1;
                end;
            end;
        end;
    end;
end;

%%match to box data
%%%extract date information based on data name
string='1001 pre-cleaned 10-03-14_clean';
date=string(18:25);

formatout= 'mm/dd/yyyy';
date_box=datestr(datenum(date,'mm-dd-yy',2000),formatout);

cleaned.date=cellstr(datestr(cleaned.StartTS,formatout));

cleaned(~strcmp(cleaned.date,date_box),:)=[];



