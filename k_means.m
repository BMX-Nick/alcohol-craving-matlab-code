function arracy = kmeans( train )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%        K-Means(Simple)
%%%        written by peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [idx,C]=kmeans(train(:,2:end-1),2);
    pred=idx-1;
    error=mean(abs(train(:,end)-pred)); 
    
%%count test information   
    drink_count=sum(train(:,end));
    benchmark=drink_count/size(train,1);

%%output
    arracy.info=C;
    arracy.error=error;
    arracy.result=pred;
    arracy.benchmark=benchmark;
    arracy.good_or_not=error<benchmark;
     
    

end

