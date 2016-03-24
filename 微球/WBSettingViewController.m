//
//  WBSettingTableViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSettingViewController.h"
#import <RongIMLib/RCIMClient.h>

@interface WBSettingViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView     *_tableView;
    UISwitch        *_switch;
    UIButton        *_loginOut;
}

@end

@implementation WBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    self.navigationItem.title = @"设置";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, SCREENWIDTH, 132)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor initWithBackgroundGray];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    _loginOut = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.2, SCREENHEIGHT - 104, SCREENWIDTH * 0.6, 30)];
    [_loginOut setBackgroundImage:[UIImage imageNamed:@"bg-23"] forState:UIControlStateNormal];
    [_loginOut setTitle:@"退出微球" forState:UIControlStateNormal];
    [_loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginOut];
}

#pragma mark - operations

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginOut{
    NSLog(@"退出微球");
}

-(void)dontDisturb{
    if (_switch.selected) {
        [[RCIMClient sharedRCIMClient]setNotificationQuietHours:@"22:00:00" spanMins:540 success:^{
            NSLog(@"免打扰设置成功");
        } error:^(RCErrorCode status) {
            NSLog(@"免打扰设置失败---%ld",(long)status);
        }];
    } else {
        [[RCIMClient sharedRCIMClient] removeNotificationQuietHours:^{
            NSLog(@"打开提醒设置成功");
        } error:^(RCErrorCode status) {
            NSLog(@"打开提醒设置失败---%ld",(long)status);
        }];
    }
}

#pragma mark - table view delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSLog(@"给我们鼓励！");
    } else if (indexPath.row == 2) {
        NSLog(@"关于微球");
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSArray *title = @[@"夜间免打扰（22:00 - 7:00）",@"给我们鼓励！",@"关于微球"];
    cell.textLabel.text = title[indexPath.row];
    cell.textLabel.textColor = [UIColor initWithNormalGray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        _switch = [[UISwitch alloc] init];
        _switch.onTintColor = [UIColor initWithGreen];
        _switch.selected = NO;
        _switch.center = CGPointMake(SCREENWIDTH * 0.9, 22);
        [_switch addTarget:self action:@selector(dontDisturb) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:_switch];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
