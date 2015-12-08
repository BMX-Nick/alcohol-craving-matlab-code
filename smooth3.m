function  smooth3(x,y ,m ,patient,label)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this function is made for plotting graphic
%original vs smoothing plot;
%
%written by Peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
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


%%plot smoothing
    %xlim([floor(min(x)),ceil(max(x))]);
    %ylim([floor(min(y)),ceil(max(y))]);
    a=1;
    scatter(x,y,a);
%%plot smoothing
    hold on
    plot(f,'k');
    str = sprintf('smoothing Rsquare %f',gof.rsquare);    
    legend('raw',str);
    xlim([0,24]);
    ylim([min(y),max(y)]);
    xlabel('Time');
    ylabel(label);
    title(patient);

end



