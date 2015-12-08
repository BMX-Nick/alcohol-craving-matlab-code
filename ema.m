function result = ema( data,period)
%calcuate EMA 
%every point treat as one day in stock

%sample

%data=[22.27;22.19;22.08;22.17;22.18;22.13;22.23;22.43;22.24;22.29;22.15;22.39;22.38;22.61;23.36;24.05];
%period=10;
%calculate initial period point
ema(1,:)=mean(data(1:period,1));

multiplier=2/(period+1);

for i=1:(size(data,1)-period)
    ema(i+1,:)=(data(i+period)-ema(i,:))*multiplier+ema(i,:);
end;

result=ema;

end

