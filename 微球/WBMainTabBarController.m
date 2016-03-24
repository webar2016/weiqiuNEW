//
//  WBMainTabBarController.m
//  微球
//
//  Created by 徐亮 on 16/2/24.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMainTabBarController.h"
#import "WBNavigationController.h"
#import "BROptionsButton.h"
#import "RESideMenu.h"
#import "WBFindViewController.h"
#import "WBHelpGroupsViewController.h"
#import "CreateHelpGroupViewController.h"

#import "RCIMClient.h"

#import "UIImage+image.h"
#import "UIColor+color.h"



@interface WBMainTabBarController ()<BROptionButtonDelegate, CommonDelegate, UITabBarControllerDelegate>
@property (nonatomic, strong) BROptionsButton *brOptionsButton;

@property (nonatomic, strong) CreateHelpGroupViewController *createHelpGroupViewController;

@property (nonatomic, strong) UIView *badgeView;

@end

@implementation WBMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.isGroup = NO;
    
    //发现界面
    WBFindViewController *findController = [[WBFindViewController alloc] init];
    WBNavigationController *findNavController = [[WBNavigationController alloc]initWithRootViewController:findController];
    [self setTabBarWithViewController:findController title:@"发现" imageName:@"icon_find_normal" selectedImageName:@"icon_find_selected"];
    
    //中间多选按钮组件
    self.createHelpGroupViewController = [[CreateHelpGroupViewController alloc]init];
    WBNavigationController *createNavController = [[WBNavigationController alloc]initWithRootViewController:self.createHelpGroupViewController];
    
    //帮帮团
    WBHelpGroupsViewController *helpGroupsController = [[WBHelpGroupsViewController alloc] init];
    WBNavigationController *helpGroupsNavController = [[WBNavigationController alloc]initWithRootViewController:helpGroupsController];
    [self setTabBarWithViewController:helpGroupsController title:@"帮帮团" imageName:@"icon_helpergroup_normal" selectedImageName:@"icon_helpergroup_selected"];
    
    self.viewControllers = @[findNavController,createNavController,helpGroupsNavController];
    
    //设置第二个界面
    self.createHelpGroupViewController.commonDelegate = self;
    self.createHelpGroupViewController.hidesBottomBarWhenPushed = YES;
    // Do any additional setup after loading the view.
    BROptionsButton *brOption = [[BROptionsButton alloc] initWithTabBar:self.tabBar forItemIndex:1 delegate:self];
    
    self.brOptionsButton = brOption;
    brOption.backgroundColor = [UIColor clearColor];
    [brOption setImage:[UIImage imageNamed:@"btn_add"] forBROptionsButtonState:BROptionsButtonStateNormal];
    [brOption setImage:[UIImage imageNamed:@"btn_cancel"] forBROptionsButtonState:BROptionsButtonStateOpened];
    
    self.tabBar.opaque = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor initWithLightGray];
    [self.tabBar insertSubview:bgView atIndex:0];
    
    //提示小红点
    self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.88, 5, 6, 6)];
    self.badgeView.layer.masksToBounds = YES;
    self.badgeView.layer.cornerRadius = 3;
    self.badgeView.backgroundColor = [UIColor redColor];
    [self.tabBar addSubview:self.badgeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(unReadGroup:)
                                                 name:@"unReadTipGroup"
                                               object:nil];
}

-(void)unReadGroup:(NSNotification*)sender{
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [sender.userInfo[@"unReadGroup"] intValue];
        if (count > 0 && __weakSelf.badgeView.hidden) {
            __weakSelf.badgeView.hidden = NO;
        } else if (count == 0 && !__weakSelf.badgeView.hidden) {
            __weakSelf.badgeView.hidden = YES;
        }
    });
}

#pragma mark - 设置tabbaritem
-(void)setTabBarWithViewController:(UIViewController *)viewController title:(NSString *)title imageName:(NSString *)image selectedImageName:(NSString *)selectedImage{
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageWithOriginal:image];
    viewController.tabBarItem.selectedImage = [UIImage imageWithOriginal:selectedImage];
    NSMutableDictionary *textAttr = [[NSMutableDictionary alloc] init];
    textAttr[NSForegroundColorAttributeName] = [UIColor initWithNormalGray];
    [viewController.tabBarItem setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    NSMutableDictionary *textSeceledAttr = [[NSMutableDictionary alloc] init];
    textSeceledAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [viewController.tabBarItem setTitleTextAttributes:textSeceledAttr forState:UIControlStateSelected];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (self.selectedIndex != 1) {
        self.isGroup = !self.isGroup;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BROptionsButtonState

- (NSInteger)brOptionsButtonNumberOfItems:(BROptionsButton *)brOptionsButton {
    return 1;
}

- (UIImage*)brOptionsButton:(BROptionsButton *)brOptionsButton imageForItemAtIndex:(NSInteger)index {
    UIImage *image = [UIImage imageNamed:@"btn_helpgroup"];
    return image;
}


- (void)brOptionsButton:(BROptionsButton *)brOptionsButton didSelectItem:(BROptionItem *)item {
    [self setSelectedIndex:brOptionsButton.locationIndexInTabBar];
}

#pragma mark - CommonDelegate

- (void)changeBROptionsButtonLocaitonTo:(NSInteger)location animated:(BOOL)animated {
    if(location < self.tabBar.items.count) {
        [self.brOptionsButton setLocationIndexInTabBar:location animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"wrong index" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}




@end
