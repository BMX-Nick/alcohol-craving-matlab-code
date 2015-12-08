data = pipe('18_Mar_201513-18_','18_Mar_201518-21_','linear','period');



data1 = pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-6-15','linear','period',60);
data2 = pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-6-15','spline','shrink',60);
data3_1 = pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-6-15','linear','period',60);
data3_2 = pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-6-15','linear','period',60);
data4 = pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-6-15','spline','shrink',60);



data23=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-3-15','linear','period',30);
data24=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-4-15','linear','period',30);
data25_70=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-5-15','linear','period',60);%no hit
data25_100_s=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-5-15','spline','period',60);
data27=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-7-15','spline','period',60);%no hit
data28=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-8-15','linear','period',30);
data29=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-9-15','spline','period',60);%no hit
data210=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-10-15','linear','period',30);
data331=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 3-31-15','linear','period',30);

data401=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 4-01-15','linear','period',30);
data402=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 4-02-15','linear','period',30);
data43_90_linear_time_smallsize2=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','linear','period',60);%
data43_90_linear_time_smallsize3=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','linear','period',60);%



data43_90_spline_time=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','spline','period',60);%no hit
data43_90_linear_time=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','linear','period',60);%no hit
data43_50_linear_time_largesize=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','linear','period',60);%no hit
data43_90_spline_time_smallsize=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','spline','period',60);%
data25_50_linear_time_largesize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-5-15','linear','period',60);%no hit
data29_50_linear_time_largesize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-9-15','linear','period',60);
data25_90_spline_time_smallsize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-5-15','spline','period',60);%no hit
data29_90_spline_time_smallsize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-9-15','spline','period',60);
data2925_90_linear_time_smallsize=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 2-5-15','linear','period',60);





data43_50_l_t_large_sh=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','linear','period',60);%no hit
data43_90_spline_time_smallsize=pipe('1005 pre-cleaned 2-9-15','1005 pre-cleaned 4-03-15','spline','period',60);%
data25_50_linear_time_largesize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-5-15','linear','period',60);%no hit
data29_50_l_t_large_sh=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-9-15','linear','period',60);
data25_90_spline_time_smallsize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-5-15','spline','period',60);%no hit
data29_90_spline_time_smallsize=pipe('1005 pre-cleaned 4-03-15','1005 pre-cleaned 2-9-15','spline','period',60);
