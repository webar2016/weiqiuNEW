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
#define TopCellURL @"http://121.40.132.44:92/tq/getTopTopic"
#define CellURL @"http://121.40.132.44:92/tq/getTopic?p=%ld&ps=%d"


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
    //数据初始化
    _dataList = [NSMutableArray array];
    _dataTopList=[NSMutableArray array];
    //创建UI
    [self createUI];
    //缓冲标志
    [self showHUD:@"正在加载图片..." isDim:NO];
    //加载数据
    [self loadDataCell];
}

-(void)createUI{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor initWithBackgroundGray];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //NSLog(@"进入刷新状态后会自动调用这个block1");
        _page=1;
        [self loadDataCell];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;

    self.tableView.mj_header = header;

    self.tableView.mj_footer =[ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
      //  NSLog(@"进入刷新状态后会自动调用这个block2");
        _page++;
        [self loadMoreData];

    }];
}


//加载cell的内容
-(void)loadDataCell
{
    _page = 1;
    NSString *url = [NSString stringWithFormat:CellURL,(long)_page,PAGESIZE];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"topicList"]];
            
            _dataList =[WBTopicModel mj_objectArrayWithKeyValuesArray:arrayList];
            [self.tableView reloadData];
            [self hideHUD];
            [self.tableView.mj_header endRefreshing];
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

//加载头部的内容
-(void) loadDataTop{
    _page = 1;
    NSString *url = [NSString stringWithFormat:TopCellURL];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"topList"]];
            
            _dataTopList =[WBTopicModel mj_objectArrayWithKeyValuesArray:arrayList];
            
          //  NSLog(@"number = %@",_dataTopList);
            [self loadDataCell];
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

-(void)loadMoreData{

    NSString *url = [NSString stringWithFormat:CellURL,(long)_page,PAGESIZE];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"result = %@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"topicList"]];
            NSMutableArray *tempArray = [NSMutableArray array];
            tempArray =[WBTopicModel mj_objectArrayWithKeyValuesArray:arrayList];
           // NSLog(@"tempArray = %@",tempArray);
            
            for (WBTopicModel *model  in tempArray) {
             //   NSLog(@"qwertrty%@",model);
                [_dataList addObject:model];
               
            }
          //   NSLog(@"dsfdsfsdf%@",_dataList);
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"%lu", (unsigned long)_dataList.count);
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
        [cell setModel:_dataTopList[indexPath.row]];
        return cell;

    }
    else{
        static NSString *cellID = @"TopicCell";
        WBTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {   cell = [[WBTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellWidth:self.view.frame.size.width ];
        
        }
       

        [cell setModel:_dataList[indexPath.row-_dataTopList.count]];
        return cell;
    }

}


#pragma mark --点击cell事件----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        NSInteger topicId =((WBTopicModel *) _dataList[indexPath.row - _dataTopList.count]).topicId;
        // NSLog(@"%d",topicId);
        WBTopicDetailViewController *DVC = [[WBTopicDetailViewController alloc]init];
        DVC.topicID = topicId;
        [DVC setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:DVC animated:YES];

//        WBTestViewController *TVC = [[WBTestViewController alloc]init];
//        [self.navigationController pushViewController:TVC animated:YES];
    }else if (indexPath.row ==1){
    
        NSInteger topicId =((WBTopicModel *) _dataList[indexPath.row - _dataTopList.count]).topicId;
        // NSLog(@"%d",topicId);
        WBTopicDetailViewController *DVC = [[WBTopicDetailViewController alloc]init];
        DVC.topicID = topicId;
        [DVC setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:DVC animated:YES];
//        WBAllocateScoreViewController *AVC = [[WBAllocateScoreViewController alloc]init];
//        [self.navigationController pushViewController:AVC animated:YES];
    
    
    }
    else{
        NSInteger topicId =((WBTopicModel *) _dataList[indexPath.row - _dataTopList.count]).topicId;
       // NSLog(@"%d",topicId);
        WBTopicDetailViewController *DVC = [[WBTopicDetailViewController alloc]init];
        DVC.topicID = topicId;
        [DVC setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:DVC animated:YES];
    }
    
    //WBTopicDetailViewController *DVC = [[WBTopicDetailViewController alloc]init];
    
    //[self.view.window.rootViewController presentViewController:DVC animated:YES completion:nil];

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
