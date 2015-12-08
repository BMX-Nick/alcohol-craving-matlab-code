function data = combinemultiple( fitting,varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%fitting='linear';
%varargin{1}='1005 pre-cleaned 2-3-15';
%varargin{2}='1005 pre-cleaned 2-4-15';
%nargin=3;

for i=1:(nargin-1)
    precleaned{i}=preclean(varargin{i});
    part_data{i}=cleandata(precleaned{i},varargin{i});
    if strcmp(fitting,'linear')
        fitteddata{i}=fitlinear(part_data{i});

%%spline fit method
    else if strcmp(fitting, 'spline')
        fitteddata{i}=fitspline(part_data{i});
        end;
    end;
end;

data.one=part_data;
data.two=fitteddata;
combine=[];
for j=1:size(fitteddata,2)
    combine=[combine;fitteddata{j}];
end;


data=combine;
end

