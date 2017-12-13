//
//  CYSetTableViewCell.m
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/10.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "CYSetTableViewCell.h"

@implementation CYSetTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // 地区初始化
        self.areaLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.areaLabel];
        
        // 温度初始化
        self.temLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.temLabel];
        
        // 图标初始化
        self.temImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.temImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 天气图标
    self.temImageView.frame = CGRectMake(15, 15, 55, 55);
    
    // 地区
    self.areaLabel.frame = CGRectMake(80, 0, 150, 85);
    self.areaLabel.font = [UIFont systemFontOfSize:30];
    self.areaLabel.textColor = [UIColor whiteColor];
    
    // 温度
    self.temLabel.frame = CGRectMake(200, 0, 160, 85);
    self.temLabel.font = [UIFont systemFontOfSize:30];
    self.temLabel.textColor = [UIColor whiteColor];
    self.temLabel.textAlignment = NSTextAlignmentRight;
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
