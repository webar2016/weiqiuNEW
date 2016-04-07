//
//  WBGroupSettingViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupSettingViewController.h"
#import "WBGroupSettingTableViewCell.h"
#import "WBAllocateScoreViewController.h"
#import "WBHomepageViewController.h"

#import "WBUserInfosModel.h"
#import "WBCollectionViewModel.h"
#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import <RongIMLib/RCIMClient.h>

#define MEMBER_ICON @"http://121.40.132.44:92/hg/hgUsers?groupId=%@"
#define GROUP_DETAIL @"http://121.40.132.44:92/hg/oneHG?groupId=%@"

@interface WBGroupSettingViewController () <WBGroupSettingTableViewCellDelegate> {
    UILabel     *_totalMembers;
}

@property (nonatomic, strong) NSMutableArray *headIconArray;
@property (nonatomic, strong) WBCollectionViewModel *groupDetail;

@end

@implementation WBGroupSettingViewController

-(NSMutableArray *)headIconArray{
    if (_headIconArray) {
        return _headIconArray;
    }
    _headIconArray = [[NSMutableArray alloc] init];
    return _headIconArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮帮团设置";
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self loadHeadIcon];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载信息

-(void)loadHeadIcon{
    NSString *url = [NSString stringWithFormat:MEMBER_ICON,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.headIconArray = [WBUserInfosModel mj_objectArrayWithKeyValuesArray:result[@"users"]];
        }
    
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:GROUP_DETAIL,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.groupDetail = [WBCollectionViewModel mj_objectWithKeyValues:result[@"helpGroup"]];
        }
        [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.headIconArray.count;
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 241;
    }
    if (indexPath.section == 2) {
        return 40;
    }
    if (indexPath.section == 3) {
        return 70;
    }
    return 69;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 10)];
    headerView.backgroundColor = [UIColor initWithBackgroundGray];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];

        _totalMembers = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, SCREENWIDTH, 30)];
        _totalMembers.font = MAINFONTSIZE;
        _totalMembers.textColor = [UIColor initWithNormalGray];
        _totalMembers.text = [NSString stringWithFormat:@"%lu个团员",(unsigned long)self.headIconArray.count];

        [footerView addSubview:_totalMembers];
        return footerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellID = [[NSString alloc] init];
    switch (indexPath.section) {
        case 0:
            cellID = @"cell1";
            break;
        case 1:
            cellID = @"cell2";
            break;
        case 2:
            cellID = @"cell3";
            break;
        case 3:
            cellID = @"cell4";
            break;
    }
    
    WBGroupSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        cell = [[WBGroupSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withSection:indexPath.section isMaster:self.isMaster withGroupDetail:self.groupDetail messageIsPush:self.isPush];
    }
    if (indexPath.section == 0) {
        WBUserInfosModel *infos = self.headIconArray[indexPath.row];
        [cell setUserInfos:infos];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WBUserInfosModel *pageInfo = self.headIconArray[indexPath.row];
        WBHomepageViewController *homepage = [[WBHomepageViewController alloc] init];
        homepage.userId = [NSString stringWithFormat:@"%ld",(long)pageInfo.userId];
        [self.navigationController pushViewController:homepage animated:YES];
    }
}

#pragma mark - WBGroupSettingTableViewCellDelegate

-(void)quitGroup:(WBGroupSettingTableViewCell *)cell{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"现在退出帮帮团，你将无法获得球币，是否确认退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/hg/quitGroup?userId=%@&groupId=%@",[WBUserDefaults userId],self.groupId] whenSuccess:^(id representData) {
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.groupId];
                [self.navigationController popToRootViewControllerAnimated:NO];
            } andFailure:^(NSString *error) {
                [self showHUDComplete:@"退出失败，请检查网络后重试"];
            }];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)closeGroup:(WBGroupSettingTableViewCell *)cell{
    WBAllocateScoreViewController *AVC = [[WBAllocateScoreViewController alloc]init];
    AVC.groupId = _groupId;
    AVC.rewardIntegral = [NSString stringWithFormat:@"%ld",(long)self.groupDetail.rewardIntegral];
    [self.navigationController pushViewController:AVC animated:YES];
}

-(void)messagePush:(WBGroupSettingTableViewCell *)cell isOn:(BOOL)isOn{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    BOOL noPush;
    data[@"userId"] = [NSString stringWithFormat:@"%@",[WBUserDefaults userId]];
    data[@"groupId"] = self.groupId;
    
    if (isOn) {
        data[@"type"] = @"1";
        noPush = YES;
    } else {
        data[@"type"] = @"0";
        noPush = NO;
    }
    //设置SDK提醒
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:data[@"groupId"] isBlocked:noPush success:^(RCConversationNotificationStatus nStatus) {
        //消息提醒同步到服务器
        [MyDownLoadManager postUrl:@"http://121.40.132.44:92/hg/setPush" withParameters:data whenProgress:^(NSProgress *FieldDataBlock) {
        } andSuccess:^(id representData) {
            
            //向聊天页面发送免提醒通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"msgPush" object:self userInfo:@{@"msgPush":data[@"type"],@"groupId":data[@"groupId"]}];
            NSLog(@"免打扰设置成功");
            
        } andFailure:^(NSString *error) {
            
            //同步失败则将SDK的提醒方式改回原来的方式
            [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:data[@"groupId"] isBlocked:!noPush success:nil error:nil];
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"免打扰设置失败");
        }];
        
    } error:^(RCErrorCode status) {
        NSLog(@"免打扰设置失败---%ld",(long)status);
    }];
}

//-(void)QAPush:(WBGroupSettingTableViewCell *)cell isOn:(BOOL)isOn{
//    NSLog(@"QAPush");
//}

#pragma mark - MBprogress

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}
-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:2.0];
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0.3];
}

@end
