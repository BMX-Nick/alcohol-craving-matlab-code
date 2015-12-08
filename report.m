function report = report( result )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%result=data43_90_lineargoodcut_time_smallsize;

%tree method evaluation

for i = 1:size(result.tree_extension,1)
    for j=1:size(result.tree_extension,2)
        for m=1:size(result.tree_extension(i,j).report,2)
            for n=1:size(result.tree_extension(i,j).report{m},2)
                report.tree_tp{i,j}(m,n)=size(result.tree_extension(i,j).report{m}{n},1);
                report.tree_tn{i,j}(m,n)=result.tree_extension(i,j).eval{m}{n}.confusion(1,2);
            end;
        end;
    end;
end;

%svm evaluation
for i = 1:size(result.svm_extension,1)
    for j=1:size(result.svm_extension,2)
        for m=1:size(result.svm_extension(i,j).report,2)
            report.svm_tp{i,j}(m)=size(result.svm_extension(i,j).report{m},1);
            report.svm_tn{i,j}(m)=result.svm_extension(i,j).eval{m}.confusion(1,2);
        end;
    end;
end;






end

