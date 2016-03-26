//
//  WBFindAndHelpViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBFindAndHelpViewController.h"
#import "LoadViewController.h"
#import "RCIMClient.h"

@interface WBFindAndHelpViewController ()
{
    UIView *_tip;//小红点
    UIImage *_headIcon;
    UIButton *_leftBarButton;
    UIButton *_rightBarButton;
}
@end

@implementation WBFindAndHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unReadTip:)
                                                 name:@"unReadTip"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeNav)
                                                 name:@"changeNavIcon"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self changeNav];
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
}


-(void)createNavi{
    CGSize itemSize = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_mesg"]].frame.size;
    
    _leftBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    _leftBarButton.layer.masksToBounds = YES;
    _leftBarButton.layer.cornerRadius = itemSize.width / 2;
    _headIcon = [[UIImage alloc] init];
    if ([WBUserDefaults userId]) {
        _headIcon = [[WBUserDefaults headIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        _headIcon = [UIImage imageWithOriginal:@"icon_webar"];
    }
    [_leftBarButton setBackgroundImage:_headIcon forState:UIControlStateNormal];
    [_leftBarButton addTarget:self action:@selector(presentLeftMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBarButton];
    _rightBarButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,itemSize}];
    [_rightBarButton setImage:[UIImage imageWithOriginal:@"btn_mesg"] forState:UIControlStateNormal];
    _tip = [[UIView alloc] initWithFrame:CGRectMake(itemSize.width - 6, 0, 6, 6)];
    _tip.backgroundColor = [UIColor redColor];
    _tip.layer.masksToBounds = YES;
    _tip.layer.cornerRadius = 3;
    _tip.hidden = YES;
    [_rightBarButton addSubview:_tip];
    [_rightBarButton addTarget:self action:@selector(presentRightMenuViewController) forControlEvents:UIControlEventTouchUpInside];
    if ([WBUserDefaults userId]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
    }
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

-(void)changeNav{
    if ([WBUserDefaults userId]) {
        _headIcon = [[WBUserDefaults headIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_leftBarButton setBackgroundImage:_headIcon forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
    } else {
        _headIcon = [UIImage imageWithOriginal:@"icon_webar"];
        [_leftBarButton setBackgroundImage:_headIcon forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)presentLeftMenuViewController
{
    if ([WBUserDefaults userId]) {
        [self isFromFindView];
        [self.sideMenuViewController presentLeftMenuViewController];
    } else {
        LoadViewController *loadView = [[LoadViewController alloc]init];
        [self presentViewController:loadView animated:YES completion:nil];
    }
    
}

- (void)presentRightMenuViewController
{
    [self isFromFindView];
    [self.sideMenuViewController presentRightMenuViewController];
}

-(void)isFromFindView{
    NSLog(@"%lu",self.tabBarController.selectedIndex);
    if (self.tabBarController.selectedIndex == 0) {
        self.sideMenuViewController.isFindPage = YES;
    } else if (self.tabBarController.selectedIndex == 2) {
        self.sideMenuViewController.isFindPage = NO;
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
