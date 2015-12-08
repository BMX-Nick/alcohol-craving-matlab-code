function  smooth(data,m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this function is made for plotting graphic
%original vs smoothing plot;
%
%written by Peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%data=traindata;
%m=0.5;
%open figure
    figure
%1 is time, 5 is breate rate
    x=data(:,1);
    y=data(:,5);
    
%%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
%for m=0.9:0.000001:1
    [f,gof,out]= fit(x, y,  'smoothingspline', 'SmoothingParam', m);
% if gor.rsquare>0.5
%end;


%%plot raw
    subplot(2,2,1)
    xlim([min(x),max(x)]);
    ylim([min(y),max(y)]);
    plot(x,y,'-m');
%%plot smoothing
    hold on
    plot(f,'k');
    str = sprintf('smoothing Rsquare %f',gof.rsquare);    
    %add drink episode plot
    if sum(data(:,end))>0 
        hold on
        plot(x,data(:,end)*max(y),'-b');
        legend('raw',str,'Drink');
    else 
        legend('raw',str);
    end;
    ylim([min(y),max(y)]);
    xlabel('Time');
    ylabel('Breath Rate');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%smooth plot hr 

%1 is time, 4 is heart rate
    x=data(:,1);
    y=data(:,4);
    
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
%for m=0.9:0.000001:1
    [f,gof,out]= fit(x, y,  'smoothingspline', 'SmoothingParam', m);
% if gor.rsquare>0.5
%end;


%%plot smoothing
    subplot(2,2,2)
    xlim([min(x),max(x)]);
    ylim([min(y),max(y)]);
    plot(x,y,'-m');
%%plot smoothing
    hold on
    plot(f,'k');
    str = sprintf('smoothing Rsquare %f',gof.rsquare);    
    %add drink episode plot
    if sum(data(:,end))>0 
        hold on
        plot(x,data(:,end)*max(y),'-b');
        legend('raw',str,'Drink');
    else 
        legend('raw',str);
    end;
    ylim([min(y),max(y)]);
    xlabel('Time');
    ylabel('Heart Rate');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%title('ricky0203 drink');

%%%smooth plot ambulation
 
%1 is time, 2 is ambulation
    x=data(:,1);
    y=data(:,2);
    
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;  
%for m=0.9:0.000001:1
    [f,gof,out]= fit(x, y,  'smoothingspline', 'SmoothingParam', m);
% if gor.rsquare>0.5
%end;


%%plot smoothing
    subplot(2,2,3)
    xlim([min(x),max(x)]);
    ylim([min(y),max(y)]);
    plot(x,y,'-m');
%%plot smoothing
    hold on
    plot(f,'k');
    str = sprintf('smoothing Rsquare %f',gof.rsquare);    
    %add drink episode plot
    if sum(data(:,end))>0 
        hold on
        plot(x,data(:,end)*max(y),'-b');
        legend('raw',str,'Drink');
    else 
        legend('raw',str);
    end;
    ylim([min(y),max(y)]);
    xlabel('Time');
    ylabel('Ambulation');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%smooth plot skin temperature
 
%1 is time, 3 is skin
    x=data(:,1);
    y=data(:,3);
    
    %%%sort by time
    for i=1:(size(x,1)-1)
        if x(i)-x(i+1)>23
            break;
        end;
    end;
    
    if i~=(size(x,1)-1)
        x((i+1):end)=x((i+1):end)+24;
    end;
%for m=0.9:0.000001:1
    [f,gof,out]= fit(x, y,  'smoothingspline', 'SmoothingParam', m);
% if gor.rsquare>0.5
%end;


%%plot smoothing
    subplot(2,2,4)
    xlim([min(x),max(x)]);
    ylim([min(y),max(y)]);
    plot(x,y,'-m');
%%plot smoothing
    hold on
    plot(f,'k');
    str = sprintf('smoothing Rsquare %f',gof.rsquare);    
    %add drink episode plot
    if sum(data(:,end))>0 
        hold on
        plot(x,data(:,end)*max(y),'-b');
        legend('raw',str,'Drink');
    else 
        legend('raw',str);
    end;
    ylim([min(y),max(y)]);
    xlabel('Time');
    ylabel('Skin Temperature');

end

