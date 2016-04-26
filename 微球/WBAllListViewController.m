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
#import "JSDropDownMenu.h"
#import "WBPositionList.h"
#import "WBPositionModel.h"

#import "TopCell.h"



#import "NSString+Frame.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "MJRefresh.h"


#import  "MJExtension.h"

#define kCellReuseId @"collectionViewCellId"
#define CollectionCellWidth (SCREENWIDTH-30)/2

@interface WBAllListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CollectionGoHomePage,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
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
    
    UIButton *_locatePickBtn;
    
    CAShapeLayer *_indicator;

}

@end

@implementation WBAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    _urlString = @"http://app.weiqiu.me/hg/getHGs?p=%ld&ps=%d";
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
    
    MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
    NSArray *myCityArray = [manager searchAllItems];
    [manager closeFBDM];
    
    
    _myCityNameArray = [NSMutableArray arrayWithObject:@{@"省份":@"全部",@"城市":@"全部"}];
    WBPositionList *positionList = [[WBPositionList alloc]init];
    NSMutableArray *myTempCityArray = [NSMutableArray array];
    for (NSInteger i = 0; i<myCityArray.count; i++) {
       [myTempCityArray addObject:[positionList cityModelWithCityId:[NSNumber numberWithInteger:((WBTbl_Unlock_City *)myCityArray[i]).cityId]]];
    }
   
    WBPositionModel *myLockCityModel = [[WBPositionModel alloc]init];
    myLockCityModel.provinceName = @"我解锁过的城市";
     [_myCityNameArray addObject:@{@"省份":myLockCityModel,@"城市":myTempCityArray}];
  //  NSLog(@"%@",_myCityNameArray);
    
    
   _allCityNameArray = [NSMutableArray arrayWithObject:@{@"省份":@"全部",@"城市":@"全部"}];
    
    for (WBPositionModel *model in positionList.provinceArray) {
        [_allCityNameArray addObject:@{@"省份":model,@"城市":[positionList getCitiesListWithProvinceId:model.provinceId]}];
    }
    
    _data1 = [NSMutableArray arrayWithObjects:@"全部帮帮团", @"可加入的的帮帮团", nil];
    
    _data2 = [NSMutableArray arrayWithArray:_allCityNameArray];
  // NSLog(@"%@",_data2);
    _data3 = [NSMutableArray arrayWithObjects:@"标签", @"美食", @"佳境", @"购物", @"艳遇", @"历史", @"科技",@"人文", @"其他",@"",nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:30];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
    
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
    
    NSDictionary * tdic1 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
    CGSize  actualsize1=[_locatePickBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic1 context:nil].size;
    
    _indicator = [self createIndicatorWithColor:[UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1] andPosition:CGPointMake(SCREENWIDTH/4*3 + actualsize1.width/2 + 7, _locatePickBtn.frame.origin.y+15)];
    [self.view.layer addSublayer:_indicator];
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



-(void)loactePickBtn{
    [self animateIndicator:_indicator Forward:YES];
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]initWithPlaceStyle:AnyPlaceChoice];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate,BOOL isSelected){
        
        if (isSelected) {
            
            if (_currentData1Index == 0) {
                [self showHUD:@"正在加载" isDim:YES];
                if (locate.areaId==NULL||locate.areaId==nil) {
                    // @"http://app.weiqiu.me/hg/getHGs?p=%ld&ps=%d"
                    _urlString = @"http://app.weiqiu.me/hg/getHGs?p=%ld&ps=%d";
                }else{
                    
                    NSString *tempStr = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?cityId=%@",locate.cityId];
                    _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                    
                }
                
            }else{
                
                if (_data2MainIndex==0 &&_currentData2Index==0) {
                    NSString *tempStr = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?userId=%@",[WBUserDefaults userId]];
                    _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];

                }else{
                    NSString *tempStr = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?userId=%@&cityId=%@",[WBUserDefaults userId],locate.cityId];
                    _urlString = [tempStr stringByAppendingString:@"&p=%ld&ps=%d"];
                   
                }
            }
            [self loadData];
            [_locatePickBtn setTitle:[NSString stringWithFormat:@"位置-%@",locate] forState:UIControlStateNormal];
            NSDictionary * tdic1 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
            CGSize  actualsize1=[[NSString stringWithFormat:@"位置-%@",locate] boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic1 context:nil].size;
            NSLog(@"%f",actualsize1.width);
            [self animateIndicator:_indicator Forward:NO];
            _indicator.position =CGPointMake(SCREENWIDTH/4*3 + actualsize1.width/2 + 7, _locatePickBtn.frame.origin.y+15);
        }else{
        
          [self animateIndicator:_indicator Forward:NO];
        
        
        }
       
        
        
    };
    [addressPickerView show];
    


}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        MyCollectionViewFlowLayout * flowLayout = [[MyCollectionViewFlowLayout alloc]init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, SCREENWIDTH, self.view.frame.size.height - 64 - 30 ) collectionViewLayout:flowLayout];
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

//有一个列表
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}
// 是否需要显示为UICollectionView 默认为否
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column==2) {
        return YES;
    }
    return NO;
}
//是否需要现实两个表
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    if (column == 1) {
        return YES;
    }
    return NO;
}
/**
 * 表视图显示时，左边表显示比例
 */
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    if (column == 1) {
        return 0.4;
    }
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column==0) {
        return _currentData1Index;
        
    }
    if (column==1) {
        return _currentData2Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _data1.count;
    } else if (column==1){
        if (leftOrRight == 0) {
            return _data2.count;
        }else{
            if (leftRow==0) {
                
                return 1;
            }else{
                NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
                return [[menuDic objectForKey:@"城市"] count];
            }
            
        }
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0: return _data1[0];
            break;
        case 1: return [_data2[0] objectForKey:@"城市"];                       //    ((WBCityModel *)[[_data2[0] objectForKey:@"城市"] objectAtIndex:0]).cityName;
            break;
        case 2: return _data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return _data1[indexPath.row];
        
    } else if (indexPath.column==1) {
        
        if (indexPath.leftOrRight==0) {
            if (indexPath.row == 0) {
                NSDictionary *menuDic = [_data2 objectAtIndex:0];
                return [menuDic objectForKey:@"省份"];
            }else{
                NSDictionary *menuDic = [_data2 objectAtIndex:indexPath.row];
                return ((WBPositionModel *)[menuDic objectForKey:@"省份"]).provinceName;
            }
        } else{
            
            NSInteger leftRow = indexPath.leftRow;
            
            if (leftRow==0) {
                 NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
                return [menuDic objectForKey:@"城市"];
            }else{
            
                NSDictionary *menuDic = [_data2 objectAtIndex:leftRow];
                return  ((WBCityModel *)[[menuDic objectForKey:@"城市"] objectAtIndex:indexPath.row]).cityName;
            }
            
        }

        
    } else {
        
        return _data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        [self changeUrl];
        [self showHUD:@"正在加载" isDim:YES];
        [self loadData];
        
    } else if(indexPath.column == 1){
        
       
        
        if(indexPath.leftOrRight==0){
           
            _currentData2Index = indexPath.row;
            _data2MainIndex = indexPath.leftRow;
            
            return;
        }
        
        _currentData2Index = indexPath.row;
        _data2MainIndex = indexPath.leftRow;
        [self changeUrl];
        [self showHUD:@"正在加载" isDim:YES];
        [self loadData];
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

-(void)changeUrl{
    
    if (_currentData1Index == 0) {
       
        
        if (_data2MainIndex==0 &&_currentData2Index==0) {
           // @"http://app.weiqiu.me/hg/getHGs?p=%ld&ps=%d"
            _urlString = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?p=%ld&ps=%d",(long)_page,PAGESIZE];
            
        }else{
        
            WBPositionList *positionList = [[WBPositionList  alloc]init];
            WBPositionModel *positionModel =  positionList.provinceArray[_data2MainIndex-1];
            WBCityModel *model = [[positionList getCitiesListWithProvinceId:positionModel.provinceId] objectAtIndex:_currentData2Index];
            _urlString = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?cityId=%@*p=%ld&ps=%d",model.cityId,(long)_page,PAGESIZE];
        
        
        }
        
    }else{
        
        if (_data2MainIndex==0 &&_currentData2Index==0) {
            
            _urlString = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?userId=%@&p=%ld&ps=%d",[WBUserDefaults userId],(long)_page,PAGESIZE];
        }else{
            
            WBPositionList *positionList = [[WBPositionList  alloc]init];
            WBPositionModel *positionModel =  positionList.provinceArray[_data2MainIndex-1];
            WBCityModel *model = [[positionList getCitiesListWithProvinceId:positionModel.provinceId] objectAtIndex:_currentData2Index];
            _urlString = [NSString stringWithFormat:@"http://app.weiqiu.me/hg/getHGs?userId=%@&cityId=%@*p=%ld&ps=%d",[WBUserDefaults userId],model.cityId,(long)_page,PAGESIZE];
            
            
        }

        
       
    }



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
