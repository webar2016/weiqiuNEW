//
//  WBFindTableViewController.m
//  微球
//
//  Created by 徐亮 on 16/2/24.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBFindViewController.h"
#import "RESideMenu.h"
#import "WBTopicsTableViewController.h"
#import "WBQuestionsViewController.h"
#import "WBLeftViewController.h"
#import "RCIMClient.h"

#import "UIImage+image.h"

@interface WBFindViewController ()<UIPageViewControllerDelegate>
{
    NSMutableArray *_vcArray;//滚动式图组
    UIPageViewController *_pageViewController;
    //头部滚顶视图
    UIView *_tip;//小红点
}


@property (nonatomic, strong) WBTopicsTableViewController *topicsController;
@property (nonatomic, strong) WBQuestionsViewController *questionsController;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation WBFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unReadTip:)
                                                 name:@"unReadTip"
                                               object:nil];
    
    self.view.backgroundColor = [UIColor initWithGreen];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    self.navigationController.navigationBar.translucent = NO;
    [self setUpNavgationItem];
    [self initVcArr];
    [self initPageVc];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建navigation头部

-(void)setUpNavgationItem{
    CGSize itemSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_mesg"]].frame.size;
    
    UIButton *leftBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    [leftBarButtonItem setBackgroundImage:[UIImage imageWithOriginal:@"icon_webar"] forState:UIControlStateNormal];
    [leftBarButtonItem addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonItem];
    
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,itemSize}];
    [rightBarButton setImage:[UIImage imageWithOriginal:@"btn_mesg"] forState:UIControlStateNormal];
    _tip = [[UIView alloc] initWithFrame:CGRectMake(itemSize.width - 6, 0, 6, 6)];
    _tip.backgroundColor = [UIColor redColor];
    _tip.layer.masksToBounds = YES;
    _tip.layer.cornerRadius = 3;
    _tip.hidden = YES;
    [rightBarButton addSubview:_tip];
    [rightBarButton addTarget:self action:@selector(presentRightMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"话题",@"问题"]];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(changeCurrentController:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor initWithGreen];
    self.segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width*0.5, 30);
    self.navigationItem.titleView = self.segmentedControl;
}

- (void)presentLeftMenuViewController
{
    self.sideMenuViewController.isFindPage = YES;
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)presentRightMenuViewController
{
    self.sideMenuViewController.isFindPage = YES;
    [self.sideMenuViewController presentRightMenuViewController];
}

#pragma mark - 创建topics和questions控制器

-(void)initVcArr{
    _vcArray = [NSMutableArray array];
    _topicsController = [[WBTopicsTableViewController alloc]init];
    _questionsController = [[WBQuestionsViewController alloc]init];
    _questionsController.fromFindView = YES;
    
    [_vcArray addObject:_topicsController];
    [_vcArray addObject:_questionsController];
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
        [_pageViewController setViewControllers:@[_vcArray[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }else{
        [_pageViewController setViewControllers:@[_vcArray[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
