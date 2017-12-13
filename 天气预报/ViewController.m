//
//  ViewController.m
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/6.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "ViewController.h"
#import "CYWeatherView.h"
#import "CYSetViewController.h"

@interface ViewController () <CYSetViewControllerDelegate, UIScrollViewDelegate>
{
    UIScrollView *scroll;
    NSMutableArray *cityArray;
    UIPageControl *pageControl;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", cityArray);
    // 初始化
    self.num = cityArray.count;
    self.view.backgroundColor = [UIColor colorWithRed:0.26f green:0.61f blue:0.77f alpha:1.00f];
    
    // 设置scrollView
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 667 - 45)];
    scroll.contentSize = CGSizeMake(self.num * 375, 667 - 45);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    
    // 创建天气界面
    for (int i = 0; i < self.num; i++) {
        NSLog(@"%@", cityArray[i][1]);
        CYWeatherView *weatherView = [[CYWeatherView alloc] initWithAreaString:cityArray[i][1] number:i];
        [scroll addSubview:weatherView];
    }
    [self.view addSubview:scroll];
    
    // 设置跳转按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(330, 10, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 底部 view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 667 - 45, 375, 45)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    // 添加pageView
    pageControl = [[UIPageControl alloc] initWithFrame:view.bounds];
    pageControl.numberOfPages = self.num;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:pageControl];
    [view addSubview:btn];
}

- (void)viewDidDisappear:(BOOL)animated {
    // 移除所有子视图
    for(UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
}

// 当scroll跳转时调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageControl setCurrentPage:offset.x / bounds.size.width];
}

// 实现点击下方圆点翻页
- (void)pageTurn:(UIPageControl *)sender {
    CGSize viewSize = scroll.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [scroll scrollRectToVisible:rect animated:YES];
}

// push 至设置界面
- (void)pushClick {
    CYSetViewController *view = [[CYSetViewController alloc] init];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
    view.array = [[NSMutableArray alloc] initWithArray:cityArray];
}

// 实现代理方法
- (void)delegateViewWillClickWithArray:(NSArray *)array {
    cityArray = [[NSMutableArray alloc] initWithArray:array];
    [self viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
