//
//  LoadViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "LoadViewController.h"
#import "RESideMenu.h"
#import "WBMainTabBarController.h"
#import "WBRegisterViewController.h"
#import "WBHomepageViewController.h"
#import "WBDataModifiedViewController.h"
#import "MyDownLoadManager.h"
#import "UIImageView+WebCache.h"

@interface LoadViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *account;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *forgotButton;
@property (nonatomic,strong) UIButton *regieterButton;

@end

@implementation LoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self createUI];
    
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([WBUserDefaults userId]) {
        NSLog(@"-----12345----");
        [self saveToUserDefault];
      //  [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void)popBack{
    [self.sideMenuViewController setContentViewController:[[WBMainTabBarController alloc] init] animated:YES];
}

- (void)createUI{
    //登陆界面
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1]];
    _account=[[UITextField alloc] initWithFrame:CGRectMake(20, 150, self.view.frame.size.width-40, 50)];
    _account.backgroundColor=[UIColor whiteColor];
    _account.placeholder=[NSString stringWithFormat:@"电话号码"];
    _account.layer.cornerRadius = 5.0f;
    _account.delegate = self;
    [self.view addSubview:_account];
    _account.tag = 50;
    
    _password=[[UITextField alloc] initWithFrame:CGRectMake(20, 210, self.view.frame.size.width-40, 50)];
    _password.backgroundColor=[UIColor whiteColor];
    _password.placeholder=[NSString stringWithFormat:@"密码"];
    _password.layer.cornerRadius = 5.0f;
    _password.delegate = self;
    [self.view addSubview:_password];
    _password.tag = 51;
    
    NSArray *nameArray = @[@"登陆",@"忘记密码?",@"注册",@"返回"];
    for (NSInteger i =0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 270+i*60, SCREENWIDTH-40, 50);
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:51/255.0 green:102/255.0 blue:255/255.0 alpha:1]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5.0f;
        button.tag = 100+i;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

#pragma mark ---按钮点击事件－－－
- (void)btnClicked:(UIButton *)btn{
   //登陆
    if (btn.tag==100) {
       // NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:_account.text forKey:@"username"];
        [parameters setValue:_password.text forKey:@"password"];
        [MyDownLoadManager postUrl:@"http://121.40.132.44:92/pt/login" withParameters:parameters whenProgress:^(NSProgress *uploadProgress) {
            
        } andSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
         //   NSLog(@"id = %@",result);
            [WBUserDefaults    setUserId:[result objectForKey:@"userId"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getRCToken" object:self];
          // [WBUserDefaults :[result objectForKey:@"token"]];
          //  [WBUserDefaults printUserDefaults];
            [self saveToUserDefault];
        } andFailure:^(NSString *error) {
            
        }];
        
       //忘记密码
    }else if (btn.tag == 101){
        
        WBDataModifiedViewController *DVC = [[WBDataModifiedViewController alloc]init];
        [self.navigationController pushViewController:DVC animated:YES];
    //注册
    }else if(btn.tag == 102){
        WBRegisterViewController *registerView = [[WBRegisterViewController alloc]init];
        [self presentViewController:registerView animated:YES completion:nil];
        //[self.navigationController pushViewController:registerView animated:YES];
    }else{
    
               
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    
    }
}


//- (void)hideViewController:(UIViewController *)viewController
//{
//    [viewController willMoveToParentViewController:nil];
//    [viewController.view removeFromSuperview];
//    [viewController removeFromParentViewController];
//}
//
//- (void)hideMenuViewControllerAnimated:(BOOL)animated
#pragma mark   ----存本地数据----

-(void)saveToUserDefault{
     NSLog(@"userInfo = %@",[WBUserDefaults userId]);
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/user/myInfo?userId=%@",[WBUserDefaults userId]] whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
       [WBUserDefaults printUserDefaults];
        NSDictionary *userInfo = [result objectForKey:@"userInfo"];
       // NSLog(@"userInfo = %@",userInfo);
        [WBUserDefaults addUserDefaultsWithDictionary:userInfo];
       // NSLog(@"-----------------------");
        [WBUserDefaults printUserDefaults];
        
        if ([[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"dir"] rangeOfString:@"http://"].location != NSNotFound) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"dir"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
              //  NSLog(@"显示当前进度");
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                NSLog(@"下载完成");
                [WBUserDefaults setHeadIcon:image];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate loadBack];
                }];
            }];
            
        }
    } andFailure:^(NSString *error) {
        
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
