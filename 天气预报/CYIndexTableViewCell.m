//
//  CYIndexTableViewCell.m
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/9.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "CYIndexTableViewCell.h"

@implementation CYIndexTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        
        self.titleLabel1 = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel1];
        
        self.contentLabel1 = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.frame = CGRectMake(0, 9, 175, 18);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.frame = CGRectMake(195, 9, 175, 18);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    self.titleLabel1.font = [UIFont systemFontOfSize:15];
    self.titleLabel1.textColor = [UIColor whiteColor];
    self.titleLabel1.frame = CGRectMake(0, 31, 175, 18);
    self.titleLabel1.textAlignment = NSTextAlignmentRight;
    
    self.contentLabel1.font = [UIFont systemFontOfSize:15];
    self.contentLabel1.textColor = [UIColor whiteColor];
    self.contentLabel1.frame = CGRectMake(195, 31, 175, 18);
    self.contentLabel1.textAlignment = NSTextAlignmentLeft;
    
    
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
