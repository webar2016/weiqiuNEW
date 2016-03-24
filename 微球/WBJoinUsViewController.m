//
//  WBJoinUsViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBJoinUsViewController.h"
#import "WBGroupTableViewCell.h"
#import "WBTalkViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WBMyGroupModel.h"
#import <RongIMLib/RCIMClient.h>

#define MY_JOIN_GROUPS @"http://121.40.132.44:92/hg/getMyJion?userId=29"

@interface WBJoinUsViewController () {
    UIImageView *_emptyView;
}

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation WBJoinUsViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    }
    return self;
}

-(NSMutableArray *)models{
    if (_models) {
        return _models;
    }
    _models = [NSMutableArray array];
    return  _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
<<<<<<< HEAD
    
=======
    [self notifyUpdateUnreadMessageCount];
>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
    _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.pic.jpg"]];
    _emptyView.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENWIDTH);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
<<<<<<< HEAD
    int unRead = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]];
    if (unRead == 0) {
        self.tabBarController.tabBar.items[2].badgeValue = nil;
    } else {
        self.tabBarController.tabBar.items[2].badgeValue = [NSString stringWithFormat:@"%d",unRead];
    }
=======
>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
    [self loadData];
    
}

<<<<<<< HEAD
=======
-(void)notifyUpdateUnreadMessageCount{
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTipGroup" object:self userInfo:@{@"unReadGroup":[NSString stringWithFormat:@"%@",unReadGroup]}];
}

>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 加载数据

-(void)loadData{
    NSString *url = [NSString stringWithFormat:MY_JOIN_GROUPS];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.models = [WBMyGroupModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
        }
        
        [self willReloadTableData:self.conversationListDataSource];
        [self.conversationListTableView reloadData];
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

#pragma mark - 重写会话列表相关方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models.count == 0 || self.conversationListDataSource.count == 0) {
        [self.conversationListTableView addSubview:_emptyView];
        return 0;
    }
    
    if (self.models.count < self.conversationListDataSource.count) {
        [_emptyView removeFromSuperview];
        return self.models.count;
    } else {
        [_emptyView removeFromSuperview];
        return self.conversationListDataSource.count;
    }
    
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self rcConversationListTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"reuseCell";
    WBGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[WBGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isMater:NO];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    for (WBMyGroupModel *myModel in self.models) {
        NSString *groupId = [NSString stringWithFormat:@"%lu",(unsigned long)myModel.groupId];
        if ([model.targetId isEqualToString:groupId]) {
            model.extend = myModel;
            model.targetId = groupId;
            model.conversationTitle = [NSString stringWithFormat:@"%@的帮帮团",myModel.nickName];
        }
    }
    [cell setDataModel:self.conversationListDataSource[indexPath.row]];
    
    return cell;
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    WBTalkViewController *talkView = [[WBTalkViewController alloc]init];
    talkView.isMaster = NO;
    talkView.conversationType =model.conversationType;
    talkView.targetId = model.targetId;
    talkView.title = model.conversationTitle;
    if ([((WBMyGroupModel *)model.extend).isPush isEqual: @"Y"]) {
        talkView.isPush = YES;
    }
    talkView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:talkView animated:YES];
}

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
    [self hideHUD];
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0.3];
}

@end
