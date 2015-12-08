function arracy = glmm( train, test )
train=array2table(data1.train);
test=array2table(data1.test);
col=size(train,2);
fixed='1';
for j=2:col-1
    for i=1:col
        varstr{i}=sprintf('+Var%d',i);
    end;
    fixed=strcat(fixed,varstr{j});
end;
random='+(1|Var1)';
reponse=sprintf('Var%d',col);
formula=strcat(reponse,'~',fixed,random);
glme = fitglme(train,'Var16~1+Var2+Var3+Var4+Var5','Distribution','Binomial','Link','logit','FitMethod','REMPL');
pred_glme=predict(glme,test(:,1:end-1));
predcut=pred_glme>=0.5;
confusion=confusionmat(table2array(test(:,end)),predcut);

arracy.confusion=confusion;

end

