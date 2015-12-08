function result = pattern( data )

train='1005 pre-cleaned 4-03-15';
test='1005 pre-cleaned 2-6-15';


%%preclean part using loess method
train_preclean=preclean(train);
test_preclean=preclean(test);

%%skin, ambulation, time, hr, br, drink

%%transfer into useful dataset
traindata=cleandata(train_preclean,train);
testdata=cleandata(test_preclean,test);
result.origin_traindata=traindata;
result.origin_testdata=testdata;

%%linear fit method
if strcmp(fit,'linear')
   traindata=fitlinear(traindata);
   testdata=fitlinear(testdata);
   %%output train and test data
   result.fitlinear.train=traindata;
   result.fitlinear.test=testdata;
%%spline fit method
else if strcmp(fit, 'spline')
        traindata=fitspline(traindata);
        testdata=fitspline(testdata);
        result.fitspline.train=traindata;
        result.fitspline.test=testdata;
    end;
end;


end

