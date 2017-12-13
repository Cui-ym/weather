//
//  CYWeatherView.m
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/10.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "CYWeatherView.h"
#import "CYSetViewController.h"
#import "CYTemTableViewCell.h"
#import "CYIndexTableViewCell.h"

#define cellID1 @"cell1"
#define cellID2 @"cell2"
#define cellID3 @"cell3"

@interface CYWeatherView ()<UITableViewDelegate, UITableViewDataSource>

{
    NSString *areaString;
    NSArray *numArray;                 // 记录每个section中row的行数
    int ar[4];
    NSArray *weekArray;                // 星期数组
    NSInteger *week;                   // 星期
    id obj;                            // JSON 数据
    NSMutableArray *hourTimeArray;     // 三小时时间数据
    NSMutableArray *hourTemArray;      // 三小时温度数据
    NSMutableArray *hourImageArray;    // 三小时照片数据
    NSMutableArray *imageArray;        // 未来6天图片数据
    NSMutableArray *maxTemArray;       // 最高气温
    NSMutableArray *minTemArray;       // 最低气温
    NSArray *firstTitleArray;          // 第一个标题
    NSArray *secondTitleArray;         // 第二个标题
    NSMutableArray *firstContentArray; // 第一个内容
    NSMutableArray *secondContentArray;// 第二个内容
}


@end

@implementation CYWeatherView

- (id)initWithAreaString:(NSString *)area number:(NSInteger)number
{
    self = [super initWithFrame:CGRectMake(375 * number, 0, 375, 667 - 45)];
    if (self) {
        areaString = area;
        self.backgroundColor = [UIColor clearColor];
        // 初始化
        ar[0] = 1;      // 今天24小时天气
        ar[1] = 6;      // 未来6天天气
        ar[2] = 1;      // 今天的天气详情
        ar[3] = 6;      // 今天的指数数据
        weekArray = [NSArray arrayWithObjects:@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        // 获取当前日期
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *now = [NSDate date];;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        comps = [calendar components:unitFlags fromDate:now];
        week = [comps weekday];
        // 3小时数据
        hourTemArray = [NSMutableArray array];
        hourTimeArray = [NSMutableArray array];
        hourImageArray = [NSMutableArray array];
        imageArray = [NSMutableArray array];
        maxTemArray = [NSMutableArray array];
        minTemArray = [NSMutableArray array];
        // 天气指数
        firstTitleArray = [NSArray arrayWithObjects:@"日出:", @"降雨概率:", @"风速:", @"风向:", @"pm2_5:", @"空气质量指数:", nil];
        secondTitleArray = [NSArray arrayWithObjects:@"日落:", @"湿度:", @"体感温度:", @"气压:", @"紫外线指数:", @"空气质量:", nil];
        firstContentArray = [NSMutableArray array];
        secondContentArray = [NSMutableArray array];
        
        // 设置网络请求字符串
        NSString *urlStr = [NSString stringWithFormat:@"http://route.showapi.com/9-2?area=%@&showapi_sign=2fb862e2926b414290ba4526dd4deda0&showapi_appid=43504&need3HourForcast=1&needMoreDay=1", area];
        NSLog(@"%@", area);
        // 中文字符转换
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 开始网络请求
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *requset = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requset completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // json解析
            if (error == nil){
                obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [obj objectForKey:@"showapi_res_body"];
                // 获得当前的数据
                NSDictionary *nowDic = [dic objectForKey:@"now"];
                _curTemperatureStr = [nowDic objectForKey:@"temperature"];             // 当前温度
                _weakStr = [nowDic objectForKey:@"weather"];                           // 当前天气
                // 获得今天的数据
                NSDictionary *todayDic = [dic objectForKey:@"f1"];
                NSLog(@"%@", todayDic);
                _maxTemStr = [todayDic objectForKey:@"day_air_temperature"];           // 获得最高气温
                _minTemStr = [todayDic objectForKey:@"night_air_temperature"];         // 获得最低气温
                // 获取3小时数据
                NSArray *dic1 = [todayDic objectForKey:@"3hourForcast"];
                // 3小时时间数据
                [hourTimeArray addObject:[dic1[0] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[1] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[2] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[3] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[4] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[5] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[6] objectForKey:@"hour"]];
                [hourTimeArray addObject:[dic1[7] objectForKey:@"hour"]];
                // 3小时温度数据
                [hourTemArray addObject:[dic1[0] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[1] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[2] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[3] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[4] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[5] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[6] objectForKey:@"temperature"]];
                [hourTemArray addObject:[dic1[7] objectForKey:@"temperature"]];
                // 3小时图片数据
                [hourImageArray addObject:[dic1[0] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[1] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[2] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[3] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[4] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[5] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[6] objectForKey:@"weather"]];
                [hourImageArray addObject:[dic1[7] objectForKey:@"weather"]];
                // 获得第二天的数据
                NSDictionary *twoDay = [dic objectForKey:@"f2"];
                [imageArray addObject:[twoDay objectForKey:@"day_weather"]];
                [maxTemArray addObject:[twoDay objectForKey:@"day_air_temperature"]];
                [minTemArray addObject:[twoDay objectForKey:@"night_air_temperature"]];
                // 获得第三天的数据
                NSDictionary *threeDay = [dic objectForKey:@"f3"];
                [imageArray addObject:[threeDay objectForKey:@"day_weather"]];
                [maxTemArray addObject:[threeDay objectForKey:@"day_air_temperature"]];
                [minTemArray addObject:[threeDay objectForKey:@"night_air_temperature"]];
                // 获得第四天的数据
                NSDictionary *fourDay = [dic objectForKey:@"f4"];
                [imageArray addObject:[fourDay objectForKey:@"day_weather"]];
                [maxTemArray addObject:[fourDay objectForKey:@"day_air_temperature"]];
                [minTemArray addObject:[fourDay objectForKey:@"night_air_temperature"]];
                // 获得第五天的数据
                NSDictionary *fiveDay = [dic objectForKey:@"f5"];
                [imageArray addObject:[fiveDay objectForKey:@"day_weather"]];
                [maxTemArray addObject:[fiveDay objectForKey:@"day_air_temperature"]];
                [minTemArray addObject:[fiveDay objectForKey:@"night_air_temperature"]];
                // 获得第六天的数据
                NSDictionary *sixDay = [dic objectForKey:@"f6"];
                [imageArray addObject:[sixDay objectForKey:@"day_weather"]];
                [maxTemArray addObject:[sixDay objectForKey:@"day_air_temperature"]];
                [minTemArray addObject:[sixDay objectForKey:@"night_air_temperature"]];
                // 获得第七天的数据
                NSDictionary *sevenDay = [dic objectForKey:@"f7"];
                [imageArray addObject:[sevenDay objectForKey:@"day_weather"]];
                [maxTemArray addObject:[sevenDay objectForKey:@"day_air_temperature"]];
                [minTemArray addObject:[sevenDay objectForKey:@"night_air_temperature"]];
                // 日出日落时间
                NSString *time = [todayDic objectForKey:@"sun_begin_end"];
                [firstContentArray addObject: [time substringWithRange:NSMakeRange(0, 5)]];
                [secondContentArray addObject: [time substringWithRange:NSMakeRange(6, 5)]];
                
                // 降水
                [firstContentArray addObject:[todayDic objectForKey:@"jiangshui"]];
                // 风速
                [firstContentArray addObject:[todayDic objectForKey:@"day_wind_power"]];
                // 降水量
                [firstContentArray addObject:[nowDic objectForKey:@"wind_direction"]];
                // 能见度
                [firstContentArray addObject:[[nowDic objectForKey:@"aqiDetail"] objectForKey:@"pm2_5"]];
                // 空气
                [firstContentArray addObject:[nowDic objectForKey:@"aqi"]];
                // 湿度
                [secondContentArray addObject:[nowDic objectForKey:@"sd"]];
                // 体感温度
                [secondContentArray addObject:[nowDic objectForKey:@"temperature"]];
                // 气压
                [secondContentArray addObject:[todayDic objectForKey:@"air_press"]];
                // 紫外线
                [secondContentArray addObject:[todayDic objectForKey:@"ziwaixian"]];
                // 空气质量
                [secondContentArray addObject:[[nowDic objectForKey:@"aqiDetail"] objectForKey:@"quality"]];
            }
            
            // 线程通信，回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置 UITableView
                _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667 - 45) style:UITableViewStyleGrouped];
                _tableView.backgroundColor = [UIColor clearColor];
                _tableView.delegate = self;
                _tableView.dataSource = self;
                _tableView.showsVerticalScrollIndicator = NO;
                [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID1];
                [_tableView registerClass:[CYTemTableViewCell class] forCellReuseIdentifier:cellID2];
                [_tableView registerClass:[CYIndexTableViewCell class] forCellReuseIdentifier:cellID3];
                [self addSubview:_tableView];
            });
        }];
        
        [dataTask resume];
    }
    return self;
}

// 设置每个 section 中 row 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ar[section];
}

// 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 自定义cell
    CYTemTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID2];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.backgroundColor = [UIColor clearColor];
    
    CYIndexTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID3];
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.backgroundColor = [UIColor clearColor];
    
    // 原本的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    // 隐藏不需要的分割线
    if (indexPath.row != ar[indexPath.section] - 1){
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 375);
    }
    if (indexPath.section == 0) {
        // 设置每小时天气更新
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 95)];
        scrollView.contentSize = CGSizeMake(70 * 8, 95);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        for (int i = 0; i < 8; i++) {
            // 设置每三小时的视图
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * 70, 0, 70, 95)];
            view.backgroundColor = [UIColor clearColor];
            
            // 设置时间范围
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 70, 15)];
            timeLabel.text = hourTimeArray[i];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.font = [UIFont systemFontOfSize:13];
            timeLabel.textColor = [UIColor whiteColor];
            [view addSubview:timeLabel];
            
            // 设置天气图标
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 34, 22, 22)];
            imageView.image = [UIImage imageNamed:hourImageArray[i]];
            [view addSubview:imageView];
            
            // 设置当前的温度
            UILabel *temLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 70, 20)];
            temLabel.text = hourTemArray[i];
            temLabel.textAlignment = NSTextAlignmentCenter;
            temLabel.textColor = [UIColor whiteColor];
            temLabel.font = [UIFont systemFontOfSize:17];
            [view addSubview:temLabel];
            
            // 将视图添加至scrollView中
            [scrollView addSubview:view];
        }
        // 设置cell的视图
        [cell.contentView addSubview:scrollView];
        return cell;
    } else if (indexPath.section == 1) {        // 未来6天的天气
        // 隐藏不需要的分割线
        if (indexPath.row != ar[indexPath.section] - 1){
            cell1.separatorInset = UIEdgeInsetsMake(0, 0, 0, 375);
        }
        int x = (int)(week + indexPath.row) % 7;
        cell1.timeLabel.text = weekArray[x];
        cell1.temImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
        cell1.maxLabel.text = maxTemArray[indexPath.row];
        cell1.minLabel.text = minTemArray[indexPath.row];
        return cell1;
    } else if (indexPath.section == 2) {        // 今天天气情况
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 300, 50)];
        label.numberOfLines = 0;
        NSString *str = [[NSString alloc] initWithFormat:@"今天：今天%@。当前气温%@º；最高气温%@º", _weakStr, _curTemperatureStr, _maxTemStr];
        label.text = str;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        return cell;
        
    } else {                                    // 今日天气指标
        // 隐藏不需要的分割线
        if (indexPath.row != ar[indexPath.section] - 1){
            cell2.separatorInset = UIEdgeInsetsMake(0, 0, 0, 375);
        }
        cell2.titleLabel.text = firstTitleArray[indexPath.row];
        cell2.titleLabel1.text = secondTitleArray[indexPath.row];
        cell2.contentLabel.text = firstContentArray[indexPath.row];
        cell2.contentLabel1.text = secondContentArray[indexPath.row];
        
        return cell2;
    }
}

// 设置 section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

// 设置 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95;
    } else if (indexPath.section == 1) {
        return 36;
    } else if (indexPath.section == 2) {
        return 60;
    } else {
        return 60;
    }
}

// 设置头标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 320;
    }
    return 0.001f;
}

// 设置尾标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

// 设置头标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 设置头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 320)];
    headerView.backgroundColor = [UIColor clearColor];
    
    // 设置地区
    self.areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 375, 30)];
    self.areaLabel.textAlignment = NSTextAlignmentCenter;
    self.areaLabel.text = areaString;
    self.areaLabel.font = [UIFont systemFontOfSize:28];
    self.areaLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_areaLabel];
    
    // 设置天气情况
    self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, 375, 20)];
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    self.weatherLabel.text = _weakStr;
    self.weatherLabel.font = [UIFont systemFontOfSize:18];
    self.weatherLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_weatherLabel];
    
    // 设置当前温度
    self.curTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 375, 80)];
    self.curTemperatureLabel.textAlignment = NSTextAlignmentCenter;
    self.curTemperatureLabel.text = _curTemperatureStr;
    self.curTemperatureLabel.font = [UIFont fontWithName:@"Al Nile" size:110];
    self.curTemperatureLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:_curTemperatureLabel];
    
    // 设置星期
    self.weakLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 55, 20)];
    self.weakLabel.text = weekArray[(int)week - 1];
    self.weakLabel.font = [UIFont systemFontOfSize:17];
    self.weakLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:self.weakLabel];
    
    // 设置今天文本
    UILabel *today = [[UILabel alloc] initWithFrame:CGRectMake(80, 300, 40, 20)];
    today.text = @"今天";
    today.font = [UIFont systemFontOfSize:17];
    today.textColor = [UIColor whiteColor];
    [headerView addSubview:today];
    
    // 设置最高，最低气温
    self.maxTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 300, 25, 20)];
    self.maxTemLabel.font = [UIFont systemFontOfSize:17];
    self.maxTemLabel.textColor = [UIColor whiteColor];
    self.maxTemLabel.text = self.maxTemStr;
    [headerView addSubview:self.maxTemLabel];
    self.minTemLabel = [[UILabel alloc] initWithFrame:CGRectMake(335, 300, 25, 20)];
    self.minTemLabel.font = [UIFont systemFontOfSize:17];
    self.minTemLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    self.minTemLabel.text = self.minTemStr;
    [headerView addSubview:self.minTemLabel];
    
    if (section == 0){
        return headerView;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
