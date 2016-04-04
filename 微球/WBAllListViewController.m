//
//  WBAllListViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAllListViewController.h"
#import "MyDownLoadManager.h"
#import "MyCollectionViewFlowLayout.h"
#import "WBCollectionViewModel.h"
#import "WBCollectionViewCell.h"
#import "WBGetSizeOfObject.h"
#import "WBHelpGroupsDetailViewController.h"

#import "TopCell.h"



#import "NSString+Frame.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"


#import  "MJExtension.h"

#define kCellReuseId @"collectionViewCellId"
#define CollectionCellWidth (SCREENWIDTH-30)/2

@interface WBAllListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    NSInteger _page;
    NSInteger _loadImageCount;
    CGFloat _beginScoller;
    //每个cell的高度
    NSMutableArray *_cellHeightArray;

    
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WBAllListViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellHeightArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _collectionView = [self collectionView];
    [self.view addSubview:_collectionView];
    [self createMJRefresh];
    
    

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    [self showHUD:@"正在加载图片..." isDim:NO];
    _loadImageCount = 0;
    
    [self loadData];
}

-(void) createMJRefresh{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //NSLog(@"进入刷新状态后会自动调用这个block1");
        _page=1;
        [self loadData];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _collectionView.mj_header = header;
    
    _collectionView.mj_footer =[ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //  NSLog(@"进入刷新状态后会自动调用这个block2");
        _page++;
        [self loadMoreData];
        
    }];


}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        MyCollectionViewFlowLayout * flowLayout = [[MyCollectionViewFlowLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height - 20) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor initWithBackgroundGray];
       [collectionView registerClass:[WBCollectionViewCell class] forCellWithReuseIdentifier:kCellReuseId];
        collectionView.backgroundView.backgroundColor = [UIColor initWithBackgroundGray];
        return collectionView;
    }
    return _collectionView;
}


-(void)loadData
{
    _loadImageCount = 0;
    _page = 1;
    
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/getHGs?p=%ld",_page];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"helpGroup"]];
          //  NSLog(@"result=%@",result);
            [self.dataSource removeAllObjects];
            [_cellHeightArray removeAllObjects];
            
            self.dataSource =[WBCollectionViewModel mj_objectArrayWithKeyValuesArray:arrayList];
            
          //  NSLog(@"count = %@",self.dataSource);
            for (NSInteger i=0; i<self.dataSource.count; i++) {
                [_cellHeightArray addObject:((WBCollectionViewModel *)_dataSource[i]).imgRate];
            }
        }
        
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        
        [self hideHUD];

    } andFailure:^(NSString *error) {
        [_collectionView.mj_header endRefreshing];
        NSLog(@"%@------",error);
    }];
}

-(void)loadMoreData
{
    if (_loadImageCount < self.dataSource.count) {
        [_collectionView.mj_footer endRefreshing];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://www.xiaohongchun.com/api2/index/gvideo?page=%ld&release=2.0&udid=765879&cid=0",_page];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        

        
        NSLog(@"wancheng ");
        
        
       [_collectionView.mj_footer endRefreshing];
        
        
    } andFailure:^(NSString *error) {
        [_collectionView.mj_footer endRefreshing];
        NSLog(@"%@------",error);
    }];

}




#pragma mark ---collectionView代理---

#pragma mark - UICollectionViewDataSource
//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     // NSLog(@"%ld", self.dataSource.count);
    return self.dataSource.count;
  
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = kCellReuseId;
    
    WBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setModel:_dataSource[indexPath.row] imageHeight:[_cellHeightArray[indexPath.row] floatValue]*CollectionCellWidth];
      //  NSLog(@"UICollectionViewCell = %ld",indexPath.row);
    return cell;
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
  //  NSLog(@"%f",[_cellHeightArray[indexPath.row] floatValue]*CollectionCellWidth);
    return CGSizeMake((SCREENWIDTH-30)/2,[_cellHeightArray[indexPath.row] floatValue]*CollectionCellWidth+65);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WBHelpGroupsDetailViewController *DVC = [[WBHelpGroupsDetailViewController alloc]init];
    DVC.model = self.dataSource[indexPath.row];
    [DVC setHidesBottomBarWhenPushed:YES];
    DVC.imageHeight = [_cellHeightArray[indexPath.row] floatValue]*SCREENWIDTH;
    
    [self presentViewController:DVC animated:YES completion:nil];
    
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

#pragma mark - HUD

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
