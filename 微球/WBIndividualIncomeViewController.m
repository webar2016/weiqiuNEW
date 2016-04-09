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
    
}
@end

@implementation WBIndividualIncomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createNavi];
    [self createUI];
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
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 42+63+37+40+42+15+13+40)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-36, 42, 72, 63)];
    [headImageView setImage:[UIImage imageNamed:@"icon_coin.png"]];
    [self.view addSubview:headImageView];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-150, 42+63+37, 300, 40)];
    _moneyLabel.font = [UIFont systemFontOfSize:36];
    _moneyLabel.textColor = [UIColor initWithGreen];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLabel];
    
    
    UILabel *scoreHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42+63+37+40+42, SCREENWIDTH/2, 15)];
    scoreHeadLabel.textAlignment = NSTextAlignmentCenter;
    scoreHeadLabel.text = @"球币";
    scoreHeadLabel.font = [UIFont systemFontOfSize:18];
    scoreHeadLabel.textColor = [UIColor initWithGreen];
    [self.view addSubview:scoreHeadLabel];
    
    UILabel *withdrawHeadLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 42+63+37+40+42, SCREENWIDTH/2, 15)];
    withdrawHeadLabel.textAlignment = NSTextAlignmentCenter;
    withdrawHeadLabel.text = @"可提现";
    withdrawHeadLabel.font = [UIFont systemFontOfSize:18];
    withdrawHeadLabel.textColor = [UIColor initWithGreen];
    [self.view addSubview:withdrawHeadLabel];
    
    _scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 42+63+37+40+42+15+13, SCREENWIDTH/2, 15)];
    _scorelabel.textColor = [UIColor initWithNormalGray];
    _scorelabel.font =[UIFont systemFontOfSize:18];
    _scorelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_scorelabel];
    
    _withdrawMoneylabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 42+63+37+40+42+15+13, SCREENWIDTH/2, 15)];
    _withdrawMoneylabel.textColor = [UIColor initWithNormalGray];
    _withdrawMoneylabel.textAlignment = NSTextAlignmentCenter;
    _withdrawMoneylabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_withdrawMoneylabel];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 42+63+37+40+42+15+13+40, SCREENWIDTH/2, 50);
    [leftButton setImage:[UIImage imageNamed:@"icon_recharge.png"] forState:UIControlStateNormal];
    [leftButton setTitle:@"  充值" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"bg.png"] forState:UIControlStateNormal] ;
    rightButton.frame =CGRectMake(SCREENWIDTH/2, 42+63+37+40+42+15+13+40, SCREENWIDTH/2, 50);
    [rightButton setImage:[UIImage imageNamed:@"icon_withdraw.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"  提现" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    UILabel *tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42+63+37+40+42+15+13+100, SCREENWIDTH, 20)];
    tiplabel.text = @"微球提醒：球币大于10000时才可以提现哦！";
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor initWithGreen];
    tiplabel.font = FONTSIZE12;
    [self.view addSubview: tiplabel];
}


-(void)leftBtnClicked{
    WBReChargeViewController *RVC = [[WBReChargeViewController alloc]init];
    [self.navigationController pushViewController:RVC animated:YES];
}

-(void)rightBtnClicked{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"请到微信公众号中提现" message:@"微信搜索【微球】或【webarz】即可" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}


-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/integral/getUserIntegral?userId=%@",[WBUserDefaults userId]];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *userIntegral = result[@"userIntegral"];
        NSString *integral = [userIntegral objectForKey:@"integral"];
        
        _moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[integral floatValue]/100];
        _scorelabel.text =[NSString stringWithFormat:@"%.0f",[integral floatValue] ];
        _withdrawMoneylabel.text =[NSString stringWithFormat:@"¥%d",(int)[integral floatValue]/100];
        
    } andFailure:^(NSString *error) {
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
