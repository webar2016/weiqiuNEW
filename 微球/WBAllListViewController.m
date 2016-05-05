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
#import "AddressChoicePickerView.h"
#import "MyDBmanager.h"
#import "WBTbl_Unlock_City.h"

#import "WBPositionList.h"
#import "WBPositionModel.h"

#import "TopCell.h"
#import "WBHelpGroupMenu.h"



#import "NSString+Frame.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
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
    
    NSString *_urlString;
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSMutableArray *_myCityNameArray;
    NSMutableArray *_allCityNameArray;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _data2MainIndex;
    NSInteger _currentData3Index;
    
    UIButton *_myHelpGroupBtn;
    UIButton *_locatePickBtn;
    
    CAShapeLayer *_indicator1;
    
    CAShapeLayer *_indicator2;
    
    BOOL _isAllHelpGroup;
    AreaObject *_areaObject;
    


}

@end

@implementation WBAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?",WEBAR_IP];
    _urlString = [tempStr stringByAppendingString:@"p=%ld&ps=%d"];
    _cellHeightArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    _collectionView = [self collectionView];
    [self.view addSubview:_collectionView];
    [self createUI];
    [self createMJRefresh];
    [self showHUDIndicator];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];;
}

-(void) createMJRefresh{
    
    MJRefreshAutoNormalFooter *footer = [ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
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

-(void)createUI{
    
    _myHelpGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _myHelpGroupBtn.frame = CGRectMake(0, -0.5, SCREENWIDTH/2, 30.5);
    [self.view addSubview:_myHelpGroupBtn];
    [_myHelpGroupBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
    [_myHelpGroupBtn setTitle:@"全部帮帮团" forState:UIControlStateNormal];
    [_myHelpGroupBtn setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1] forState:UIControlStateNormal];
    _myHelpGroupBtn.layer.borderColor = [[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] CGColor];
    _myHelpGroupBtn.layer.borderWidth = 0.5;
    _myHelpGroupBtn.titleLabel.font = MAINFONTSIZE;
    [_myHelpGroupBtn addTarget:self action:@selector(helpGroupBtn) forControlEvents:UIControlEventTouchUpInside];
    _isAllHelpGroup = YES;
    
    NSDictionary * tdic1 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
    CGSize  actualsize1=[_myHelpGroupBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic1 context:nil].size;
    _indicator1 = [self createIndicatorWithColor:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1] andPosition:CGPointMake(SCREENWIDTH/4 + actualsize1.width/2 + 7, _myHelpGroupBtn.frame.origin.y+15)];
    [self.view.layer addSublayer:_indicator1];
    
    
    _locatePickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _locatePickBtn.frame = CGRectMake(SCREENWIDTH/2, -0.5, SCREENWIDTH/2, 30.5);
    [self.view addSubview:_locatePickBtn];
    [_locatePickBtn setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1]];
    [_locatePickBtn setTitle:@"位置-全部" forState:UIControlStateNormal];
    [_locatePickBtn setTitleColor:[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1] forState:UIControlStateNormal];
    _locatePickBtn.layer.borderColor = [[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1] CGColor];
    _locatePickBtn.layer.borderWidth = 0.5;
    _locatePickBtn.titleLabel.font = MAINFONTSIZE;
    [_locatePickBtn addTarget:self action:@selector(loactePickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary * tdic2 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
    CGSize  actualsize2=[_locatePickBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic2 context:nil].size;
    _indicator2 = [self createIndicatorWithColor:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1] andPosition:CGPointMake(SCREENWIDTH/4*3 + actualsize2.width/2 + 7, _locatePickBtn.frame.origin.y+15)];
    [self.view.layer addSublayer:_indicator2];
}


- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    //layer.fillColor = [[UIColor blackColor]CGColor];
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}


#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    
}

-(void)helpGroupBtn{
    
    [self animateIndicator:_indicator1 Forward:YES];
    WBHelpGroupMenu *helpMenu = [[WBHelpGroupMenu alloc]initWithHeight:_myHelpGroupBtn.frame.size.height+_myHelpGroupBtn.frame.origin.y+64];
    [helpMenu show];
    
    helpMenu.colseBlock=^{
    [self animateIndicator:_indicator1 Forward:NO];
    };
    helpMenu.block = ^(BOOL isAllHelpGroup){
        if (isAllHelpGroup) {
            [_myHelpGroupBtn setTitle:@"全部帮帮团" forState:UIControlStateNormal];
            if ([[_areaObject getId] isEqualToString:@"all"]||[_areaObject getId]==NULL) {
                NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?",WEBAR_IP];
                _urlString = [tempStr stringByAppendingString:@"p=%ld&ps=%d"];
                _page = 1;
            }else{
                NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?cityId=%@",WEBAR_IP,[_areaObject getId]];
                _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                _page = 1;
            }
        }else{
            if (![WBUserDefaults userId]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
            }
            
            
            if ([[_areaObject getId] isEqualToString:@"all"]||[_areaObject getId]==NULL) {
                NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?userId=%@",WEBAR_IP,[WBUserDefaults userId]];
                _urlString =[tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                _page = 1;
            }else{
                NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?userId=%@&cityId=%@",WEBAR_IP,[WBUserDefaults userId],[_areaObject getId]];
                _urlString =[tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                _page = 1;
            }
          [_myHelpGroupBtn setTitle:@"可加入的帮帮团" forState:UIControlStateNormal];
        }
        
        if (_isAllHelpGroup == isAllHelpGroup) {
            
        }else{
            _isAllHelpGroup = isAllHelpGroup;
            NSDictionary * tdic1 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
            CGSize  actualsize1=[_myHelpGroupBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic1 context:nil].size;
            // NSLog(@"%f",actualsize1.width);
            
            _indicator1.position =CGPointMake(SCREENWIDTH/4 + actualsize1.width/2 + 7, _myHelpGroupBtn.frame.origin.y+15);
            [self showHUD:@"正在加载" isDim:YES];
            [self loadData];
        }
        
        

    };
    

    

}


-(void)loactePickBtn{

    
    
    
    [self animateIndicator:_indicator2 Forward:YES];
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithPlaceStyle:AnyPlaceChoice];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
        
        if (isSelected) {
            [self showHUD:@"正在加载" isDim:YES];
            _areaObject = locate;
            if (_isAllHelpGroup) {
                if ([[locate getId] isEqualToString:@"all"]) {
                    NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?",WEBAR_IP];
                    _urlString = [tempStr stringByAppendingString:@"p=%ld&ps=%d"];
                    _page = 1;
                }else{
                    NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?cityId=%@",WEBAR_IP,[locate getId]];
               
                    _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
         
                    _page = 1;
                }
            }else{
                if ([[locate getId] isEqualToString:@"all"]) {
                    NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?userId=%@",WEBAR_IP,[WBUserDefaults userId]];
                    _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                    _page = 1;
                }else{
                    NSString *tempStr = [NSString stringWithFormat:@"%@/hg/getHGs?userId=%@&cityId=%@",WEBAR_IP,[WBUserDefaults userId],[locate getId]];
                    _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                    _page = 1;
                }
            }
            [self loadData];
            
            [_locatePickBtn setTitle:[NSString stringWithFormat:@"位置-%@",locate] forState:UIControlStateNormal];
            NSDictionary * tdic1 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
            CGSize  actualsize1=[[NSString stringWithFormat:@"位置-%@",locate] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic1 context:nil].size;
           // NSLog(@"%f",actualsize1.width);
            [self animateIndicator:_indicator2 Forward:NO];
            _indicator2.position =CGPointMake(SCREENWIDTH/4*3 + actualsize1.width/2 + 7, _locatePickBtn.frame.origin.y+15);
        }else{
        
          [self animateIndicator:_indicator2 Forward:NO];
        
        
        }
       
        
        
    };
    [addressPickerView show];
    


}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        MyCollectionViewFlowLayout * flowLayout = [[MyCollectionViewFlowLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, SCREENWIDTH, self.view.frame.size.height - 64 - 30) collectionViewLayout:flowLayout];
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
    
    NSLog(@"%@",_urlString);
    
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:_urlString,(long)_page,PAGESIZE] whenSuccess:^(id representData) {
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
            if (count != PAGESIZE) {
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
    WBCollectionViewModel *model = self.dataSource[indexPath.row];
    DVC.model = model;
    if (model.members >= model.maxMembers) {
        DVC.isFull = YES;
    }
    DVC.imageHeight = [_cellHeightArray[indexPath.row] floatValue]*SCREENWIDTH;
    
    
    // 隐藏tabbar
    
    DVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:DVC animated:YES];
    
   // [self presentViewController:DVC animated:YES completion:nil];
    
    
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
    HVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:HVC animated:YES];
}

#pragma mark =====tableView delegate======

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
