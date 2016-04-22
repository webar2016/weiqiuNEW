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

#define MY_JOIN_GROUPS @"http://app.weiqiu.me/hg/getMyJion?userId=%@"

@interface WBJoinUsViewController () <UIScrollViewDelegate> {
    UIImageView *_emptyView;
    CGFloat _beginScoller;
}

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation WBJoinUsViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    }
    [self loadData];
    self.emptyConversationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    self.emptyConversationView.center = CGPointMake(SCREENWIDTH / 2, 170);
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"getGroupInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"showNewGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"msgPush" object:nil];
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
    [self refreshTableView];
    [self notifyUpdateUnreadMessageCount];
    _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.pic.jpg"]];
    _emptyView.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENWIDTH);    
}

-(void)refreshTableView{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.conversationListTableView.mj_header = header;
    
}

-(void)notifyUpdateUnreadMessageCount{
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTipGroup" object:self userInfo:@{@"unReadGroup":[NSString stringWithFormat:@"%@",unReadGroup]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 加载数据

-(void)loadData{
    NSString *url = [NSString stringWithFormat:MY_JOIN_GROUPS,[WBUserDefaults userId]];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.models = [WBMyGroupModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
            [self.conversationListTableView reloadData];
            [self.conversationListTableView.mj_header endRefreshing];
        }
        
    } andFailure:^(NSString *error) {
        [self.conversationListTableView.mj_header endRefreshing];
        NSLog(@"%@------",error);
    }];
}

#pragma mark - 重写会话列表相关方法

-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    NSMutableArray *array = [NSMutableArray array];
    for (RCConversationModel *model in dataSource) {
        for (WBMyGroupModel *myModel in self.models) {
            NSString *groupId = [NSString stringWithFormat:@"%lu",(unsigned long)myModel.groupId];
            if ([model.targetId isEqualToString:groupId]) {
                model.extend = myModel;
                model.conversationTitle = [NSString stringWithFormat:@"%@的帮帮团",myModel.nickName];
                [array addObject:model];
            }
        }
    }
    return array;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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

#pragma mark -- UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint scrollViewOffset = scrollView.contentOffset;
    _beginScoller = scrollViewOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint scrollViewOffset = scrollView.contentOffset;
    if (scrollViewOffset.y - _beginScoller >= 0) {
        //往下滑
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.tabBarController.tabBar setFrame:CGRectMake(0.0f,SCREENHEIGHT,self.view.frame.size.width,49)];
                         }];
    }else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.tabBarController.tabBar setFrame:CGRectMake(0.0f,SCREENHEIGHT - 49,self.view.frame.size.width,49)];
                         }];
    }
}

#pragma mark - MBprogress

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.opacity = 0.7;
    self.hud.labelText = title;
}
-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    self.hud.opacity = 0.7;
    [self hideHUD];
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0];
}

@end
