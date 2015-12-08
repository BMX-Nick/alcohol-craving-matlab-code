drink1001=drink_summary('1001');
drink1003=drink_summary('1003');
drink1004=drink_summary('1004');
drink1005=drink_summary('1005');
drink1007=drink_summary('1007');
drink1008=drink_summary('1008');
drink1009=drink_summary('1009');
drink1010=drink_summary('1010');
drink1013=drink_summary('1013');
drink1014=drink_summary('1014');
drink1017=drink_summary('1017');
drink1019=drink_summary('1019');
drink1020=drink_summary('1020');
drink1021=drink_summary('1021');
drink1022=drink_summary('1022');
drink1024=drink_summary('1024');



patient='1007';
data=drink1007;
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
    a=mean(part_data(:,1));
    b=mean(part_data(:,2));
    c=mean(part_data(:,3));
    d=time(j);
    combine=[a,b,c,d];
    output=[output;combine];
end;

figure
subplot(2,1,1)
ax=gca;
ax.XLim=[-1 24];
ax.YLim=[0 5];
ax.XTick=0:2:24;
bar(output(:,4),output(:,1:3));
mood(patient);
%%axis handle

legend('mean number of drink','sum of drink times','sum of episode times');
xlabel('Time');
ylabel('Drink');
title(patient);


%%%add mood in
figure
subplot(2,1,1)
summary1001=mood('1001');
subplot(2,1,2)
summary1003=mood('1003');
figure
subplot(2,1,1)
summary1004=mood('1004');
subplot(2,1,2)
summary1005=mood('1005');
figure
subplot(2,1,1)
summary1007=mood('1007');
subplot(2,1,2)
summary1008=mood('1008');
figure
subplot(2,1,1)
summary1009=mood('1009');
subplot(2,1,2)
summary1010=mood('1010');
figure
subplot(2,1,1)
summary1013=mood('1013');
subplot(2,1,2)
summary1014=mood('1014');
figure
subplot(2,1,1)
summary1017=mood('1017');
subplot(2,1,2)
summary1019=mood('1019');
figure
subplot(2,1,1)
summary1020=mood('1020');
subplot(2,1,2)
summary1021=mood('1021');
figure
subplot(2,1,1)
summary1022=mood('1022');
subplot(2,1,2)
summary1024=mood('1024');
