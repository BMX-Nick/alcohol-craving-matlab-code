function result = run_plot(data,fit,graph,m)

%data='1005 pre-cleaned 4-03-15';
%test='1005 pre-cleaned 2-6-15';


%%preclean part using loess method
data_preclean=preclean(data);


%%skin, ambulation, time, hr, br, drink

%%transfer into useful dataset
cleaned_data=cleandata(data_preclean,data);
result.origin_data=cleaned_data;


%%linear fit method
if strcmp(fit,'linear')
   cleaned_data=fitlinear(cleaned_data);
   %%output train and test data
   result.fitlinear.data=cleaned_data;
%%spline fit method
else if strcmp(fit, 'spline')
        cleaned_data=fitspline(cleaned_data);
        %%output train and test data
        result.fitspline.data=cleaned_data;
    end;
end;


result.numberofdrink.data=sum(cleaned_data(:,end));

if strcmp(graph,'smooth')
    smooth(cleaned_data,m);
end;

end

