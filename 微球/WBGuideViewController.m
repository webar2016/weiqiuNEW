//
//  WBGuideViewController.m
//  微球
//
//  Created by 徐亮 on 16/5/6.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGuideViewController.h"
#import "WBLeftViewController.h"
#import "WBRightViewController.h"
#import "WBMainTabBarController.h"

@interface WBGuideViewController () <UIScrollViewDelegate>

@property (strong,nonatomic) WBLeftViewController *leftViewController;
@property (strong,nonatomic) WBRightViewController *rightViewController;
@property (strong,nonatomic) WBMainTabBarController *mainTabBarController;
@property (strong,nonatomic) RESideMenu *sideMenuViewController;

@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;
@end

@implementation WBGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置关闭引导页后的页面
    [self setMainView];
    
    //设置引导页
    [self setGuideView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.pageControl.numberOfPages = 5;
    self.pageControl.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT - 20);
    self.pageControl.currentPageIndicatorTintColor = [UIColor initWithGreen];
    self.pageControl.pageIndicatorTintColor = [UIColor initWithBackgroundGray];
    [self.view addSubview: self.pageControl];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)setMainView{
    self.mainTabBarController = [[WBMainTabBarController alloc] init];
    self.leftViewController = [[WBLeftViewController alloc]init];
    self.rightViewController = [[WBRightViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE)] collectionConversationType:nil];
    
    
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.mainTabBarController
                                                             leftMenuViewController:self.leftViewController
                                                            rightMenuViewController:self.rightViewController];
    self.sideMenuViewController.contentViewShadowEnabled = YES;
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(4, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0.4f;
    self.sideMenuViewController.contentViewShadowRadius = 5.0f;
    self.sideMenuViewController.panGestureEnabled = NO;
    self.sideMenuViewController.contentViewInPortraitOffsetCenterX = 120;
}

- (void)setGuideView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview: self.scrollView];
    
    NSString *imageSize = [NSString string];
    imageSize = SCREENHEIGHT <= 480.f ? @"Small" : @"Huge";
    
    for (NSInteger i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + SCREENWIDTH * i, 0, SCREENWIDTH, SCREENHEIGHT)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%@_0%d",imageSize,(int)i + 1]];
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview: imageView];
        
        if (i < 4) {
            UIButton *skip = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
            skip.center = CGPointMake(SCREENWIDTH - 40, 30);
            [skip setBackgroundImage:[UIImage imageNamed:@"GuidePage_skip_icon"] forState:UIControlStateNormal];
            [skip addTarget:self action:@selector(enterMainView) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:skip];
        } else {
            UIButton *enter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
            enter.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT - 80);
            [enter setBackgroundImage:[UIImage imageNamed:@"GuidePage_into_icon"] forState:UIControlStateNormal];
            [enter setBackgroundImage:[UIImage imageNamed:@"GuidePage_into_icon_selected"] forState:UIControlStateHighlighted];
            [enter addTarget:self action:@selector(enterMainView) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enter];
        }
    }
    self.scrollView.contentSize = CGSizeMake(SCREENWIDTH * 5, SCREENHEIGHT);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
}

- (void)enterMainView{
    self.window.rootViewController = self.sideMenuViewController;
    [self.window makeKeyAndVisible];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffset = fabs(scrollView.contentOffset.x + SCREENWIDTH / 2);
    self.pageControl.currentPage = contentOffset / SCREENWIDTH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
