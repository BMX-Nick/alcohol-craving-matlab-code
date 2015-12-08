function data=cleandata(dataset,file)
%load in dataset
%file='1001 pre-cleaned 10-03-14_clean';
%testdata=readtable([file '.csv']);
%dataset=train_preclean;
%file='1005 pre-cleaned 4-04-15';
featureselect=dataset(:,{'Skin_Temperature__IR_Thermometer','Ambulation_Status','time','HR','BR','date'});

%%class ambulation into indicator variable

featureselect(strcmp(featureselect.Ambulation_Status,'Stationary'),7)=array2table(1);
featureselect(strcmp(featureselect.Ambulation_Status, 'MovingSlowly'),7)=array2table(2);
featureselect(strcmp(featureselect.Ambulation_Status, 'MovingFast'),7)=array2table(3);

featureselect=[featureselect(:,1),featureselect(:,7),featureselect(:,3:6)];
%add drink column
featureselect(:,7)=array2table(0);
%rename
featureselect.Properties.VariableNames([1 2 7])={'skin','ambulation','drinktime'};



%feature selection

%%convert format for time
t=hour(featureselect.time)+minute(featureselect.time)/60+second(featureselect.time)/3600;
featureselect.time=t;
if iscellstr(featureselect.BR)
    featureselect.BR=str2double(featureselect.BR);
end;
if iscellstr(featureselect.HR)
    featureselect.HR=str2double(featureselect.HR);
end;

%%%convert date format

formatout= '%s-%s-%s';%dd/mm/yy
for i = 1 : size(featureselect,1) 
    if ~strcmp(featureselect.date(i),'')
        if ~strcmp(featureselect.date{i}(end-2),'-')
            year=featureselect.date{i}(end-1:end);
            month=featureselect.date{i}(end-4:end-2);
            day=featureselect.date{i}(1:end-5);
            date=sprintf(formatout,day,month,year);
            format= 'mm/dd/yyyy';
            date_box=datestr(datenum(date,'dd-mmm-yy',2000),format);
            featureselect.date{i}=date_box;
        else
            year=featureselect.date{i}(end-1:end);
            month=featureselect.date{i}(end-5:end-3);
            day=featureselect.date{i}(1:end-7);
            date=sprintf(formatout,day,month,year);
            format= 'mm/dd/yyyy';
            date_box=datestr(datenum(date,'dd-mmm-yy',2000),format);
            featureselect.date{i}=date_box; 
        end;
    end;
end;

date=unique(featureselect.date);
date=date(~strcmp(date,''));
%%get data from server
for i=1:size(date,1)
    getdata{i}=search_drink(file(1:4),date{i});
    if ~isempty(getdata{i})
        drinktime{i}=getdata{i}.drinktime(getdata{i}.episode==1);
    
%%combine data together
        for j=1:size(drinktime{i},1)
            subdata=featureselect(strcmp(featureselect.date,date{i}),:);
            tmp{i}=abs(subdata.time-drinktime{i}(j));
            [idx idx]=min(tmp{i});
            subdata.drinktime(idx)=1;
            subdata.drinktime(1)=0;
            subdata.drinktime(end)=0;
            featureselect(strcmp(featureselect.date,date{i}),:)=subdata;
        end;
    end;
end;

%remove cell of date
featureselect.date=[];    


featureselect=table2array(featureselect);



data=featureselect;
%1.skin 2.ambulation 3.time 4. heart rate 5.breath rate 
%6.drink or not
end

