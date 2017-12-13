//
//  CYTemTableViewCell.m
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/9.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "CYTemTableViewCell.h"

@implementation CYTemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.temImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.temImageView];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
        self.maxLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.maxLabel];
        
        self.minLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.minLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置星期文字属性
    self.timeLabel.frame = CGRectMake(20, 0, 50, 40);
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textColor = [UIColor whiteColor];
    
    // 设置图标
    self.temImageView.frame = CGRectMake(177, 10, 23, 20);
    
    // 设置温度文字属性
    self.maxLabel.frame = CGRectMake(300, 0, 20, 40);
    self.maxLabel.font = [UIFont systemFontOfSize:15];
    self.maxLabel.textColor = [UIColor whiteColor];
    self.minLabel.frame = CGRectMake(330, 0, 20, 40);
    self.minLabel.font = [UIFont systemFontOfSize:15];
    self.minLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
