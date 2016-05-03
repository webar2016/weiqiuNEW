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
#import "WBMyJoinViewController.h"
#import "WBAllGroupViewController.h"
#import "LoadViewController.h"

#import "UIImage+image.h"
#import "UIColor+color.h"


@interface WBHelpGroupsViewController ()<UIPageViewControllerDelegate>
{
    NSMutableArray *_vcArray;
    UIPageViewController *_pageViewController;
    UIView *_tip;//小红点
}

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) WBAllListViewController *allListView;
@property (nonatomic, strong) WBMyJoinViewController *joinUsView;

@end

@implementation WBHelpGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithGreen];
    self.navigationController.navigationBar.translucent = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    [self setUpNavgationItem];
    [self initVcArr];
    [self initPageVc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unReadGroup:)
                                                 name:@"unReadTipGroup"
                                               object:nil];
}

-(void)unReadGroup:(NSNotification*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [sender.userInfo[@"unReadGroup"] intValue];
        if (count > 0 && _tip.hidden) {
            _tip.hidden = NO;
        } else if (count == 0 && !_tip.hidden) {
            _tip.hidden = YES;
        }
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNavIcon" object:self];
    if (![WBUserDefaults userId]) {
        self.segmentedControl.selectedSegmentIndex = 0;
    }
    [self changeCurrentController:self.segmentedControl];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpNavgationItem{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UIView *segementedView = [[UIView alloc] init];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"所有",@"最近"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(changeCurrentController:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor initWithGreen];
    CGFloat segementWidth = self.view.frame.size.width;
    self.segmentedControl.frame = CGRectMake(segementWidth * 0.05, 5, segementWidth*0.5, 30);
    segementedView.frame = CGRectMake(0, 0, segementWidth*0.6, 40);
    [segementedView addSubview:self.segmentedControl];
    
    _tip = [[UIView alloc] initWithFrame:CGRectMake(segementWidth*0.54, 3, 6, 6)];
    _tip.layer.masksToBounds = YES;
    _tip.layer.cornerRadius = 3;
    _tip.hidden = YES;
    _tip.backgroundColor = [UIColor redColor];
    [segementedView addSubview:_tip];
    
    self.navigationItem.titleView = segementedView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建topics和questions控制器

-(void)initVcArr{
    _vcArray = [NSMutableArray array];
    _allListView = [[WBAllListViewController alloc]init];
    _joinUsView = [[WBMyJoinViewController alloc]init];
    [_vcArray addObject:_allListView];
    [_vcArray addObject:_joinUsView];
        
}

-(void)initPageVc{
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    //设置
    [_pageViewController setViewControllers:@[_vcArray[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

-(void)changeCurrentController:(UISegmentedControl *)segMent{
    NSInteger index=segMent.selectedSegmentIndex;
    
    if (index==0) {
        [_pageViewController setViewControllers:@[_vcArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }else{
        if (![WBUserDefaults userId]) {
            LoadViewController *loginVC = [[LoadViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        } else {
            [_pageViewController setViewControllers:@[_vcArray[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
}

@end
