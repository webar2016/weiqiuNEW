//
//  WBLeftViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/27.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBLeftViewController.h"
#import "LoadViewController.h"
#import "WBHomepageViewController.h"
#import "WBGuessViewController.h"
#import "CreateHelpGroupViewController.h"
#import "WBSettingViewController.h"
#import "WBIndividualIncomeViewController.h"


#define NAVIGATION_CONTROLLERS self.parentViewController.childViewControllers.lastObject.childViewControllers
#define IS_FIND_PAGE self.sideMenuViewController.isFindPage

@interface WBLeftViewController ()<BackDelegate>
@property (strong, readwrite, nonatomic) UIView *userInfosView;
@property (strong, readwrite, nonatomic) UIView *userScoreView;
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, readwrite, nonatomic) UIButton *loginBtn;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) BOOL isLogin;
@end

@implementation WBLeftViewController

-(CGSize)size{
    return [[UIScreen mainScreen] bounds].size;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithLightGray];
    [self setUpUserInfos];
    [self setUpScores];
    [self setUpSelections];
}

#pragma mark - setUpSubviews

-(void)setUpUserInfos{
    
    self.userInfosView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 110)];
    self.userInfosView.backgroundColor = [UIColor initWithDarkGray];
    
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 50, 50)];
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.cornerRadius = 25.0;
    _userIcon.contentMode = UIViewContentModeScaleAspectFill;
    _userIcon.image = [WBUserDefaults headIcon];
    [self.userInfosView addSubview:_userIcon];
    
    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, (self.size.width*0.7-100), 15)];
    _nickName.textColor = [UIColor whiteColor];
    _nickName.font = MAINFONTSIZE;
    _nickName.text = [WBUserDefaults nickname];
    [self.userInfosView addSubview:_nickName];
    
    _profile = [[UITextView alloc] initWithFrame:CGRectMake(95, 45, (self.size.width*0.7-100), 60)];
    _profile.backgroundColor = [UIColor clearColor];
    _profile.textColor = [UIColor whiteColor];
    _profile.font = MAINFONTSIZE;
    _profile.text = [WBUserDefaults profile];
    [self.userInfosView addSubview:_profile];
    
    [self.view addSubview:self.userInfosView];
}

-(void)setUpScores{
    self.userScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, self.size.width, self.size.height * 0.14)];
    _userScoreView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(IncomeBtnClicked)];
    [_userScoreView addGestureRecognizer:tap];
    self.userScoreView.backgroundColor = [UIColor initWithDarkGray];
    
    UILabel *totalScore = [[UILabel alloc] initWithFrame:CGRectMake(30, self.size.height * 0.02, 60, self.size.height * 0.04)];
    totalScore.textColor = [UIColor whiteColor];
    totalScore.text = @"总收益";
    totalScore.font = MAINFONTSIZE;
    
    _totalScoreNumber = [[UILabel alloc] initWithFrame:CGRectMake(100, self.size.height * 0.02, (self.size.width*0.7-100), self.size.height * 0.04)];
    _totalScoreNumber.textColor = [UIColor whiteColor];
    _totalScoreNumber.text = @"22222球票";
    _totalScoreNumber.font = MAINFONTSIZE;
    
    [self.userScoreView addSubview:totalScore];
    [self.userScoreView addSubview:_totalScoreNumber];
    
    UILabel *todayScore = [[UILabel alloc] initWithFrame:CGRectMake(30, self.size.height * 0.08, 60, self.size.height * 0.04)];
    todayScore.textColor = [UIColor whiteColor];
    todayScore.text = @"今日收益";
    todayScore.font = MAINFONTSIZE;
    
    _todayScoreNumber = [[UILabel alloc] initWithFrame:CGRectMake(100, self.size.height * 0.08, (self.size.width*0.7-100), self.size.height * 0.04)];
    _todayScoreNumber.textColor = [UIColor whiteColor];
    _todayScoreNumber.text = @"22222球票";
    _todayScoreNumber.font = MAINFONTSIZE;

    [self.userScoreView addSubview:todayScore];
    [self.userScoreView addSubview:_todayScoreNumber];
    
    [self.view addSubview:self.userScoreView];
}

-(void)setUpSelections{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, self.size.height * 0.14 + 140, self.view.frame.size.width, 45 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -----Income -------
-(void)IncomeBtnClicked{
    //NSLog(@"------income------");
    [self.sideMenuViewController hideMenuViewController];
    WBIndividualIncomeViewController *IVC = [[WBIndividualIncomeViewController alloc]init];
    [IVC setHidesBottomBarWhenPushed:YES];
    [self pushViewControllerWithController:IVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    switch (indexPath.row) {
        case 0:{
            WBHomepageViewController *homepageVC = [[WBHomepageViewController alloc] init];
            [homepageVC setHidesBottomBarWhenPushed:YES];
            [self pushViewControllerWithController:homepageVC];
            break;
        }
            
        case 1:{
            WBGuessViewController *guessVC = [[WBGuessViewController alloc] init];
            guessVC.hidesBottomBarWhenPushed = YES;
            [self pushViewControllerWithController:guessVC];
            break;
        }
            
        case 2:{
            CreateHelpGroupViewController *unlockVC = [[CreateHelpGroupViewController alloc] init];
            unlockVC.fromSlidePage = YES;
            unlockVC.hidesBottomBarWhenPushed = YES;
            [self pushViewControllerWithController:unlockVC];
            break;
        }
            
        case 3:{
            WBSettingViewController *settingVC = [[WBSettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self pushViewControllerWithController:settingVC];
            break;
        }
    }
}

-(void)pushViewControllerWithController:(UIViewController *)vc{
    NSLog(@"%d",IS_FIND_PAGE);
    if (IS_FIND_PAGE == YES) {
        [NAVIGATION_CONTROLLERS.firstObject pushViewController:vc animated:YES];
    }else{
        [NAVIGATION_CONTROLLERS.lastObject pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = MAINFONTSIZE;
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"个人主页", @"猜图签到", @"快速解锁", @"设置"];
    NSArray *images = @[@"icon_personalcenter", @"icon_checkin", @"icon_unclock", @"icon_setting"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

#pragma mark  -----loadView delegate -----
- (void)loadBack{
    if ([WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]) {
        WBHomepageViewController *homepageVC = [[WBHomepageViewController alloc] init];
        homepageVC.friendId =[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"];
        [homepageVC setHidesBottomBarWhenPushed:YES];
        
        [self pushViewControllerWithController:homepageVC];
    }
}

@end
