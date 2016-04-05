//
//  WBSettingTableViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSettingViewController.h"
#import "WBAboutWBViewController.h"
#import <RongIMLib/RCIMClient.h>
#import "MyDBmanager.h"
#import <StoreKit/StoreKit.h>

@interface WBSettingViewController () <UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate> {
    UITableView     *_tableView;
    UISwitch        *_disturbSwitch;
    UISwitch        *_weiqiuSwitch;
    UIButton        *_loginOut;
    UIAlertController   *_alert;
}

@end

@implementation WBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    self.navigationItem.title = @"设置";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 8, SCREENWIDTH, 176)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorColor = [UIColor initWithBackgroundGray];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    _loginOut = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.15, SCREENHEIGHT - 120, SCREENWIDTH * 0.7, 35)];
    [_loginOut setBackgroundImage:[UIImage imageNamed:@"bg-23"] forState:UIControlStateNormal];
    [_loginOut setTitle:@"退出微球" forState:UIControlStateNormal];
    [_loginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginOut];
    
    _alert = [UIAlertController alertControllerWithTitle:@"设置失败，请重试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [_alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
}

#pragma mark - operations

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginOut{
    
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"是否确定退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [WBUserDefaults deleteUserDefaults];
            [[RCIMClient sharedRCIMClient] logout];
            
            MyDBmanager *manager1 = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
            [manager1 deleteAllData];
            [manager1 closeFBDM];
            
            MyDBmanager *manager2 = [[MyDBmanager alloc]initWithStyle:Help_group_sign];
            [manager2 deleteAllData];
            [manager2 closeFBDM];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            self.tabBarController.selectedIndex = 0;
        }];
        action;
    })];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)dontDisturb{
    if (_disturbSwitch.on) {
        [[RCIMClient sharedRCIMClient]setNotificationQuietHours:@"22:00:00" spanMins:540 success:^{
            [WBUserDefaults setUserDefaultsValue:YES withKey:@"dontDisturb"];
        } error:^(RCErrorCode status) {
            [self presentViewController:_alert animated:YES completion:nil];
            _disturbSwitch.on = NO;
        }];
    } else {
        [[RCIMClient sharedRCIMClient] removeNotificationQuietHours:^{
            [WBUserDefaults setUserDefaultsValue:NO withKey:@"dontDisturb"];
        } error:^(RCErrorCode status) {
            [self presentViewController:_alert animated:YES completion:nil];
            _disturbSwitch.on = YES;
        }];
    }
}

-(void)weiqiuDisturb{
    if (_weiqiuSwitch.on) {
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE targetId:@"weiqiu" isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
            [WBUserDefaults setUserDefaultsValue:YES withKey:@"weiqiuDisturb"];
        } error:^(RCErrorCode status) {
            _weiqiuSwitch.on = NO;
        }];
    } else {
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE targetId:@"weiqiu" isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
            [WBUserDefaults setUserDefaultsValue:NO withKey:@"weiqiuDisturb"];
        } error:^(RCErrorCode status) {
            _weiqiuSwitch.on = YES;
        }];
    }
}

#pragma mark - table view delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
//        SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
//        vc.delegate = self;
//        [vc loadProductWithParameters:
//         @{SKStoreProductParameterITunesItemIdentifier:@"536226604"}
//         completionBlock:^(BOOL result, NSError * _Nullable error) {
//             if(error){
//                 NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
//             }else{
//                 [self presentViewController:vc animated:YES completion:nil];
//             }
//         }];
    } else if (indexPath.row == 3) {
        WBAboutWBViewController *aboutVC = [[WBAboutWBViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSArray *title = @[@"夜间免打扰（22:00 - 7:00）",@"屏蔽微球小助手",@"给我们鼓励！",@"关于微球"];
    cell.textLabel.text = title[indexPath.row];
    cell.textLabel.textColor = [UIColor initWithNormalGray];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        _disturbSwitch = [[UISwitch alloc] init];
        _disturbSwitch.onTintColor = [UIColor initWithGreen];
        _disturbSwitch.center = CGPointMake(SCREENWIDTH * 0.9, 22);
        [_disturbSwitch addTarget:self action:@selector(dontDisturb) forControlEvents:UIControlEventValueChanged];
        if (![WBUserDefaults getBoolForKey:@"dontDisturb"]) {
            _disturbSwitch.on = NO;
            [WBUserDefaults addUserDefaultsValue:NO withKey:@"dontDisturb"];
        } else {
            _disturbSwitch.on = [WBUserDefaults getBoolForKey:@"dontDisturb"];
        }
        [cell.contentView addSubview:_disturbSwitch];
    } else if (indexPath.row == 1) {
        _weiqiuSwitch = [[UISwitch alloc] init];
        _weiqiuSwitch.onTintColor = [UIColor initWithGreen];
        _weiqiuSwitch.center = CGPointMake(SCREENWIDTH * 0.9, 22);
        [_weiqiuSwitch addTarget:self action:@selector(weiqiuDisturb) forControlEvents:UIControlEventValueChanged];
        if (![WBUserDefaults getBoolForKey:@"weiqiuDisturb"]) {
            _weiqiuSwitch.on = NO;
            [WBUserDefaults addUserDefaultsValue:NO withKey:@"weiqiuDisturb"];
        } else {
            _weiqiuSwitch.on = [WBUserDefaults getBoolForKey:@"weiqiuDisturb"];
        }
        [cell.contentView addSubview:_weiqiuSwitch];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
