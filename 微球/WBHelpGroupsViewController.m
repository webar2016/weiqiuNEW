//
//  WBHelpGroupsTableViewController.m
//  微球
//
//  Created by 徐亮 on 16/2/24.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHelpGroupsViewController.h"
#import "WBFindViewController.h"
#import "RESideMenu.h"
#import "WBAllListViewController.h"
#import "WBJoinUsViewController.h"
#import "WBMyCreateViewController.h"

#import "UIImage+image.h"
#import "UIColor+color.h"


@interface WBHelpGroupsViewController ()<UIPageViewControllerDelegate>
{
    NSMutableArray *_vcArray;//滚动式图组
    UIPageViewController *_pageViewController;
    //头部滚顶视图
    NSUInteger _prevPage;
    UIView *_tip;//小红点
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) WBAllListViewController *allListView;
@property (nonatomic, strong) WBJoinUsViewController *joinUsView;
@property (nonatomic, strong) WBMyCreateViewController *myCreateView;

@end

@implementation WBHelpGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithGreen];
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    [self setUpNavgationItem];
    [self initVcArr];
    [self initPageVc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unReadTip:)
                                                 name:@"unReadTip"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpNavgationItem{

    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"所有列表",@"我加入的",@"我创建的"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    _prevPage = 0;
    [self.segmentedControl addTarget:self action:@selector(changeCurrentController:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor initWithGreen];
    self.segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width*0.5, 30);
    self.navigationItem.titleView = self.segmentedControl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建topics和questions控制器

-(void)initVcArr{
    _vcArray = [NSMutableArray array];
    _allListView = [[WBAllListViewController alloc]init];
    _joinUsView = [[WBJoinUsViewController alloc]init];
    _myCreateView = [[WBMyCreateViewController alloc]init];
    [_vcArray addObject:_joinUsView];
    [_vcArray addObject:_allListView];
    [_vcArray addObject:_myCreateView];
        
}


-(void)initPageVc{
    
    
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    //设置
    [_pageViewController setViewControllers:@[_vcArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
}

#pragma  mark - navigation两边按钮点击事件
-(void)changeCurrentController:(UISegmentedControl *)segMent{
    NSInteger index=segMent.selectedSegmentIndex;
    
    if (index==0) {
        _prevPage = 0;
        [_pageViewController setViewControllers:@[_vcArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }else if(index==1){
        
         if(index > _prevPage){
             [_pageViewController setViewControllers:@[_vcArray[1]] direction:
             UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
         }else{
             [_pageViewController setViewControllers:@[_vcArray[1]] direction:
             UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
         }
         
    }else{
        _prevPage = 2;
       [_pageViewController setViewControllers:@[_vcArray[2]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
    }
    
    
}

#pragma mark - 小红点提醒

-(void)unReadTip:(NSNotification*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [sender.userInfo[@"unRead"] intValue];
        if (count > 0 && _tip.hidden) {
            _tip.hidden = NO;
        } else if (count == 0 && !_tip.hidden) {
            _tip.hidden = YES;
        }
    });
}

@end
