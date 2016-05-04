//
//  WBTopicsTableViewController.m
//  微球
//
//  Created by 徐亮 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicsTableViewController.h"
#import "MyDownLoadManager.h"
#import "WBTopicModel.h"
#import "WBTopicTableViewCell.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "WBTopicDetailViewController.h"
#import "WBAllocateScoreViewController.h"


#import "WBTestViewController.h"
#import "WBAllocateScoreViewController.h"

#import "UIColor+color.h"
#define TopCellURL @"%@/tq/getTopTopic"
#define CellURL @"%@/tq/getTopic?p=%ld&ps=%d"


@interface WBTopicsTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
        //cell的数据
    NSMutableArray *_dataList;
    //顶部cell的数据
    NSMutableArray *_dataTopList;
    //当前的页数
    NSInteger _page;
    CGFloat _beginScoller;
    
}
@end

@implementation WBTopicsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [NSMutableArray array];
    _dataTopList=[NSMutableArray array];
    self.tableView.showsVerticalScrollIndicator =YES;
    //self.tableView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
    
    [self createUI];
    
    _page=1;
    [self showHUDIndicator];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadDataCell];
}

-(void)createUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor initWithBackgroundGray];

    
    MJRefreshAutoNormalFooter *footer = [ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataCell];
    }];
    
    [footer setTitle:@"加载更多话题" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载话题" forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadDataCell];
        [footer setTitle:@"加载更多话题" forState:MJRefreshStateIdle];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
}

//加载cell的内容
-(void)loadDataCell
{
    NSString *url = [NSString stringWithFormat:CellURL,WEBAR_IP,(long)_page,PAGESIZE];

    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *tempArray = [WBTopicModel mj_objectArrayWithKeyValuesArray:result[@"topicList"]];
            if (_page == 1) {
                [_dataList removeAllObjects];
            }
            [_dataList addObjectsFromArray:tempArray];
            
            NSInteger count = tempArray.count;
            if (count <= PAGESIZE && count != 0) {
                _page++;
            }
            if (_page == 1 && count == 0) {
                [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
            } else if (_page != 1 && count == 0) {
                [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多了！" forState:MJRefreshStateIdle];
            }
            
            [self.tableView reloadData];
            [self hideHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } andFailure:^(NSString *error) {
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"网络状态不佳，请下拉重试" forState:MJRefreshStateIdle];
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@------",error);
    }];
}

//加载头部的内容
-(void) loadDataTop{
    _page = 1;
    NSString *url = [NSString stringWithFormat:TopCellURL,WEBAR_IP];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"topList"]];
            
            _dataTopList =[WBTopicModel mj_objectArrayWithKeyValuesArray:arrayList];
            
            [self loadDataCell];
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray *array = [NSMutableArray  array];
//    for (NSInteger i = 0 ; i<_dataList.count; i++) {
//        [array addObject:@" "];
//    }
//    return array;
//    //通过key来索引
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 178;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _dataTopList.count) {
        static NSString *topCellID = @"TopCell";
        WBTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        if (cell == nil)
        {   cell = [[WBTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID cellWidth:self.view.frame.size.width ];
        }
        [cell setModel:_dataTopList[indexPath.section]];
        return cell;
    }
    else{
        static NSString *cellID = @"TopicCell";
        WBTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[WBTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellWidth:self.view.frame.size.width ];
        }
        [cell setModel:_dataList[indexPath.section-_dataTopList.count]];
        return cell;
    }
}


#pragma mark --点击cell事件----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger topicId =((WBTopicModel *) _dataList[indexPath.section - _dataTopList.count]).topicId;
    WBTopicDetailViewController *DVC = [[WBTopicDetailViewController alloc]init];
    DVC.topicID = topicId;
    NSString *title = ((WBTopicModel *) _dataList[indexPath.section - _dataTopList.count]).topicContent;
    DVC.mainTitle = title;
    if (title.length > 15) {
        title = [[title substringToIndex:15] stringByAppendingString:@"…"];
    }
    DVC.navigationItem.title = title;
    [DVC setHidesBottomBarWhenPushed:YES];
    [self.parentViewController.navigationController pushViewController:DVC animated:YES];
    
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

-(void)showHUDIndicator{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.activityIndicatorColor = [UIColor blackColor];
}

-(void)hideHUD{
    [self.hud hide:YES afterDelay:0];
}




@end
