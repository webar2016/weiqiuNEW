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
#import "WBHomepageViewController.h"

#import "TopCell.h"



#import "NSString+Frame.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"


#import  "MJExtension.h"

#define kCellReuseId @"collectionViewCellId"
#define CollectionCellWidth (SCREENWIDTH-30)/2

@interface WBAllListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CollectionGoHomePage>
{
    UICollectionView *_collectionView;
    NSInteger _page;
//    NSInteger _loadImageCount;
    CGFloat _beginScoller;
    //每个cell的高度
    NSMutableArray *_cellHeightArray;
    
//    UIImageView *_background;
}

@end

@implementation WBAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _cellHeightArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
//    _background.center = CGPointMake(SCREENWIDTH / 2, 170);
    
    _collectionView = [self collectionView];
    [self.view addSubview:_collectionView];
    [self createMJRefresh];
    [self showHUD:@"正在努力加载" isDim:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    _loadImageCount = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];;
}

-(void) createMJRefresh{
    
    MJRefreshAutoNormalFooter *footer = [ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    [footer setTitle:@"加载更多帮帮团" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载帮帮团" forState:MJRefreshStateRefreshing];
    _collectionView.mj_footer = footer;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page=1;
        [self loadData];
        [footer setTitle:@"加载更多帮帮团" forState:MJRefreshStateIdle];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _collectionView.mj_header = header;
    
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        MyCollectionViewFlowLayout * flowLayout = [[MyCollectionViewFlowLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height - 64) collectionViewLayout:flowLayout];
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
//    _loadImageCount = 0;
    
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/getHGs?p=%ld&ps=%d",(long)_page,PAGESIZE];
    
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if (_page == 1) {
            [_cellHeightArray removeAllObjects];
            [self.dataSource removeAllObjects];
        }
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *tempArray =[WBCollectionViewModel mj_objectArrayWithKeyValuesArray:result[@"helpGroup"]];
            NSInteger count = tempArray.count;
            for (NSInteger i=0; i<tempArray.count; i++) {
                [_cellHeightArray addObject:((WBCollectionViewModel *)tempArray[i]).imgRate];
                [self .dataSource addObject:tempArray[i]];
            }
            
            if (count <= PAGESIZE && count != 0) {
                _page++;
            }
            if (_page == 1 && count == 0) {
                [(MJRefreshAutoNormalFooter *)_collectionView.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
            } else if (_page != 1 && count == 0) {
                [(MJRefreshAutoNormalFooter *)_collectionView.mj_footer setTitle:@"没有更多了！" forState:MJRefreshStateIdle];
            }
        }
        
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        [self hideHUD];

    } andFailure:^(NSString *error) {
        [(MJRefreshAutoNormalFooter *)_collectionView.mj_footer setTitle:@"网络状态不佳，请下拉重试" forState:MJRefreshStateIdle];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        [self hideHUD];
        NSLog(@"%@------",error);
    }];
}

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
    cell.delegate = self;
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
    
    DVC.imageHeight = [_cellHeightArray[indexPath.row] floatValue]*SCREENWIDTH;
    //self.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:DVC animated:YES];
    
    
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

#pragma mark  ----去个人主页-----
-(void)goHomepage:(NSString *)userId{
    
    WBHomepageViewController *HVC = [[WBHomepageViewController alloc]init];
    HVC.userId = userId;
    [self.navigationController pushViewController:HVC animated:YES];


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
