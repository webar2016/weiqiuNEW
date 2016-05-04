//
//  WBJoinUsViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMyJoinViewController.h"
#import "WBGroupTableViewCell.h"
#import "WBTalkViewController.h"
#import "WBAllGroupViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WBMyGroupModel.h"
#import <RongIMLib/RCIMClient.h>

@interface WBMyJoinViewController () <UIScrollViewDelegate> {
    UIImageView *_emptyView;
    CGFloat _beginScoller;
    WBAllGroupViewController *_allGroupView;
}

@property (nonatomic, strong) NSMutableArray *myCreate;
@property (nonatomic, strong) NSMutableArray *myJoin;
@property (nonatomic, assign) BOOL loadCreate;
@property (nonatomic, assign) BOOL loadJoin;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation WBMyJoinViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];
    }
    [self setConversationAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    self.view.backgroundColor = [UIColor whiteColor];
    self.emptyConversationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    self.emptyConversationView.center = CGPointMake(SCREENWIDTH / 2, 200);
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myCreate = [NSMutableArray array];
    self.myJoin = [NSMutableArray array];
    [self setUpHeaderView];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self notifyUpdateUnreadMessageCount];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadMyGroup];
}

-(void)setUpHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    headerView.backgroundColor = [UIColor initWithBackgroundGray];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allGroupList)];
    [headerView addGestureRecognizer:tap];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 40, 40)];
    tip.text = @"查看所有我的帮帮团";
    tip.textColor = [UIColor initWithNormalGray];
    tip.font = MAINFONTSIZE;
    tip.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:tip];
    
    self.conversationListTableView.tableHeaderView = headerView;
}

-(void)loadMyGroup{
    [self showHUDIndicator];
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"%@/hg/getMyCreate?userId=%@",WEBAR_IP,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            NSMutableArray *temp = [WBMyGroupModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
            for (WBMyGroupModel *model in temp) {
                [self.myCreate addObject:[NSString stringWithFormat:@"%ld",(unsigned long)model.groupId]];
            }
        }
        self.loadCreate = YES;
        [self endLoad];
        
    } andFailure:^(NSString *error) {
        self.loadCreate = YES;
        [self endLoad];
        NSLog(@"%@",error);
    }];
    
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"%@/hg/getMyJion?userId=%@",WEBAR_IP,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            NSMutableArray *temp = [WBMyGroupModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
            for (WBMyGroupModel *model in temp) {
                [self.myJoin addObject:[NSString stringWithFormat:@"%ld",(unsigned long)model.groupId]];
            }
        }
        self.loadJoin = YES;
        [self endLoad];
    } andFailure:^(NSString *error) {
        self.loadJoin = YES;
        [self endLoad];
        NSLog(@"%@------join",error);
    }];
}

-(void)endLoad{
    if (self.loadJoin && self.loadCreate) {
        NSInteger count = self.conversationListDataSource.count;
        for (NSInteger i = 0; i < count; i ++) {
            RCConversationModel *model = self.conversationListDataSource[i];
            if (![self.myCreate containsObject:model.targetId] && ![self.myJoin containsObject:model.targetId]) {
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:model.targetId];
            }
        }
        [self willReloadTableData:self.conversationListDataSource];
        [self hideHUD];
    }
}

-(void)allGroupList{
    _allGroupView = [[WBAllGroupViewController alloc] init];
    _allGroupView.navigationItem.title = @"我的帮帮团";
    _allGroupView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_allGroupView animated:YES];
}

-(void)notifyUpdateUnreadMessageCount{
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTipGroup" object:self userInfo:@{@"unReadGroup":[NSString stringWithFormat:@"%@",unReadGroup]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 重写会话列表相关方法

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    WBTalkViewController *talkView = [[WBTalkViewController alloc]init];
    if ([self.myCreate containsObject:model.targetId]) {
        talkView.isMaster = YES;
    } else {
        talkView.isMaster = NO;
    }
    talkView.conversationType =model.conversationType;
    talkView.targetId = model.targetId;
    talkView.title = model.conversationTitle;
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

#pragma mark - MBProgressHUD

-(void)showHUDText:(NSString *)title{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.opacity = 0.7;
    self.hud.dimBackground = NO;
    self.hud.labelText = title;
    [self hideHUDDelay:1.0];
}

-(void)showHUDIndicator{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.activityIndicatorColor = [UIColor blackColor];
}

-(void)hideHUD
{
    [self hideHUDDelay:0];
}

-(void)hideHUDDelay:(NSTimeInterval)delay{
    [self.hud hide:YES afterDelay:delay];
}

@end
