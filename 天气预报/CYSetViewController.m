//
//  CYSetViewController.m
//  天气预报
//
//  Created by 崔一鸣 on 2017/8/8.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "CYSetViewController.h"
#import "CYSetTableViewCell.h"

#define CELLID @"cell"

@interface CYSetViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate>
{
    UITableView *table;
    UIAlertController *alert;
    NSArray *newArray;      // 添加的城市信息
    NSInteger num;         // 添加的城市个数
    UISearchBar *search;
}
@end

@implementation CYSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    // 初始化 数组
    self.array = [NSMutableArray array];
    newArray = [NSArray array];
    num = 0;
    
    // 设置tableView
    table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[CYSetTableViewCell class] forCellReuseIdentifier:CELLID];
    table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:table];
    
    // 创建手势 左滑返回界面
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeView)];
    [table addGestureRecognizer:swipe];
    
}

// 左滑手势返回界面
- (void)swipeView {
    // 协议传值
    if ([self.delegate respondsToSelector:@selector(delegateViewWillClickWithArray:)]) {
        [self.delegate delegateViewWillClickWithArray:self.array];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

// 设置点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // 键盘回收
    [searchBar resignFirstResponder];
    // 判断城市是否存在
    NSString *urlStr = [[NSString alloc] initWithFormat:@"http://route.showapi.com/9-2?area=%@&showapi_sign=2fb862e2926b414290ba4526dd4deda0&showapi_appid=43504", searchBar.text];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTesk = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (error != nil) {
            NSLog(@"error!%@", error);
        } else {
            NSString *str = [[[obj objectForKey:@"showapi_res_body"] objectForKey:@"cityInfo"] objectForKey:@"c3"];
            NSLog(@"%@", obj);
            NSLog(@"%@", str);
            NSLog(@"%@", searchBar.text);
            if ([str isEqual:searchBar.text] == 0) {
                // 不存在城市
                // 跳出警告框
                alert = [UIAlertController alertControllerWithTitle:nil message:@"该城市不存在" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                // 回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 一秒后自动消失
                    [self performSelector:@selector(delete) withObject:alert afterDelay:1];
                });
            } else {
                // 城市存在
                int flag = 0;
                // 判断城市是否已经添加
                for (int i = 0; i < self.array.count; i++) {
                    if ([searchBar.text isEqual:self.array[i][1]]) {
                        // 城市已添加
                        flag = 1;
                        break;
                    }
                }
                if (flag == 1) {
                    // 跳出警告窗口
                    alert = [UIAlertController alertControllerWithTitle:nil message:@"城市已经添加" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(delete) withObject:alert afterDelay:1];
                    });
                } else {
                    // 跳出警告框
                    UIAlertController *myAlert = [UIAlertController alertControllerWithTitle:@"城市存在" message:@"是否添加城市" preferredStyle:UIAlertControllerStyleAlert];
                    // 添加"添加"按钮
                    UIAlertAction *cencelAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^ (UIAlertAction*action){
                        // 记录查询城市的基本信息
                        NSDictionary *nowDic = [[obj objectForKey:@"showapi_res_body"] objectForKey:@"now"];
                        NSString *weather = [nowDic objectForKey:@"weather"];
                        NSString *city = [[[obj objectForKey:@"showapi_res_body"]   objectForKey:@"cityInfo"] objectForKey:@"c3"];
                        NSString *temperature = [nowDic objectForKey:@"temperature"];
                        newArray = [NSArray arrayWithObjects:weather, city, temperature, nil];
                        // 添加至数组中
                        [self.array addObject:newArray];
                        [table reloadData];
                    }];
                    
                    [myAlert addAction:cencelAction];
                    // 添加"取消"按钮
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                    [myAlert addAction:yesAction];
                    [self presentViewController:myAlert animated:YES completion:nil];
                }
            }
        }
        
    }];
    [dataTesk resume];
}


// 删除警告框
- (void)delete{
    [alert dismissViewControllerAnimated:YES completion:nil];
}


// 在头标题处添加搜索框
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 设置搜索框
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 375, 64)];
    search.barStyle = UIBarStyleDefault;
    search.tag = 1001;
    search.placeholder = @"输入城市名称";
    search.delegate = self;
    [search setKeyboardType:UIKeyboardTypeDefault];
    return search;
}

// 设置row高的
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

// 设置尾标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

// 设置头标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

// 设置row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

// 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYSetTableViewCell *cell = [table dequeueReusableCellWithIdentifier:CELLID];
    cell.backgroundColor = [UIColor colorWithRed:0.26f green:0.61f blue:0.77f alpha:1.00f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.temImageView.image = [UIImage imageNamed:self.array[indexPath.row][0]];
    cell.areaLabel.text = self.array[indexPath.row][1];
    cell.temLabel.text = self.array[indexPath.row][2];
    NSLog(@"%@", self.array[indexPath.row][0]);
    
    return cell;
}

// 设置编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TRUE;
}

// 删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// 滑动删除 cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.array count]) {
            [self.array removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

// 点击回收键盘
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [search resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
