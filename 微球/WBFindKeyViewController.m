//
//  WBFindKeyViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/4.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBFindKeyViewController.h"
#import "MyDownLoadManager.h"

@interface WBFindKeyViewController ()<UITextFieldDelegate>
{
    UITextField *_telephoneField;
    UITextField *_verifyNumber;
    UITextField *_passwordField;
    UITextField *_passwordFieldAgain;
}
@end

@implementation WBFindKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavi];
    [self createUI];
}

-(void)createNavi{
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelBtn.frame = CGRectMake(10, 20, 44, 44);
    [self.view addSubview:cancelBtn];
    cancelBtn.tag = 100;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];

}

-(void)createUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"找回您的密码";
    titleLabel.textColor = [UIColor initWithGreen];
    titleLabel.font = [UIFont systemFontOfSize:32];
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
    titleLabel.frame = CGRectMake(40, 77+20, SCREENWIDTH-80, labelSize.height);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _telephoneField = [[UITextField alloc]initWithFrame:CGRectMake(30, titleLabel.frame.origin.y+titleLabel.frame.size.height+57, SCREENWIDTH-60, 43)];
    _telephoneField.placeholder = @"输入手机号";
    _telephoneField.font = MAINFONTSIZE;
    _telephoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _telephoneField.leftViewMode = UITextFieldViewModeAlways;
    _telephoneField.textColor = [UIColor initWithNormalGray];
    _telephoneField.delegate = self;
    _telephoneField.backgroundColor = [UIColor initWithBackgroundGray];
    _telephoneField.tag = 102;
    _telephoneField.layer.cornerRadius = 3.0f;
    [self.view addSubview:_telephoneField];
    _telephoneField.layer.masksToBounds=YES;
    [[_telephoneField layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _telephoneField.layer.borderWidth= 1.0f;
    
    UIButton *vertifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vertifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    vertifyButton.titleLabel.font = MAINFONTSIZE;
    vertifyButton.backgroundColor = [UIColor initWithBackgroundGray];
    [vertifyButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    vertifyButton.tag = 103;
    vertifyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    vertifyButton.frame = CGRectMake(_telephoneField.frame.size.width+30-86,titleLabel.frame.origin.y+titleLabel.frame.size.height+57, 86, 43);
    [self.view addSubview:vertifyButton];
    vertifyButton.layer.masksToBounds=YES;
    vertifyButton.layer.cornerRadius = 3;
    [[vertifyButton layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    vertifyButton.layer.borderWidth= 1.0f;
    [vertifyButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _verifyNumber = [[UITextField alloc]initWithFrame:CGRectMake(30, _telephoneField.frame.origin.y+52 , SCREENWIDTH-60, 43)];
    _verifyNumber.placeholder = @"验证码";
    _verifyNumber.backgroundColor =[UIColor initWithBackgroundGray];
    [self.view addSubview:_verifyNumber];
    _verifyNumber.font = MAINFONTSIZE;
    _verifyNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _verifyNumber.leftViewMode = UITextFieldViewModeAlways;
    [_verifyNumber setTextColor:[UIColor initWithNormalGray]];
    _verifyNumber.layer.masksToBounds=YES;
    _verifyNumber.layer.cornerRadius = 3;
    [[_verifyNumber layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _verifyNumber.layer.borderWidth= 1.0f;
    _verifyNumber.tag = 104;
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(30, _verifyNumber.frame.origin.y+52, SCREENWIDTH-60, 43)];
    [self.view addSubview:_passwordField];
    _passwordField.placeholder = @"新密码(6~14位)";
    _passwordField.backgroundColor = [UIColor initWithBackgroundGray];
    _passwordField.font = MAINFONTSIZE;
    [_passwordField setTextColor:[UIColor initWithNormalGray]];
    _passwordField.layer.masksToBounds=YES;
    _passwordField.layer.cornerRadius = 3;
    [_passwordField setSecureTextEntry:YES];
    _passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    [[_passwordField layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _passwordField.layer.borderWidth= 1.0f;
    _passwordField.tag = 105;
    
    _passwordFieldAgain =[[UITextField alloc]initWithFrame:CGRectMake(30, _passwordField.frame.origin.y+52, SCREENWIDTH-60, 43)];
    [self.view addSubview:_passwordFieldAgain];
    _passwordFieldAgain.placeholder = @"确认密码";
    _passwordFieldAgain.backgroundColor = [UIColor initWithBackgroundGray];
    _passwordFieldAgain.font = MAINFONTSIZE;
    [_passwordFieldAgain setTextColor:[UIColor initWithNormalGray]];
    _passwordFieldAgain.layer.masksToBounds=YES;
    _passwordFieldAgain.layer.cornerRadius = 3;
    [_passwordFieldAgain setSecureTextEntry:YES];
    _passwordFieldAgain.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _passwordFieldAgain.leftViewMode = UITextFieldViewModeAlways;
    [[_passwordFieldAgain layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _passwordFieldAgain.layer.borderWidth= 1.0f;
    _passwordFieldAgain.tag = 106;
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor = [UIColor initWithGreen];
    nextButton.frame = CGRectMake(30, _passwordFieldAgain.frame.origin.y+61, SCREENWIDTH-60, 43);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = MAINFONTSIZE;
    nextButton.layer.masksToBounds=YES;
    nextButton.layer.cornerRadius = 3;
    [self.view addSubview:nextButton];
    nextButton.tag = 107;
    [nextButton addTarget:self action:@selector(btnClickedConfirm) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark --------点击事件---------

-(void)btnClicked:(UIButton *)btn{
    if (btn.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (btn.tag == 103){
        //短信验证
        //判断是否注册
        // http://121.40.132.44:92/pt/checkUser?userName=15651039809
        NSString *vertifyUrl = [NSString stringWithFormat:@"http://121.40.132.44:92/pt/checkUser?userName=%@",_telephoneField.text];
        [MyDownLoadManager getNsurl:vertifyUrl whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",result);
            if ([[result objectForKey:@"error"] isEqualToString:@"1"]) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@2 forKey:@"ttl"];
                [AVOSCloud requestSmsCodeWithPhoneNumber:_telephoneField.text templateName:@"update" variables:dict callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //操作成功
                        NSLog(@"success");
                    } else {
                        NSLog(@"%@", error);
                    }
                }];
            }else{
                //可以注册
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[result objectForKey:@"该用户还没有注册"] preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        } andFailure:^(NSString *error) {
        }];
    }
}

-(void)btnClickedConfirm{
    if ([_passwordFieldAgain.text isEqual:_passwordField.text]&& _passwordField.text.length>5 &&_passwordField.text.length<15) {
        [AVOSCloud verifySmsCode:_verifyNumber.text mobilePhoneNumber:_telephoneField.text callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                //验证成功
                NSLog(@"success");
                NSDictionary *parameters = @{@"username":_telephoneField.text,@"password":_passwordField.text};
                
                [MyDownLoadManager postUrl:@"http://121.40.132.44:92/pt/updatepwd" withParameters:parameters whenProgress:^(NSProgress *uploadProgress) {
                    
                } andSuccess:^(id representData) {
                    NSLog(@"success");
                    id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"id = %@",result);
                   // [WBUserDefaults setUserId:[NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]]];
                   // [[NSNotificationCenter defaultCenter] postNotificationName:@"getRCToken" object:self];
                   // [[NSNotificationCenter defaultCenter] postNotificationName:@"getGroupInfo" object:self];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                } andFailure:^(NSString *error) {
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络出错" preferredStyle:UIAlertControllerStyleAlert];
                    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:alertView animated:YES completion:nil];
                    NSLog(@"%@",error);
                }];
            }else{
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码有误" preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                NSLog(@"failure");
            }
        }];

    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入有误" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
        
    
    }



}

//

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
