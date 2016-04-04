//
//  LoadViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LoadViewController.h"
#import "RESideMenu.h"
#import "WBMainTabBarController.h"
#import "WBRegisterViewController.h"
#import "WBHomepageViewController.h"
#import "WBDataModifiedViewController.h"
#import "MyDownLoadManager.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

#import "WBSetInformationViewController.h"
#import "WBLeftViewController.h"
#import "WBPositionList.h"

//数据库
#import "WBBig_AreaModel.h"
#import "WBHelp_Group_Sign.h"
#import "WBTbl_Unlock_City.h"
#import "MyDBmanager.h"



@interface LoadViewController ()<UITextFieldDelegate>
{

}

@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *forgotButton;
@property (nonatomic,strong) UIButton *regieterButton;
@property (nonatomic,assign) NSInteger number;

@end

@implementation LoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _number = 0;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
    self.view.userInteractionEnabled = YES;
  //  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)]];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([WBUserDefaults userId]) {
        NSLog(@"-----12345----");
        [self saveToUserDefault];
        [self saveToDataBase];
    }
}



-(void)popBack{
    [self.sideMenuViewController setContentViewController:[[WBMainTabBarController alloc] init] animated:YES];
}

- (void)createUI{
    
    //再逛逛按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    rightBtn.frame = CGRectMake(SCREENWIDTH-60, 20, 50, 44);
    [self.view addSubview:rightBtn];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"先逛逛"];
    NSRange strRange = {0,[str length]};
    rightBtn.tag = 110;
    [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor initWithGreen] range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    //登陆界面
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"微球，\n旅游从未如此轻松";
    titleLabel.textColor = [UIColor initWithGreen];
    titleLabel.font = [UIFont systemFontOfSize:30];
    titleLabel.numberOfLines = 0;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(SCREENWIDTH-80, MAXFLOAT)];
    [self.view addSubview:titleLabel];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:20];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, titleLabel.text.length)];
    titleLabel.attributedText = attributedString;
    
    //调节高度
    CGSize labelSize = [titleLabel sizeThatFits:titleLabelSize];
    titleLabel.frame = CGRectMake(40, 80, SCREENWIDTH-80, labelSize.height);
    _account=[[UITextField alloc] initWithFrame:CGRectMake(30, 80+labelSize.height+39, SCREENWIDTH-60, 40)];
    _account.backgroundColor=[UIColor initWithBackgroundGray];
    _account.placeholder=[NSString stringWithFormat:@"手机号"];
    _account.font = MAINFONTSIZE;
    _account.layer.cornerRadius = 2.0f;
    _account.borderStyle = UITextBorderStyleNone;
    _account.delegate = self;
    _account.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _account.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_account];
    _account.layer.masksToBounds=YES;
    [[_account layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _account.layer.borderWidth= 1.0f;
    _account.tag = 50;
    _account.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 0)];
    //设置显示模式为永远显示(默认不显示)
    _account.leftViewMode = UITextFieldViewModeAlways;

    _password=[[UITextField alloc] initWithFrame:CGRectMake(30, _account.frame.origin.y+50, SCREENWIDTH-60, 40)];
    _password.backgroundColor=[UIColor initWithBackgroundGray];
    _password.placeholder=[NSString stringWithFormat:@"密码"];
    _password.layer.cornerRadius = 2.0f;
    _password.font = MAINFONTSIZE;
    _password.delegate = self;
    _password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _password.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_password];
    _password.layer.masksToBounds=YES;
    [[_password layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _password.layer.borderWidth= 1.0f;
    [_password setSecureTextEntry:YES];
    _password.tag = 51;
    _password.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 0)];
    //设置显示模式为永远显示(默认不显示)
    _password.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loadBtn.backgroundColor = [UIColor initWithGreen];
    [loadBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loadBtn.frame = CGRectMake(30, _password.frame.origin.y+60, SCREENWIDTH-60, 40);
    loadBtn.titleLabel.font = MAINFONTSIZE;
    loadBtn.tag = 102;
    [loadBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    

    NSArray *nameArray = @[@"注册账号",@"忘记密码"];
    for (NSInteger i =0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30+i*(SCREENWIDTH-60)/2, loadBtn.frame.origin.y+58, (SCREENWIDTH-60)/2, 40);
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
        button.tag = 100+i;
        button.titleLabel.font = MAINFONTSIZE;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

#pragma mark ---按钮点击事件－－－
- (void)btnClicked:(UIButton *)btn{
   //登陆
    if (btn.tag==102) {
       // NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:_account.text forKey:@"username"];
        [parameters setValue:_password.text forKey:@"password"];
        [MyDownLoadManager postUrl:@"http://121.40.132.44:92/pt/login" withParameters:parameters whenProgress:^(NSProgress *uploadProgress) {
            
        } andSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
           // NSLog(@"%@",result);
            if ([result objectForKey:@"userId"]) {
                [WBUserDefaults setUserId:[NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]]];
                [WBUserDefaults printUserDefaults];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getRCToken" object:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getGroupInfo" object:self];
                [self saveToDataBase];
                [self saveToUserDefault];
            }else{
            
                //初始化提示框；
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号或密码错误" preferredStyle: UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                
                //弹出提示框； 
                [self presentViewController:alert animated:true completion:nil];
            }
        } andFailure:^(NSString *error) {
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号或密码错误" preferredStyle: UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框； 
            [self presentViewController:alert animated:true completion:nil];
            
        }];
        
       //忘记密码
    }else if (btn.tag == 100){
        
       
        
        
        WBRegisterViewController *registerView = [[WBRegisterViewController alloc]init];
        [self presentViewController:registerView animated:YES completion:nil];

       
    //注册
    }else if(btn.tag == 101){
        
        //忘记密码
//        WBSetInformationViewController *SVC  = [[WBSetInformationViewController alloc]init];
//        [self presentViewController:SVC animated:YES completion:nil];
        
      //  WBDataModifiedViewController *DVC = [[WBDataModifiedViewController alloc]init];
      //  [self.navigationController pushViewController:DVC animated:YES];
    }else if(btn.tag == 110){
    
               
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    
    }else if (btn.tag == 111){
    
    
    }
}

#pragma mark   ----存本地数据----



//本地沙盘
-(void)saveToUserDefault{
        NSLog(@"userInfo = %@",[WBUserDefaults userId]);
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/user/myInfo?userId=%@",[WBUserDefaults userId]] whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *userInfo = [result objectForKey:@"userInfo"];
            if ([[userInfo objectForKey:@"dir"] rangeOfString:@"http://"].location != NSNotFound&&![WBUserDefaults headIcon]) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[userInfo objectForKey:@"dir"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //  NSLog(@"显示当前进度");
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    NSLog(@"下载完成");
                    [WBUserDefaults setHeadIcon:image];
                    //  NSLog(@"userInfo = %@",userInfo);
                    [WBUserDefaults addUserDefaultsWithDictionary:userInfo];
                    //存储数据库
                    [self saveData];
                }];
            }
            
            if ([[userInfo objectForKey:@"personalImage"] rangeOfString:@"http://"].location != NSNotFound) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[userInfo objectForKey:@"personalImage"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //  NSLog(@"显示当前进度");
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    NSLog(@"下载完成");
                    [WBUserDefaults setCoverImage:image];
                    //存储数据库
                    [self saveData];
                }];
            }
            
            WBPositionList *positionList =[[WBPositionList alloc] init];
            
            if ([userInfo objectForKey:@"homeCityId"]) {
                NSNumber  *cityId =[userInfo objectForKey:@"homeCityId"];
                NSString *name = [positionList cityNameWithCityId:cityId];
               [WBUserDefaults setCity:name] ;
            }
            if ([userInfo objectForKey:@"provinceId"]) {
                [WBUserDefaults setProvince:[positionList cityNameWithCityId:[userInfo objectForKey:@"provinceId"]]] ;
            }
            
            [self saveData];
            
        } andFailure:^(NSString *error) {
        }];
}




//数据库
-(void)saveToDataBase{
    NSString *unlockCityUrl = [NSString stringWithFormat:@"http://121.40.132.44:92/lr/unlockCity?userId=%@",@"29"];
        [MyDownLoadManager getNsurl:unlockCityUrl whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            NSArray *unlockCity = [WBTbl_Unlock_City mj_objectArrayWithKeyValuesArray:[result objectForKey:@"unlockCity"]];
            MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
            for (WBTbl_Unlock_City *model in unlockCity) {
                [manager  addItem:model];
            }
            NSLog(@"1 -------%@",[manager searchAllItems]);
            [manager closeFBDM];
            [self saveData];
            } andFailure:^(NSString *error) {
            }];

    NSString *helpGroupSign = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/groupSign"];
    [MyDownLoadManager getNsurl:helpGroupSign whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        NSArray *helpGroupSign = [WBHelp_Group_Sign mj_objectArrayWithKeyValuesArray:[result objectForKey:@"sign"]];
        MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Help_group_sign];
        for (WBHelp_Group_Sign *model in helpGroupSign) {
            [manager  addItem:model];
        }
        NSLog(@"2 ------%@",[manager searchAllItems]);
        [manager closeFBDM];
         [self saveData];
    } andFailure:^(NSString *error) {
    }];
        

}


-(void)saveData{
    _number++;
    if (_number == 4) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        
        
    }
}



#pragma mark  ------textfield delegate ------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
