//
//  CYSetViewController.h
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/8.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CYSetViewControllerDelegate <NSObject>

@required
- (void)delegateViewWillClickWithArray:(NSArray *)array;

@end

@interface CYSetViewController : UIViewController
//创建代理
@property (nonatomic) id<CYSetViewControllerDelegate> delegate;
@property (nonatomic) NSMutableArray *array;

@end
