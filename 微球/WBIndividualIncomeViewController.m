//
//  WBIndividualIncomeViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBIndividualIncomeViewController.h"
#import <StoreKit/StoreKit.h>
#import "MyDownLoadManager.h"
#import "WBReChargeViewController.h"

@interface WBIndividualIncomeViewController ()

{
    UILabel *_moneyLabel;
    UILabel *_scorelabel;
    UILabel *_withdrawMoneylabel;
    UIButton *_rightBtton;
}
@end

@implementation WBIndividualIncomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
- (void)loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    
//    _rightBtton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _rightBtton.frame = CGRectMake(0, 0, 60, 22) ;
//    _rightBtton.backgroundColor = [UIColor initWithGreen];
//    _rightBtton.titleLabel.font = MAINFONTSIZE;
//    _rightBtton.layer.cornerRadius = 5;
//    [_rightBtton setImage:[UIImage imageNamed:@"icon_recharge"] forState:UIControlStateNormal];
//    [_rightBtton setTitle:@" 充值" forState:UIControlStateNormal];
//    [_rightBtton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_recharge"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    
    [self createNavi];
    [self createUI];
    [self createIntroduction];
    [self loadData];
}



-(void)createNavi{
    self.navigationItem.title =@"我的收益";
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30+63+30+40+30)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-36, 30, 72, 63)];
    [headImageView setImage:[UIImage imageNamed:@"icon_coin.png"]];
    [self.view addSubview:headImageView];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-150, 30+63+30, 300, 40)];
    _moneyLabel.font = [UIFont systemFontOfSize:36];
    _moneyLabel.textColor = [UIColor initWithGreen];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 30+63+30+40+30, SCREENWIDTH, 50);
    [leftButton setTitle:@"球币使用规则" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
    leftButton.enabled = NO;
    [self.view addSubview:leftButton];
}

-(void)createIntroduction{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30+63+30+40+30+60, SCREENWIDTH, SCREENHEIGHT - 30-63-30-40-30-140)];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.font = MAINFONTSIZE;
    textView.textColor = [UIColor initWithNormalGray];
    textView.textContainerInset = UIEdgeInsetsMake(MARGININSIDE, MARGININSIDE, MARGININSIDE, MARGININSIDE);
    
    NSString *text = @"1.如何获得球币？\n        · 点击右上角【充值】按钮，即可充值！\n        · 首次登陆微球APP的小伙伴能够获得500球币的奖励。\n        · 进入其他小伙伴创建的帮帮团，并回答解决TA的问题，在帮帮团结束时你就可以获得TA的悬赏球币啦！\n        · 当你在帮帮团发表了精妙的回答、独到的见解，或者在【专题】中发布了小伙伴们喜欢的内容并获得打赏时，每个打赏可以获得5球币。\n        · 完成左侧栏中的【猜图签到】，即可获得10球币奖励。\n        · 在【解锁城市】中每成功解锁一个城市，即可获得30球币。\n\n2.怎样使用球币？\n        · 当你在旅行前或者旅行中遇到问题时，当你想要了解某个地方的风土人情时，当你想要了解某个地方的近况时……你都可以点击首页底部的【+】按钮创建一个属于你的帮帮团，发布球币悬赏，吸引小伙伴们进入你的帮帮团，帮助你解决问题。\n        · 对你喜欢的回答、专题内容，你随时都可以对它进行打赏，不要吝啬你的喜爱，毕竟每次打赏只会消耗你5个球币！\n\n3.关于球币的其他问题\n        · 小伙伴们有任何关于“球币”的问题，都可以在微球官方微信公众号（搜索“微球”或“webarz”即可）中进行咨询，同时公众号中也会有更多好玩的等着大家哦！\n        · 小伙伴们充值的球币如果未能到账，请及时联系微信公众号，微球工作人员将会积极协助您解决！\n        · “球币”是微球APP中的虚拟货币，并不等同于现实货币，无法等价交换，请所有的小伙伴注意哦！";
    
    textView.text = text;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.paragraphSpacing = 10;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    
    [textView.textStorage addAttributes:attributes range:NSMakeRange(0, textView.textStorage.length)];
    
    
    [self.view addSubview:textView];
}


-(void)rightBtnClick{
    WBReChargeViewController *RVC = [[WBReChargeViewController alloc]init];
    RVC.reloadDataBlock = ^(){
        [self loadData];
    };
    [self.navigationController pushViewController:RVC animated:YES];
}


-(void)loadData{
    [self showHUD:@"正在加载数据" isDim:YES];
    NSString *url = [NSString stringWithFormat:@"http://app.weiqiu.me/integral/getUserIntegral?userId=%@",[WBUserDefaults userId]];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *userIntegral = result[@"userIntegral"];
        NSString *integral = [userIntegral objectForKey:@"integral"];
        
        _moneyLabel.text = [NSString stringWithFormat:@"%.0f",[integral floatValue]];
        
        [self hideHUD];
    } andFailure:^(NSString *error) {
        [self showHUDComplete:@"加载失败"];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
