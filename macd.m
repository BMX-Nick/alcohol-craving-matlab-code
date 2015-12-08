function result =macd( ema_slow,ema_fast )
%calculate macd and then find peak

macd=ema_fast-ema_slow;

%find peak
[pks,locs,w,p]=findpeaks(macd,'MinPeakProminence',1);

result.macd=macd;
result.peak_value=pks;
result.peak=locs;
result.widths=w;
result.promin=p;
end

