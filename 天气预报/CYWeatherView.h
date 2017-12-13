//
//  CYWeatherView.h
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/10.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWeatherView : UIView

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UILabel *areaLabel;             // 设置地区名称
@property (nonatomic) UILabel *weatherLabel;          // 设置今天天气
@property (nonatomic) UILabel *curTemperatureLabel;   // 设置当前温度
@property (nonatomic) UILabel *weakLabel;             // 设置星期
@property (nonatomic) UILabel *maxTemLabel;           // 设置最高温度
@property (nonatomic) UILabel *minTemLabel;           // 设置最低温度
@property (nonatomic) NSString *areaStr;              // 设置地区名称
@property (nonatomic) NSString *weatherStr;           // 设置今天天气
@property (nonatomic) NSString *curTemperatureStr;    // 设置当前温度
@property (nonatomic) NSString *weakStr;              // 设置星期
@property (nonatomic) NSString *maxTemStr;            // 设置最高温度
@property (nonatomic) NSString *minTemStr;            // 设置最低温度

- (id)initWithAreaString:(NSString *)area number:(NSInteger)number;

@end
