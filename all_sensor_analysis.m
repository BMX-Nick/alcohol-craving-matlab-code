function result = all_sensor_analysis( patient )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
patient='1005';
%dataset=Preclean020915;
%day='1005 Feb 09 15';
load 1005_Test_Data
%%focus on drink
data020615=single_sensor_analysis(Preclean020615,patient,'1005 Feb 06 15');
data020815=single_sensor_analysis(Preclean020815,patient,'1005 Feb 08 15');
data020915=single_sensor_analysis(Preclean020915,patient,'1005 Feb 09 15');
data040215=single_sensor_analysis(Preclean040215,patient,'1005 Apr 02 15');
data040415=single_sensor_analysis(Preclean040415,patient,'1005 Apr 04 15');
data121714=single_sensor_analysis(Preclean121714,patient,'1005 Dec 17 14');
%preclean_feb=[Preclean020315;Preclean020415;Preclean020515;Preclean020615;Preclean020715;Preclean020815;Preclean020915];
%preclean_apr=[Preclean033115;Preclean040115;Preclean040215;Preclean040415;Preclean040515;Preclean040615];
%preclean_dec=[Preclean121114;Preclean121214;Preclean121314;Preclean121414;Preclean121514;Preclean121614;Preclean121714;Preclean121814];


for i=1:4
    drink_feb=[data020615.seperate{i};data020815.seperate{i};data020915.seperate{i}];
    drink_apr=[data040215.seperate{i};data040415.seperate{i}];%no0403
    drink_dec=[data121714.seperate{i}];

%preclean=[preclean_feb;preclean_apr;preclean_dec];
    drink=[drink_feb;drink_apr;drink_dec];
    drink=drink(:,2:3);
    drink=array2table(drink);
    drink.Properties.VariableNames(1:2)={'index','minute'};
%%%%all nan to 0
%preclean.HR(isnan(preclean.HR))=0;
%preclean.BR(isnan(preclean.BR))=0;
%preclean.activity(isnan(preclean.activity))=0;
%preclean.Skin_Temperature__IR_Thermometer(isnan(preclean.Skin_Temperature__IR_Thermometer))=0;

%drink
%drink.HR(isnan(drink.HR))=0;
%drink.BR(isnan(drink.BR))=0;
%drink.activity(isnan(drink.activity))=0;
%drink.Skin_Temperature__IR_Thermometer(isnan(drink.Skin_Temperature__IR_Thermometer))=0;




%tranfer time
%t=hour(preclean.time)+minute(preclean.time)/60;
%preclean.hour=t;

%transfer drink time
hour=floor(drink.minute);
minute=floor((drink.minute-hour)*60);

time=hour+minute/60;
drink.minute=time;


%delete all 0
%preclean(preclean.HR==0,:)=[];
%preclean(preclean.BR==0,:)=[];
%preclean(preclean.activity==0,:)=[];
%preclean(preclean.Skin_Temperature__IR_Thermometer==0,:)=[];


%delete all 0 in drink
%drink(drink.HR==0,:)=[];
%drink(drink.BR==0,:)=[];
%drink(drink.activity==0,:)=[];
%drink(drink.Skin_Temperature__IR_Thermometer==0,:)=[];

%group stat
%group=grpstats(preclean,'hour','mean','DataVars',{'HR','BR','activity','Skin_Temperature__IR_Thermometer'});

    group_drink{i}=grpstats(drink,'minute','mean','DataVars',{'index'});

%variable name
%group.Properties.VariableNames(3:6)={'hr','br','activity','skin_temperature'};
    group_drink{i}.Properties.VariableNames([1,3])={'minute','index'};
end;

%scale

for j=1:size(group_drink,2)
    tmp{j}=[];
end;

for j=1:size(group_drink,2)
    for i=1:(size(group_drink{j}.minute,1)-1)
        if group_drink{j}.minute(i+1)-group_drink{j}.minute(i)>0.5
            tmp{j}=[tmp{j};i];
        end;
    end;
end;


%calculate interval
for j=1:size(group_drink,2)
    if length(tmp{j})~=0
        for i=1:length(tmp{j})
            interval(j,i)=group_drink{j}.minute(tmp{j}(i)+1)-group_drink{j}.minute(tmp{j}(i));
            midpoint(j,i)=(group_drink{j}.minute(tmp{j}(i)+1)+group_drink{j}.minute(tmp{j}(i)))/2;
        end;
    end;
end;

        

figure
labelname={'heart rate','breath rate','activity','skin temperature'};
for i=1:4
    subplot(2,2,i)
    switch length(tmp{i})
        case 0
            smooth2(group_drink{i}.minute, group_drink{i}.index,0.5,'1005 mean value',labelname{i});
        case 1
            smooth2(group_drink{i}.minute, group_drink{i}.index,0.5,'1005 mean value',labelname{i});
            hold on
            bar(midpoint(i,1),max(group_drink{i}.index),interval(i,1),'w','EdgeColor','w');
            hold off
        case 2
            smooth2(group_drink{1}.minute, group_drink{1}.index,0.5,'1005 mean value',labelname{i});
            hold on
            bar(midpoint(i,1),max(group_drink{i}.index),interval(i,1),'w','EdgeColor','w');
            hold on
            bar(midpoint(i,2),max(group_drink{i}.index),interval(i,2),'w','EdgeColor','w');       
            hold off
    end;
end;

%smooth plot
[f1,gof1,out1]= fit(group_drink{1}.minute, group_drink{1}.index,  'smoothingspline', 'SmoothingParam', 0.5);
y{1}=group_drink{1}.index-out1.residuals;%calculate fitted value
[f2,gof2,out2]= fit(group_drink{2}.minute, group_drink{2}.index,  'smoothingspline', 'SmoothingParam', 0.5);
y{2}=group_drink{2}.index-out2.residuals;%calculate fitted value
[f3,gof3,out3]= fit(group_drink{3}.minute, group_drink{3}.index,  'smoothingspline', 'SmoothingParam', 0.5);
y{3}=group_drink{3}.index-out3.residuals;%calculate fitted value
[f4,gof4,out4]= fit(group_drink{4}.minute, group_drink{4}.index,  'smoothingspline', 'SmoothingParam', 0.5);
y{4}=group_drink{4}.index-out4.residuals;%calculate fitted value


%'HR','BR','activity','Skin_Temperature__IR_Thermometer'
for i=1:4
    z{i}=(y{i}-mean(y{i}))/sqrt(var(y{i}));
end;

%get mood data
drink_mood=day_mood_noplot(patient);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%drink sensor plot with mood
%make plot
%hr
for i=1:4
    switch length(tmp{i})
        case 0
            x{i}=group_drink{i}.minute;
            z{i}=z{i};
        case 1
            x{i}=[group_drink{i}.minute(1:tmp{i});NaN;group_drink{i}.minute(tmp{i}+1:end)];
            z{i}=[z{i}(1:tmp{i});NaN;z{i}(tmp{i}+1:end)];
        case 2
            x{i}=[group_drink{i}.minute(1:tmp{i}(1));NaN;group_drink{i}.minute(tmp{i}(1)+1:tmp{i}(2));NaN;group_drink{i}.minute(tmp{i}(2)+1:end)];
            z{i}=[z{i}(1:tmp{i}(1));NaN;z{i}(tmp{i}(1)+1:tmp{i}(2));NaN;z{i}(tmp{i}(2)+1:end)];            
    end;
end;
%%%%%%%%%%%%%%%%%%mood

figure
    [ax_drink1,b_drink,p_drink1]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x{1},z{1},'bar','plot');
    %legend('Positive','Negative','Fear','Hostility','Sadness','Heart Rate');
    hold on
    [ax_drink2,b_drink,p_drink2]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x{2},z{2},'bar','plot');
    %legend('Positive','Negative','Fear','Hostility','Sadness','Breath Rate');
    hold on
    [ax_drink3,b_drink,p_drink3]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x{3},z{3},'bar','plot');
    %legend('Positive','Negative','Fear','Hostility','Sadness','Activity');
    hold on
    [ax_drink4,b_drink,p_drink4]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x{4},z{4},'bar','plot');
    hold off
    
    %b_drink.Color='b';
    ax_drink1(1).XLim=[-1 25];
    ax_drink1(2).XLim=[-1 25];
    ax_drink1(1).YLim=[0 5];
    ax_drink1(2).YLim=[-3 3];
    ax_drink1(1).XTick=0:2:24;
    ax_drink1(2).XTick=0:2:24;
    ax_drink1(1).YTick=0:2:5;
    ax_drink1(2).YTick=-3:1:3;

    ax_drink2(1).XLim=[-1 25];
    ax_drink2(2).XLim=[-1 25];
    ax_drink2(1).YLim=[0 5];
    ax_drink2(2).YLim=[-3 3];
    ax_drink2(1).XTick=0:2:24;
    ax_drink2(2).XTick=0:2:24;
    ax_drink2(1).YTick=0:2:5;
    ax_drink2(2).YTick=-3:1:3;
    
    ax_drink3(1).XLim=[-1 25];
    ax_drink3(2).XLim=[-1 25];
    ax_drink3(1).YLim=[0 5];
    ax_drink3(2).YLim=[-3 3];
    ax_drink3(1).XTick=0:2:24;
    ax_drink3(2).XTick=0:2:24;
    ax_drink3(1).YTick=0:2:5;
    ax_drink3(2).YTick=-3:1:3;
    
    ax_drink4(1).XLim=[-1 25];
    ax_drink4(2).XLim=[-1 25];
    ax_drink4(1).YLim=[0 5];
    ax_drink4(2).YLim=[-3 3];
    ax_drink4(1).XTick=0:2:24;
    ax_drink4(2).XTick=0:2:24;
    ax_drink4(1).YTick=0:2:5;
    ax_drink4(2).YTick=-3:1:3;   
    
    p_drink1.Color='red';
    p_drink2.Color='blue';
    p_drink3.Color='black';
    p_drink4.Color='green';
    legend([b_drink,p_drink1,p_drink2,p_drink3,p_drink4],'Positive','Negative','Fear','Hostility','Sadness','Heart Rate','Breath Rate','Activity','Skin');

    xlabel('Time');
    ylabel(ax_drink1(2),'Scale Value');
    ylabel(ax_drink1(1),'Mean of Mood');  
    title(patient); 
    


%%%%%%%%%%%%%%%%%%%%%%episode
figure
    [ax_drink1,b_drink,p_drink1]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x{1},z{1},'bar','plot');
    %legend('Positive','Negative','Fear','Hostility','Sadness','Heart Rate');
    hold on
    [ax_drink2,b_drink,p_drink2]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x{2},z{2},'bar','plot');
    %legend('Positive','Negative','Fear','Hostility','Sadness','Breath Rate');
    hold on
    [ax_drink3,b_drink,p_drink3]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x{3},z{3},'bar','plot');
    %legend('Positive','Negative','Fear','Hostility','Sadness','Activity');
    hold on
    [ax_drink4,b_drink,p_drink4]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x{4},z{4},'bar','plot');
    hold off
    
    %b_drink.Color='b';
    ax_drink1(1).XLim=[-1 25];
    ax_drink1(2).XLim=[-1 25];
    ax_drink1(1).YLim=[0 5];
    ax_drink1(2).YLim=[-3 3];
    ax_drink1(1).XTick=0:2:24;
    ax_drink1(2).XTick=0:2:24;
    ax_drink1(1).YTick=0:2:5;
    ax_drink1(2).YTick=-3:1:3;

    ax_drink2(1).XLim=[-1 25];
    ax_drink2(2).XLim=[-1 25];
    ax_drink2(1).YLim=[0 5];
    ax_drink2(2).YLim=[-3 3];
    ax_drink2(1).XTick=0:2:24;
    ax_drink2(2).XTick=0:2:24;
    ax_drink2(1).YTick=0:2:5;
    ax_drink2(2).YTick=-3:1:3;
    
    ax_drink3(1).XLim=[-1 25];
    ax_drink3(2).XLim=[-1 25];
    ax_drink3(1).YLim=[0 5];
    ax_drink3(2).YLim=[-3 3];
    ax_drink3(1).XTick=0:2:24;
    ax_drink3(2).XTick=0:2:24;
    ax_drink3(1).YTick=0:2:5;
    ax_drink3(2).YTick=-3:1:3;
    
    ax_drink4(1).XLim=[-1 25];
    ax_drink4(2).XLim=[-1 25];
    ax_drink4(1).YLim=[0 5];
    ax_drink4(2).YLim=[-3 3];
    ax_drink4(1).XTick=0:2:24;
    ax_drink4(2).XTick=0:2:24;
    ax_drink4(1).YTick=0:2:5;
    ax_drink4(2).YTick=-3:1:3;   
    
    p_drink1.Color='red';
    p_drink2.Color='blue';
    p_drink3.Color='black';
    p_drink4.Color='green';
    legend([b_drink,p_drink1,p_drink2,p_drink3,p_drink4],'Number of Drink','Number of Drink times','Number of Drink episode','Heart Rate','Breath Rate','Activity','Skin');

    xlabel('Time');
    ylabel(ax_drink1(2),'Scale Value');
    ylabel(ax_drink1(1),'Mean of Drink');
    str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
    title([patient, str]); 

%br
%x=group_drink.hour;
%y=group_drink.br;

%marked=0;
%for i=1:size(group_drink,1)
%    if x(i+1)-x(i)>0.5
%        marked=i;
%        break;
%    end;
%end;


%figure
%subplot(2,1,2)
%if marked==0
%    [ax_drink,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x,y,'bar','plot');
%    legend('Positive','Negative','Fear','Hostility','Sadness','Breath Rate');
    %b_drink.Color='b';
%    ax_drink(1).XLim=[-1 25];
%    ax_drink(2).XLim=[-1 25];
%    ax_drink(1).YLim=[0 5];
%    ax_drink(2).YLim=[0 60];
%    ax_drink(1).XTick=0:2:24;
%    ax_drink(2).XTick=0:2:24;
%    ax_drink(1).YTick=0:2:5;
%    ax_drink(2).YTick=0:20:60;


%    xlabel('Time');
%    ylabel(ax_drink(2),'Breath Rate');
%    ylabel(ax_drink(1),'Mean of Mood');
%    str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%    title([patient,str]); 
%else
%    [ax_drink,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x(1:marked),y(1:marked),'bar','plot');
%    legend('Positive','Negative','Fear','Hostility','Sadness','Breath Rate');
%    hold on;
%    [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x(marked+1:end),y(marked+1:end),'bar','plot');
%    hold off;
%    
%    ax_drink(1).XLim=[-1 25];
%    ax_drink(2).XLim=[-1 25];
%    ax_drink(1).YLim=[0 5];
%    ax_drink(2).YLim=[0 60];
%    ax_drink(1).XTick=0:2:24;
%    ax_drink(2).XTick=0:2:24;
%    ax_drink(1).YTick=0:2:5;
%    ax_drink(2).YTick=0:20:60;
    
%    ax_drink1(1).XLim=[-1 25];
%    ax_drink1(2).XLim=[-1 25];
%    ax_drink1(2).YLim=[0 60];
%    ax_drink1(1).XTick=0:2:24;
%    ax_drink1(2).XTick=0:2:24;


%    xlabel('Time');
%    ylabel(ax_drink(2),'Breath Rate');
%    ylabel(ax_drink(1),'Mean of Mood');
%    str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%    title([patient,str]); 
%end;


%activity
% x=group_drink.hour;
% y=group_drink.activity;
% 
% marked=0;
% for i=1:size(group_drink,1)
%     if x(i+1)-x(i)>0.5
%         marked=i;
%         break;
%     end;
% end;
% 
% figure
% %subplot(2,1,2)
% if marked==0
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x,y,'bar','plot');
%     legend('Positive','Negative','Fear','Hostility','Sadness','Activity');
%     %b_drink.Color='b';
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[800 1100];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=800:100:1100;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Activity');
%     ylabel(ax_drink(1),'Mean of Mood');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% else
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x(1:marked),y(1:marked),'bar','plot');
%     legend('Positive','Negative','Fear','Hostility','Sadness','Activity');
%     hold on;
%     [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x(marked+1:end),y(marked+1:end),'bar','plot');
%     hold off;
%     
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[800 1100];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=800:100:1100;
%     
%     ax_drink1(1).XLim=[-1 25];
%     ax_drink1(2).XLim=[-1 25];
%     ax_drink1(2).YLim=[800 1100];
%     ax_drink1(1).XTick=0:2:24;
%     ax_drink1(2).XTick=0:2:24;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Activity');
%     ylabel(ax_drink(1),'Mean of Mood');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% end;


%skin
% x=group_drink.hour;
% y=group_drink.skin_temperature;
% 
% marked=0;
% for i=1:size(group_drink,1)
%     if x(i+1)-x(i)>0.5
%         marked=i;
%         break;
%     end;
% end;
% 
% figure
% %subplot(2,1,2)
% if marked==0
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x,y,'bar','plot');
%     legend('Positive','Negative','Fear','Hostility','Sadness','Skin Temperature');
%     %b_drink.Color='b';
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[30 40];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=30:5:40;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Skin Temperature');
%     ylabel(ax_drink(1),'Mean of Mood');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% else
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x(1:marked),y(1:marked),'bar','plot');
%     legend('Positive','Negative','Fear','Hostility','Sadness','Skin Temperature');
%     hold on;
%     [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.moodplot(:,1),drink_mood.moodplot(:,3:7),x(marked+1:end),y(marked+1:end),'bar','plot');
%     hold off;
%     
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[30 40];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=30:5:40;
%     
%     ax_drink1(1).XLim=[-1 25];
%     ax_drink1(2).XLim=[-1 25];
%     ax_drink1(2).YLim=[30 40];
%     ax_drink1(1).XTick=0:2:24;
%     ax_drink1(2).XTick=0:2:24;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Skin Temperature');
%     ylabel(ax_drink(1),'Mean of Mood');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%drink sensor plot with episode
%make plot
%hr
% x=group_drink.hour;
% y=group_drink.hr;
% 
% marked=0;
% for i=1:size(group_drink,1)
%     if x(i+1)-x(i)>0.5
%         marked=i;
%         break;
%     end;
% end;
% 
% figure
% %subplot(2,1,2)
% if marked==0
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x,y,'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Heart Rate');
%     %b_drink.Color='b';
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[0 200];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=0:20:200;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Heart Rate');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% else
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(1:marked),y(1:marked),'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Heart Rate');
%     hold on;
%     [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(marked+1:end),y(marked+1:end),'bar','plot');
%     hold off;
%     
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[0 200];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=0:20:200;
%     
%     ax_drink1(1).XLim=[-1 25];
%     ax_drink1(2).XLim=[-1 25];
%     ax_drink1(2).YLim=[0 200];
%     ax_drink1(1).XTick=0:2:24;
%     ax_drink1(2).XTick=0:2:24;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Heart Rate');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% end;
%  
% %br
% x=group_drink.hour;
% y=group_drink.br;
% 
% marked=0;
% for i=1:size(group_drink,1)
%     if x(i+1)-x(i)>0.5
%         marked=i;
%         break;
%     end;
% end;
% 
% figure
% %subplot(2,1,2)
% if marked==0
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x,y,'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Breath Rate');
%     %b_drink.Color='b';
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[0 60];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=0:20:60;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Breath Rate');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% else
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(1:marked),y(1:marked),'bar','plot');
%      legend('Number of Drink','Number of Drink times','Number of Drink episode','Breath Rate');
%     hold on;
%     [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(marked+1:end),y(marked+1:end),'bar','plot');
%     hold off;
%     
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[0 60];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=0:20:60;
%     
%     ax_drink1(1).XLim=[-1 25];
%     ax_drink1(2).XLim=[-1 25];
%     ax_drink1(2).YLim=[0 60];
%     ax_drink1(1).XTick=0:2:24;
%     ax_drink1(2).XTick=0:2:24;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Breath Rate');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% end;
% 
% 
% %activity
% x=group_drink.hour;
% y=group_drink.activity;
% 
% marked=0;
% for i=1:size(group_drink,1)
%     if x(i+1)-x(i)>0.5
%         marked=i;
%         break;
%     end;
% end;
% 
% figure
% %subplot(2,1,2)
% if marked==0
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x,y,'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Activity');
%     %b_drink.Color='b';
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[800 1100];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=800:100:1100;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Activity');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% else
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(1:marked),y(1:marked),'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Activity');
%     hold on;
%     [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(marked+1:end),y(marked+1:end),'bar','plot');
%     hold off;
%     
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[800 1100];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=800:100:1100;
%     
%     ax_drink1(1).XLim=[-1 25];
%     ax_drink1(2).XLim=[-1 25];
%     ax_drink1(2).YLim=[800 1100];
%     ax_drink1(1).XTick=0:2:24;
%     ax_drink1(2).XTick=0:2:24;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Activity');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% end;
% 
% %skin
% x=group_drink.hour;
% y=group_drink.skin_temperature;
% 
% marked=0;
% for i=1:size(group_drink,1)
%     if x(i+1)-x(i)>0.5
%         marked=i;
%         break;
%     end;
% end;
% 
% figure
% %subplot(2,1,2)
% if marked==0
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x,y,'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Skin Temperature');
%     %b_drink.Color='b';
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[30 40];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=30:5:40;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Skin Temperature');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% else
%     [ax_drink,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(1:marked),y(1:marked),'bar','plot');
%     legend('Number of Drink','Number of Drink times','Number of Drink episode','Skin Temperature');
%     hold on;
%     [ax_drink1,b_drink,p_drink]=plotyy(drink_mood.drinkplot(:,4),drink_mood.drinkplot(:,1:3),x(marked+1:end),y(marked+1:end),'bar','plot');
%     hold off;
%     
%     ax_drink(1).XLim=[-1 25];
%     ax_drink(2).XLim=[-1 25];
%     ax_drink(1).YLim=[0 5];
%     ax_drink(2).YLim=[30 40];
%     ax_drink(1).XTick=0:2:24;
%     ax_drink(2).XTick=0:2:24;
%     ax_drink(1).YTick=0:2:5;
%     ax_drink(2).YTick=30:5:40;
%     
%     ax_drink1(1).XLim=[-1 25];
%     ax_drink1(2).XLim=[-1 25];
%     ax_drink1(2).YLim=[30 40];
%     ax_drink1(1).XTick=0:2:24;
%     ax_drink1(2).XTick=0:2:24;
% 
% 
%     xlabel('Time');
%     ylabel(ax_drink(2),'Skin Temperature');
%     ylabel(ax_drink(1),'Mean of Drink');
%     str = sprintf(' drink day plot, %d day drinks',drink_mood.drinkdays);  
%     title([patient,str]); 
% end;







end

