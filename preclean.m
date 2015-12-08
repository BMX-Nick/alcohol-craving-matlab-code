function data = preclean(file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the method used in preclean file is to smooth
%4 variables(hr, br, skin, activity) by 1 to n 
%using loess method. 
%after fitting loess method, get the residual for 
%each point and then assign outlier which residual 
%is greater than 2 sigma as 0
%the value will be using should be fixed value
%rather than original value
%
%
% written by Peng
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%preclean=readtable('1005 pre-cleaned 12-11-14.csv');
%file='1005 pre-cleaned 12-11-14';
preclean=readtable([file '.csv']);
%%%%all nan to 0
preclean.HR(isnan(preclean.HR))=0;
preclean.BR(isnan(preclean.BR))=0;
preclean.activity(isnan(preclean.activity))=0;
preclean.Skin_Temperature__IR_Thermometer(isnan(preclean.Skin_Temperature__IR_Thermometer))=0;

%%%build index
for i=1:size(preclean,1)
    preclean.measurement(i)=i;
end;

%%%%fit loess
%variable list
var_list={'HR','BR','activity','Skin_Temperature__IR_Thermometer'};

for i=1:4
    x=preclean.measurement;
    y=zeros(size(preclean,1),1);
    name=['preclean.',var_list{i}];
    z=eval(name);
    
    
    [xData, yData, zData{i}] = prepareSurfaceData( x, y, z );

% Set up fittype and options.
    ft = fittype( 'loess' );
    opts = fitoptions( 'Method', 'LowessFit' );
    opts.Normalize = 'on';
    opts.Span = 0.01;

% Fit model to data.
    [fitresult, gof] = fit( [xData, yData], zData{i}, ft, opts );

% get fitted value;
    fitted=feval(fitresult,[xData, yData]);

% residual
    residual=abs(fitted-zData{i});

    var_residual(i)=sqrt(var(residual));

    z_resid=residual/var_residual(i);

%fix
    zData{i}(2*var_residual(i)+mean(residual)<=residual)=0;

end;

% replace raw data by fixed data
    preclean.HR=zData{1};
    preclean.BR=zData{2};
    preclean.activity=zData{3};
    preclean.Skin_Temperature__IR_Thermometer=zData{4};
    
%return data
    data=preclean;

end

