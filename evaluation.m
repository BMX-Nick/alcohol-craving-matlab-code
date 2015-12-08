function [result,output]= evaluation(test,interval)

%a=1:20;
%b=[0,0,0,1,0,1,0,1,0,0,1,0,0,1,0,1,0,0,1,1];
%c=[0,0,1,1,0,0,1,0,1,0,0,0,1,1,0,1,0,0,0,1];
%test=[a;b;c];
%test=transpose(test);
%interval=60;

%test=data29_90_linear_time_smallsize.tree_extension(2,2).reverse{1,2}{1,3}.pair;

test(:,4)=0;
    
    n=size(test,1);
    NumberOfPredictionAsOne=0;
    testDCount = 0;
    for i=1:n
        if test(i,3)== 1
            NumberOfPredictionAsOne=NumberOfPredictionAsOne+1;
        end
    end
    output=zeros(1,3);
    
%prediction starts
    for i=1:n
        if test(i,2)== 1 
            testDCount=testDCount+1;
            testIndex=i;
            MinIndex=testIndex-interval;
            MaxIndex=testIndex+interval;
            if MinIndex<1
                MinIndex=1;
            end
            if MaxIndex>n
                MaxIndex=n;
            end
            if sum(test(MinIndex:testIndex,4)) ~=0
                MinIndex=marked+1;
            end;
            if sum(test(MinIndex:MaxIndex,3)) ~=0
                row=1;
                for j=MinIndex:MaxIndex
                    if test(j,3) == 1
                        tempDeviation(row)=abs(j-testIndex);   
                        row = row+1;  
                    end;
                end;
                [min_idx1 min_idx2]=min(tempDeviation);   
                min_deviation=tempDeviation(min_idx2);

                    for j=MinIndex:MaxIndex     
                        if test(j,2)==1
                            output=[output;test(j,1:2),min_deviation];
                        end;
                    end;
                    test(1:(i+interval),4)=1;
                    marked=i+interval;
            end;
        clear tempDeviation   
    end;
    end;
    output(1,:)=[];
    dCount=size(output,1);
    
    true_positive=dCount;
    true_negative=testDCount-dCount;
    false_positive=NumberOfPredictionAsOne-dCount;
    false_negative=size(test,1)-false_positive-true_negative-true_positive;
    
    
    result.correctIdDrink =dCount;
    result.numberOfPrediction = NumberOfPredictionAsOne;
%     result.drinkAccrcy = rtn.correctIdDrink/NumberOfPredictionAsOne;
    result.drinkTestAccrcy = dCount/testDCount;
    result.drinkTest = testDCount;
    result.drinkPredAccrcy = dCount/NumberOfPredictionAsOne;
    result.confusion=[false_negative,false_positive;true_negative,true_positive];
    if result.correctIdDrink<1
        result.deviation = -1;
    else
        result.deviation = mean(output(:,3));
    end
    
end

