//
//  WBMyCreateViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAllGroupViewController.h"
#import "WBGroupTableViewCell.h"
#import "WBTalkViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "WBMyGroupModel.h"

#define MY_CREATE_GROUPS @"%@/hg/getMyCreate?userId=%@"
#define MY_JOIN_GROUPS @"%@/hg/getMyJion?userId=%@"

@interface WBAllGroupViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    UIImageView *_emptyView;
    UITableView *_tableView;
    NSMutableArray *_createModels;
    NSMutableArray *_joinModels;
    
    BOOL _loadJoin;
    BOOL _loadCreate;
    BOOL _loadFailure;
}
@end

@implementation WBAllGroupViewController

-(instancetype)init{
    self = [super init];
    _createModels = [NSMutableArray array];
    _joinModels = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _emptyView.center = CGPointMake(SCREENWIDTH / 2, 200);
    [self setUpTableView];
    [self refreshTableView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = back;
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

-(void)refreshTableView{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 加载数据

-(void)loadData{
    [self showHUDIndicator];
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:MY_JOIN_GROUPS,WEBAR_IP,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            _joinModels = [WBMyGroupModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
        }
        _loadJoin = YES;
        [self endLoad];
    } andFailure:^(NSString *error) {
        _loadJoin = YES;
        [self showHUDText:@"网络状态不佳，请稍后再试"];
        [self endLoad];
         NSLog(@"%@------join",error);
    }];
    
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:MY_CREATE_GROUPS,WEBAR_IP,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            _createModels = [WBMyGroupModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
        }
        _loadCreate = YES;
        [self endLoad];
    } andFailure:^(NSString *error) {
        _loadCreate = YES;
        [self showHUDText:@"网络状态不佳，请稍后再试"];
        [self endLoad];
        NSLog(@"%@------create",error);
    }];
}

-(void)endLoad{
    if (_loadCreate && _loadJoin) {
        [_tableView.mj_header endRefreshing];
        [self hideHUD];
        _loadCreate = NO;
        _loadJoin = NO;
        [_tableView reloadData];
    }
}

#pragma mark - tableview delegate data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (_joinModels.count == 0) {
                return 50;
            } else {
                return 66;
            }
        }
            break;
            
        case 1:
        {
            if (_createModels.count == 0) {
                return 50;
            } else {
                return 66;
            }
        }
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (_joinModels.count == 0) {
                return 1;
            } else {
                return _joinModels.count;
            }
        }
            break;
            
        case 1:
        {
            if (_createModels.count == 0) {
                return 1;
            } else {
                return _createModels.count;
            }
        }
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    headerView.backgroundColor = [UIColor initWithBackgroundGray];
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH, 30)];
    tip.font = FONTSIZE12;
    tip.textColor = [UIColor initWithNormalGray];
    [headerView addSubview:tip];
    if (section == 0) {
        tip.text = @"我加入的帮帮团";
    } else {
        tip.text = @"我创建的帮帮团";
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"reuseCell";
    
    if ((_createModels.count == 0 && indexPath.section == 1) || (_joinModels.count == 0 && indexPath.section == 0)) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"该列表暂时没有帮帮团";
        cell.textLabel.font = MAINFONTSIZE;
        cell.textLabel.textColor = [UIColor initWithLightGray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    BOOL isJoin = NO;
    WBMyGroupModel *model = [[WBMyGroupModel alloc] init];
    if (indexPath.section == 0) {
        isJoin = YES;
        model = _joinModels[indexPath.row];
    } else {
        model = _createModels[indexPath.row];
    }
    
    
    WBGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[WBGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isJoin:isJoin];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0 && _joinModels.count == 0) || (indexPath.section == 1 && _createModels.count == 0)) {
        return;
    }
    
    WBTalkViewController *talkView = [[WBTalkViewController alloc]init];
    talkView.conversationType = ConversationType_GROUP;
    
    NSString *targetId = [NSString string];
    NSString *conversationTitle = [NSString string];
    BOOL isMaster = NO;
    if (indexPath.section == 0) {
        targetId = [NSString stringWithFormat:@"%ld",(unsigned long)((WBMyGroupModel *)_joinModels[indexPath.row]).groupId];
        conversationTitle = [NSString stringWithFormat:@"%@的帮帮团",((WBMyGroupModel *)_joinModels[indexPath.row]).nickName];
    } else {
        targetId = [NSString stringWithFormat:@"%ld",(unsigned long)((WBMyGroupModel *)_createModels[indexPath.row]).groupId];
        conversationTitle = [NSString stringWithFormat:@"%@的帮帮团",((WBMyGroupModel *)_createModels[indexPath.row]).nickName];
        isMaster = YES;
    }
    
    talkView.isMaster = isMaster;
    talkView.targetId = targetId;
    talkView.title = conversationTitle;
    [self.navigationController pushViewController:talkView animated:YES];
}

@end
