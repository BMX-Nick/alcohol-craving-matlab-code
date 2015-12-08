ema_fast=ema(traindata(:,4),120);
ema_slow=ema(traindata(:,4),240);
ema_fast(1:(length(ema_fast)-length(ema_slow)))=[];

macd=ema_fast-ema_slow;

%find peak
[pks,locs,w,p]=findpeaks(macd,'MinPeakProminence',1);

% x=traindata(:,1);
% for i=1:(size(x,1)-1)
%     if x(i)-x(i+1)>23
%         break;
%     end;
% end;
% if i~=(size(x,1)-1)
%     x((i+1):end)=x((i+1):end)+24;
% end;
% 
% gap=length(ema_fast)-length(ema_slow)+1;


% xlim([min(x(gap:end)),max(x(gap:end))]);

idx=find(traindata(:,end)==1);
idx1=idx-(size(traindata,1)-length(ema_fast));

x=idx1;
plot(x,1,'-b');
subplot(2,1,1)
plot(ema_fast)
hold on
plot(ema_slow)
hold off
xlabel('index')
ylabel('EMA')
legend('ema fast 5 min','ema slow 10 min');
title('EMA PLOT')

subplot(2,1,2)
findpeaks(macd,'MinPeakProminence',1);
xlabel('index');
ylabel('MACD')
title('MACD')
