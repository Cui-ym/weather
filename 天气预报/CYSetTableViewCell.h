//
//  CYSetTableViewCell.h
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/10.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYSetTableViewCell : UITableViewCell

@property (nonatomic) UILabel *areaLabel;           // 地区
@property (nonatomic) UILabel *temLabel;            // 天气情况
@property (nonatomic) UIImageView *temImageView;    // 天气图片

@end
