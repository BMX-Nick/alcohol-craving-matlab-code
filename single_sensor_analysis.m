function result = single_sensor_analysis( dataset,patient,day )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%patient='1005';
%if strcmp(patient,'1005')
 %  load 1005_Test_Data;
%end;
%dataset=Preclean020615;
%day='1005 Feb 06 15';

dataset(strcmp(dataset.date,''),:)=[];




%make raw plot
%extract time value
t=hour(dataset.time)+minute(dataset.time)/60+second(dataset.time)/3600;
dataset.time=t;

%combine with survey data 
date=unique(dataset.date);
date=date(~strcmp(date,''));
dataset.drink(1)=0;
dataset.mood(1)=0;
%%get data from server
for i=1:size(date,1)
    getdata{i}=search_drink(patient,date{i});
    for n=1:size(getdata{i})
        if getdata{i}.drinktime(n)-getdata{i}.time(n)>22;
            getdata{i}.actualtime(n)=getdata{i}.actualtime(n)-24;
        end;
    end;
    if ~isempty(getdata{i})
        drinktime{i}=getdata{i}.actualtime(getdata{i}.episode==1);
        moodtime{i}=getdata{i}.actualtime(getdata{i}.mood==1);
        %%combine data together
        subdata=dataset(strcmp(dataset.date,date{i}),:);
        subdata.drinktime(1)=0;
        subdata.moodtime(1)=0;
        for j=1:size(drinktime{i},1) 
            tmp{i}=abs(subdata.time-drinktime{i}(j));
            [idx idx]=min(tmp{i});
            if min(tmp{i})<0.5
                subdata.drinktime(idx)=1;
                dataset.drink(strcmp(dataset.date,date{i}),:)=subdata.drinktime;
            end;
        end;
        
        for m=1:size(moodtime{i},1)
            tmp{i}=abs(subdata.time-moodtime{i}(m));
            [idx idx]=min(tmp{i});
            if min(tmp{i})<0.5
                subdata.moodtime(idx)=1;
                dataset.mood(strcmp(dataset.date,date{i}),:)=subdata.moodtime;
            end;
        end;                
    end;
end;

dataset.drinkmood(1)=0;
for n=1:length(dataset.mood)
    if dataset.mood(n)==1
        time=dataset.time(n)+2;
        if time <=24
            tmp=abs(dataset.time-time);
            [idx idx]=min(tmp);
            dataset.drinkmood(n:idx)=1;
        else
            time=time-24;
            tmp=abs(dataset.time-time);
            if min(tmp)<0.5
                [idx idx]=min(tmp);
                dataset.drinkmood(n:idx)=1;
            end;
        end;
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preclean=dataset;
%seperate plot
%overall plot
figure
subplot(2,2,1)
x=preclean.time;
y=preclean.HR;
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
    %scatter plot
    a=1;
scatter(x,y,a);
xlabel('Time');
ylabel('Heart Rate');
title(day);
%breath rate
subplot(2,2,2)
x=preclean.time;
y=preclean.BR;
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
    %scatter plot
    a=1;
scatter(x,y,a);
xlabel('Time');
ylabel('Breath Rate');
title(day);
%activity
subplot(2,2,3)
x=preclean.time;
y=preclean.activity;
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
    %scatter plot
    a=1;
scatter(x,y,a);
xlabel('Time');
ylabel('Activity');
title(day);
%skin temperature
subplot(2,2,4)
x=preclean.time;
y=preclean.Skin_Temperature__IR_Thermometer;
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
    %scatter plot
    a=1;
scatter(x,y,a);
xlabel('Time');
ylabel('Skin Temperature');
title(day);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%some clean
%%%%all nan to 0
preclean.HR(isnan(preclean.HR))=0;
preclean.BR(isnan(preclean.BR))=0;
preclean.activity(isnan(preclean.activity))=0;
preclean.Skin_Temperature__IR_Thermometer(isnan(preclean.Skin_Temperature__IR_Thermometer))=0;

%%%build index
for i=1:size(preclean,1)
    preclean.measurement(i)=i;
end;

%remove all 0
preclean(preclean.HR==0,:)=[];
preclean(preclean.BR==0,:)=[];
preclean(preclean.activity==0,:)=[];
preclean(preclean.Skin_Temperature__IR_Thermometer==0,:)=[];

%%%%fit loess
%variable list
var_list={'HR','BR','activity','Skin_Temperature__IR_Thermometer'};

for i=1:size(preclean,1)
    outlier(i)=0;
end;

for i=1:4
    x=preclean.measurement;
    y=zeros(size(preclean,1),1);
    name=['preclean.',var_list{i}];
    z=eval(name);
    
    
    [xData, yData, zData{i}] = prepareSurfaceData( x, y, z );

% Set up fittype and options.
    ft = fittype( 'loess' );
    opts = fitoptions( 'Method', 'LowessFit' );
    opts.Normalize = 'on';
    opts.Span = 0.01;

% Fit model to data.
    [fitresult, gof] = fit( [xData, yData], zData{i}, ft, opts );

% get fitted value;
    fitted{i}=feval(fitresult,[xData, yData]);

% residual
    residual{i}=abs(fitted{i}-zData{i});

    var_residual(i)=sqrt(var(residual{i}));

    z_resid=residual{i}/var_residual(i);

    %mark outlier
    zData{i}(:,2)=outlier;
    
%fix
    indication=2*var_residual(i)+mean(residual{i})<=residual{i};
    zData{i}(:,2)=indication;
    
    outlier_data{i}=zData{i}(zData{i}(:,2)==1,1);
    %zData{i}(zData{i}(:,2)==1,1)=0;

end;







% replace raw data by fixed data
    preclean.HR=zData{1}(:,1);
    preclean.BR=zData{2}(:,1);
    preclean.activity=zData{3}(:,1);
    preclean.Skin_Temperature__IR_Thermometer=zData{4}(:,1);

    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%outlier plot
figure
subplot(2,2,1)
x=[preclean.time,zData{1}(:,2)];
y=[preclean.HR,zData{1}(:,2)];
    %%%sort by time
    for i=1:(size(x(:,1),1)-1)
        if x(i,1)-x(i+1,1)>23
            break;
        end;
    end;
    
    if i~=(size(x(:,1),1)-1)
        x((i+1):end,1)=x((i+1):end,1)+24;
    end;
    %%get good one and bad one
x_good=x(x(:,2)==0,1);
x_bad=x(x(:,2)==1,1);
y_good=y(y(:,2)==0,1);
y_bad=y(y(:,2)==1,1);

    %scatter plot
    a=1;
    scatter(x_good,y_good,a);
    xlabel('Time');
    ylabel('Heart Rate');
    title(day);
    hold on;
    scatter(x_bad,y_bad,a+9,'r');
    hold on;
    plot(x(:,1),fitted{1},'k');
    legend('regular data','outlier','loess fit');
    hold off;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %outlier plot
    subplot(2,2,2)
x=[preclean.time,zData{2}(:,2)];
y=[preclean.BR,zData{2}(:,2)];
    %%%sort by time
    for i=1:(size(x(:,1),1)-1)
        if x(i,1)-x(i+1,1)>23
            break;
        end;
    end;
    
    if i~=(size(x(:,1),1)-1)
        x((i+1):end,1)=x((i+1):end,1)+24;
    end;
    %%get good one and bad one
x_good=x(x(:,2)==0,1);
x_bad=x(x(:,2)==1,1);
y_good=y(y(:,2)==0,1);
y_bad=y(y(:,2)==1,1);

    %scatter plot
    a=1;
    scatter(x_good,y_good,a);
    xlabel('Time');
    ylabel('Breath Rate');
    title(day);
    hold on;
    scatter(x_bad,y_bad,a+9,'r');
    hold on;
    plot(x(:,1),fitted{2},'k');
    legend('regular data','outlier','loess fit');
    hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %outlier plot
    subplot(2,2,3)
x=[preclean.time,zData{3}(:,2)];
y=[preclean.activity,zData{3}(:,2)];
    %%%sort by time
    for i=1:(size(x(:,1),1)-1)
        if x(i,1)-x(i+1,1)>23
            break;
        end;
    end;
    
    if i~=(size(x(:,1),1)-1)
        x((i+1):end,1)=x((i+1):end,1)+24;
    end;
    %%get good one and bad one
x_good=x(x(:,2)==0,1);
x_bad=x(x(:,2)==1,1);
y_good=y(y(:,2)==0,1);
y_bad=y(y(:,2)==1,1);

    %scatter plot
    a=1;
    scatter(x_good,y_good,a);
    xlabel('Time');
    ylabel('Activity');
    title(day);
    hold on;
    scatter(x_bad,y_bad,a+9,'r');
    hold on;
    plot(x(:,1),fitted{3},'k');
    legend('regular data','outlier','loess fit');
    hold off;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %outlier plot
    subplot(2,2,4)
x=[preclean.time,zData{4}(:,2)];
y=[preclean.Skin_Temperature__IR_Thermometer,zData{4}(:,2)];
    %%%sort by time
    for i=1:(size(x(:,1),1)-1)
        if x(i,1)-x(i+1,1)>23
            break;
        end;
    end;
    
    if i~=(size(x(:,1),1)-1)
        x((i+1):end,1)=x((i+1):end,1)+24;
    end;
    %%get good one and bad one
x_good=x(x(:,2)==0,1);
x_bad=x(x(:,2)==1,1);
y_good=y(y(:,2)==0,1);
y_bad=y(y(:,2)==1,1);

    %scatter plot
    a=1;
    scatter(x_good,y_good,a);
    xlabel('Time');
    ylabel('Skin Temperature');
    title(day);
    hold on;
    scatter(x_bad,y_bad,a+9,'r');
    hold on;
    plot(x(:,1),fitted{4},'k');
    legend('regular data','outlier','loess fit');
    hold off;
    
    
    
    
    
%remove all outlier and fit again to see trend
for i=1:4
    good_data{i}=[preclean.measurement(zData{i}(:,2)==0),zData{i}(zData{i}(:,2)==0,1),preclean.time(zData{i}(:,2)==0),preclean.drinkmood(zData{i}(:,2)==0)];
end;
figure
subplot(2,2,1)
smooth2(good_data{1}(:,3),good_data{1}(:,2),0.5,'1005 outlier removed','heart rate');
subplot(2,2,2)
smooth2(good_data{2}(:,3),good_data{2}(:,2),0.5,'1005 outlier removed','breath rate');
subplot(2,2,3)
smooth2(good_data{3}(:,3),good_data{3}(:,2),0.5,'1005 outlier removed','activity');
subplot(2,2,4)
smooth2(good_data{4}(:,3),good_data{4}(:,2),0.5,'1005 outlier removed','skin temperature');



%%%%%%%%%%%%%%%%%%%%%%%after fitting
%%fit outlier
for i=1:4
    yi=good_data{i}(:,2);
    xi=good_data{i}(:,1);
    new_x=1:size(dataset,1);
    fitlinear=interp1(xi,yi,new_x,'linear');
    sensor{i}=transpose(fitlinear);
end;
%%get new smoothed data
%hr,br,activity,skin
dataset.HR=round(sensor{1});
dataset.BR=round(sensor{2});
dataset.activity=sensor{3};
dataset.Skin_Temperature__IR_Thermometer=sensor{4};

%delete NaN

dataset(isnan(dataset.HR),:)=[];
dataset(isnan(dataset.BR),:)=[];
dataset(isnan(dataset.activity),:)=[];
dataset(isnan(dataset.Skin_Temperature__IR_Thermometer),:)=[];


%%make smooth plot
short_data=dataset(:,{'time','Skin_Temperature__IR_Thermometer','HR','BR','activity'});
short_data=table2array(short_data);

figure
subplot(2,2,1)
smooth2(short_data(:,1),short_data(:,3),0.5,'1005 after fitting','heart rate');
subplot(2,2,2)
smooth2(short_data(:,1),short_data(:,4),0.99,'1005 after fitting','breath rate');
subplot(2,2,3)
smooth2(short_data(:,1),short_data(:,5),0.999,'1005 after fitting','activity');
subplot(2,2,4)
smooth2(short_data(:,1),short_data(:,2),0.5,'1005 after fitting','skin temperature');

        

    
%return data
    result.whole=dataset;
    result.seperate=good_data;


end

