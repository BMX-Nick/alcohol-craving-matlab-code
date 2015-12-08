function result = calculate_survey(  patient )
directory='C:\Users\pp\Desktop\new data\survey';
%patient='1001';
full_filename=fullfile(directory,patient);
data=readsurvey([full_filename '.csv']);


%extract useful information
select=data(:,[1:10,11:41,80,81,133,134,181,191,185:189]);
%time
[tmpdate tmptime]=strtok(select.StartTS,' ');
select.StartTS=tmpdate;
select.EndTS=tmptime;

%modify column name
select.Properties.VariableNames([10,42:52])={'starttime','id_drink','id_drinknum','rs_drink','rs_drinknum','df_drinknum','rs_drinktime','Positive','Negative','Fear','Hostility','Sadness'};

%calculate mean value
select(strcmp(select.Afraid,''),:)=[];
cal_data=select(:,11:41);

%change format
for i=1:size(cal_data,1)
    for j=1:size(cal_data,2)
        transfer_data(i,j)=str2num(cell2mat(table2array(cal_data(i,j))));
    end;
end;

%mean for each

for i=1:size(transfer_data,1)
    positive(i,1)=mean(transfer_data(i,21:30));
    negative(i,1)=mean(transfer_data(i,[1:20,31]));
    fear(i,1)=mean(transfer_data(i,[1,6,7,8,10,11]));
    hostility(i,1)=mean(transfer_data(i,[4,5,12:15]));
    sadness(i,1)=mean(transfer_data(i,16:20));
end;

        



%feature selection
data=select(:,{'ID','Type1','StartTS','starttime','id_drink','id_drinknum','rs_drink','rs_drinknum','rs_drinktime','df_drinknum','Positive','Negative','Fear','Hostility','Sadness'});

%replace
data.Positive=positive;
data.Negative=negative;
data.Fear=fear;
data.Hostility=hostility;
data.Sadness=sadness;

result=data;


end

