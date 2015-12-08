function fitted = fitspline( data )

%data=traindata;
for i =1:size(data,1)
    data(i,7)=i;
end;
%%fit missing for br--5
    if sum(isnan(data(:,5)))==0
        yi=data(data(:,5)~=0,5);
        xi=data(data(:,5)~=0,7);
        fitspline=round(interp1(xi,yi,data(:,7),'spline'));
        data(:,5)=fitspline;
        data(data(:,5)>=60 | data(:,5)<=0,:)=[];
        data(data(:,5)==0,:)=[];
        data(isnan(data(:,5)),:)=[];
    else if sum(isnan(data(:,5)))~=0
            yi=data(~isnan(data(:,5)),5);
            xi=data(~isnan(data(:,5)),7);
            fitspline=round(interp1(xi,yi,data(:,7),'spline'));
            data(:,5)=fitspline;
            data(data(:,5)>=60 | data(:,5)<=0,:)=[];
            data(isnan(data(:,5)),:)=[];
        end;
    end;

    
%%fit missing for hr--4
    if sum(isnan(data(:,4)))==0
        yi=data(data(:,4)~=0,4);
        xi=data(data(:,4)~=0,7);
        fitspline=round(interp1(xi,yi,data(:,7),'spline'));
        data(:,4)=fitspline;
        data(data(:,4)>=200 | data(:,4)<=0,:)=[];
        data(data(:,4)==0,:)=[];
        data(isnan(data(:,4)),:)=[];
    else if sum(isnan(data(:,4)))~=0
            yi=data(~isnan(data(:,4)),4);
            xi=data(~isnan(data(:,4)),7);
            fitspline=round(interp1(xi,yi,data(:,7),'spline'));
            data(:,4)=fitspline;
            data(data(:,4)>=200 | data(:,4)<=0,:)=[];
            data(isnan(data(:,4)),:)=[];
        end;
    end;
    
%%fit missing for skin--1
    if sum(isnan(data(:,1)))==0
        yi=data(data(:,1)~=0,1);
        xi=data(data(:,1)~=0,7);
        fitspline=interp1(xi,yi,data(:,7),'spline');
        data(:,1)=fitspline;
        data(data(:,1)>=40 | data(:,1)<=0,:)=[];
        data(data(:,1)==0,:)=[];
        data(isnan(data(:,1)),:)=[];
    else if sum(isnan(data(:,1)))~=0
            yi=data(~isnan(data(:,1)),1);
            xi=data(~isnan(data(:,1)),7);
            fitspline=interp1(xi,yi,data(:,7),'spline');
            data(:,1)=fitspline;
            data(data(:,1)>=40 | data(:,1)<=0,:)=[];
            data(isnan(data(:,1)),:)=[];
        end;
    end;
%%put time into first col
    tmp=data(:,1);
    data(:,1)=data(:,3);
    data(:,3)=tmp;

%%return data
   fitted=data(:,1:6);

end

