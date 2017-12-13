//
//  CYTemTableViewCell.h
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/9.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYTemTableViewCell : UITableViewCell

@property (nonatomic) UILabel *timeLabel;          // 设置星期
@property (nonatomic) UIImageView *temImageView;   // 设置天气图标
@property (nonatomic) UILabel *maxLabel;           // 设置最高气温
@property (nonatomic) UILabel *minLabel;           // 设置最低气温

@end
