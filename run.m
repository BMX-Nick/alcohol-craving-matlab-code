%% 181318 period
data_linear_period_181318_1821 = pipe('18_Mar_201513-18_','18_Mar_201518-21_','linear','period',30);
data_spline_period_181318_1821 = pipe('18_Mar_201513-18_','18_Mar_201518-21_','spline','period',30);

data_linear_period_181318_03 = pipe('18_Mar_201513-18_','03_Mar_201519-21_','linear','period',30);
data_spline_period_181318_03 = pipe('18_Mar_201513-18_','03_Mar_201519-21_','spline','period',30);

%% 181821 period
data_linear_period_181821_1318 = pipe('18_Mar_201518-21_','18_Mar_201513-18_','linear','period',30);
data_spline_period_181821_1318 = pipe('18_Mar_201518-21_','18_Mar_201513-18_','spline','period',30);

data_linear_period_181821_03 = pipe('18_Mar_201518-21_','03_Mar_201519-21_','linear','period',30);
data_spline_period_181821_03 = pipe('18_Mar_201518-21_','03_Mar_201519-21_','spline','period',30);

%% 03 period

data_linear_period_03_181318 = pipe('03_Mar_201519-21_','18_Mar_201513-18_','linear','period',30);
data_spline_period_03_181318 = pipe('03_Mar_201519-21_','18_Mar_201513-18_','spline','period',30);

data_linear_period_03_181821 = pipe('03_Mar_201519-21_','18_Mar_201518-21_','linear','period',30);
data_spline_period_03_181821 = pipe('03_Mar_201519-21_','18_Mar_201518-21_','spline','period',30);

%% 181318 interval
data_linear_intervalrow_181318_1821 = pipe('18_Mar_201513-18_','18_Mar_201518-21_','linear','intervalrow',30);
data_spline_intervalrow_181318_1821 = pipe('18_Mar_201513-18_','18_Mar_201518-21_','spline','intervalrow',30);

data_linear_intervalrow_181318_03 = pipe('18_Mar_201513-18_','03_Mar_201519-21_','linear','intervalrow',30);
data_spline_intervalrow_181318_03 = pipe('18_Mar_201513-18_','03_Mar_201519-21_','spline','intervalrow',30);

%% 181823 interval
data_linear_intervalrow_181821_1318 = pipe('18_Mar_201518-21_','18_Mar_201513-18_','linear','intervalrow',30);
data_spline_intervalrow_181821_1318 = pipe('18_Mar_201518-21_','18_Mar_201513-18_','spline','intervalrow',30);

data_linear_intervalrow_181821_03 = pipe('18_Mar_201518-21_','03_Mar_201519-21_','linear','intervalrow',30);
data_spline_intervalrow_181821_03 = pipe('18_Mar_201518-21_','03_Mar_201519-21_','spline','intervalrow',30);

%% 03 intervalrow

data_linear_intervalrow_03_181318 = pipe('03_Mar_201519-21_','18_Mar_201513-18_','linear','intervalrow',30);
data_spline_intervalrow_03_181318 = pipe('03_Mar_201519-21_','18_Mar_201513-18_','spline','intervalrow',30);

data_linear_intervalrow_03_181821 = pipe('03_Mar_201519-21_','18_Mar_201518-21_','linear','intervalrow',30);
data_spline_intervalrow_03_181821 = pipe('03_Mar_201519-21_','18_Mar_201518-21_','spline','intervalrow',30);


%% raw
data_linear_raw_181318_1821 = raw('18_Mar_201513-18_','18_Mar_201518-21_','linear','nan');
data_spline_raw_181318_1821 = raw('18_Mar_201513-18_','18_Mar_201518-21_','spline','nan');
data_linear_raw_181318_03 = raw('18_Mar_201513-18_','03_Mar_201519-21_','linear','nan');
data_spline_raw_181318_03 = raw('18_Mar_201513-18_','03_Mar_201519-21_','spline','nan');


data_linear_raw_181821_181318 = raw('18_Mar_201518-21_','18_Mar_201513-18_','linear','nan');
data_spline_raw_181821_181318 = raw('18_Mar_201518-21_','18_Mar_201513-18_','spline','nan');
data_linear_raw_181821_03 = raw('18_Mar_201518-21_','03_Mar_201519-21_','linear','nan');
data_spline_raw_181821_03 = raw('18_Mar_201518-21_','03_Mar_201519-21_','spline','nan');

data_linear_raw_03_181821 = raw('18_Mar_201513-18_','18_Mar_201518-21_','linear','nan');
data_spline_raw_03_181821 = raw('18_Mar_201513-18_','18_Mar_201518-21_','spline','nan');
data_linear_raw_03_1821 = raw('18_Mar_201518-21_','03_Mar_201519-21_','linear','nan');
data_spline_raw_03_03 = raw('18_Mar_201518-21_','03_Mar_201519-21_','spline','nan');