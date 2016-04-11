//
//  WBRegisterViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/14.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBRegisterViewController.h"
#import "MyDownLoadManager.h"
#import "WBDataModifiedViewController.h"
#import "WBSetInformationViewController.h"

@interface WBRegisterViewController ()<UITextFieldDelegate,UITextInputTraits>
{
    UITextField *_telephoneField;
    UITextField *_registerNumber;
    UIButton *_sendButton;
    UITextField *_passwordField;
   
    


}
@end

@implementation WBRegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([WBUserDefaults userId]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)]];
    [self createUI];
}

-(void)viewClicked{
    [_telephoneField resignFirstResponder];
    [_registerNumber resignFirstResponder];
    [_passwordField resignFirstResponder];
}


-(void)createUI{
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelBtn.frame = CGRectMake(10, 20, 44, 44);
    [self.view addSubview:cancelBtn];
    cancelBtn.tag = 100;
    [cancelBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
//    //再逛逛按钮
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    rightBtn.frame = CGRectMake(SCREENWIDTH-60, 20, 50, 44);
//    [self.view addSubview:rightBtn];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"先逛逛"];
//    NSRange strRange = {0,[str length]};
//    rightBtn.tag = 101;
//    [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor initWithGreen] range:strRange];
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
    //登陆界面
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"欢迎加入微球";
    titleLabel.textAlignment = NSTextAlignmentCenter;
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
    _telephoneField.keyboardType = UIKeyboardTypeNumberPad;
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
    //    [_sendButton addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _registerNumber = [[UITextField alloc]initWithFrame:CGRectMake(30, _telephoneField.frame.origin.y+52 , SCREENWIDTH-60, 43)];
    _registerNumber.placeholder = @"验证码";
    _registerNumber.backgroundColor =[UIColor initWithBackgroundGray];
    [self.view addSubview:_registerNumber];
    _registerNumber.font = MAINFONTSIZE;
    _registerNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _registerNumber.leftViewMode = UITextFieldViewModeAlways;
    [_registerNumber setTextColor:[UIColor initWithNormalGray]];
    _registerNumber.layer.masksToBounds=YES;
    _registerNumber.layer.cornerRadius = 3;
    _registerNumber.delegate = self;
    _registerNumber.keyboardType = UIKeyboardTypeNumberPad;
    [[_registerNumber layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _registerNumber.layer.borderWidth= 1.0f;
    _registerNumber.tag = 104;
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(30, _registerNumber.frame.origin.y+52, SCREENWIDTH-60, 43)];
    [self.view addSubview:_passwordField];
    _passwordField.placeholder = @"密码(6~14位)";
    _passwordField.backgroundColor = [UIColor initWithBackgroundGray];
    _passwordField.font = MAINFONTSIZE;
    [_passwordField setTextColor:[UIColor initWithNormalGray]];
    _passwordField.layer.masksToBounds=YES;
    _passwordField.layer.cornerRadius = 3;
    _passwordField.returnKeyType = UIReturnKeyDone;
    [_passwordField setSecureTextEntry:YES];
    _passwordField.delegate = self;
    _passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    [[_passwordField layer] setBorderColor:[[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor]];
    _passwordField.layer.borderWidth= 1.0f;
    _passwordField.tag = 105;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor = [UIColor initWithGreen];
    nextButton.frame = CGRectMake(30, _passwordField.frame.origin.y+61, SCREENWIDTH-60, 43);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = MAINFONTSIZE;
    nextButton.layer.masksToBounds=YES;
    nextButton.layer.cornerRadius = 3;
    [self.view addSubview:nextButton];
    nextButton.tag = 106;
    [nextButton addTarget:self action:@selector(btnClickedConfirm) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---------btnClick----------


-(void)btnClickedConfirm{
    [self viewClicked];
    if (_telephoneUsed == NO) {
        [self showHUD:@"正在注册" isDim:YES];
        [AVOSCloud verifySmsCode:_registerNumber.text mobilePhoneNumber:_telephoneField.text callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                //验证成功
                NSLog(@"success");
                NSDictionary *parameters = @{@"username":_telephoneField.text,@"password":_registerNumber.text};
                
                [MyDownLoadManager postUrl:@"http://121.40.132.44:92/pt/regist" withParameters:parameters whenProgress:^(NSProgress *uploadProgress) {
                    
                } andSuccess:^(id representData) {
                    NSLog(@"success");
                    id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                    [WBUserDefaults setUserId:[NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]]];
                    [WBUserDefaults setNickname:_telephoneField.text];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getRCToken" object:self];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getGroupInfo" object:self];
                    WBSetInformationViewController *SVC = [[WBSetInformationViewController alloc]init];
                    [self presentViewController:SVC animated:YES completion:nil];
                    [self showHUDComplete:@"注册成功"];
                } andFailure:^(NSString *error) {
                    NSLog(@"%@",error);
                    [self showHUDComplete:@"注册失败"];
                }];
            }else{
                NSLog(@"failure");
                [self showHUDComplete:@"验证码验证失败"];
            }
        }];
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"该号码已经注册" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

-(void)btnClicked:(UIButton *)btn{
    [self viewClicked];
    if (btn.tag==100) {
        //取消
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (btn.tag ==101){
    //先逛逛
        NSLog(@"------");
        
    
    }else if (btn.tag == 103){
        //短信验证
        //判断是否注册
        [self showHUD:@"正在发送验证码" isDim:YES];
        UIButton *button = (UIButton *)[self.view viewWithTag:103];
        [button setEnabled:NO];
       // http://121.40.132.44:92/pt/checkUser?userName=15651039809
        NSString *vertifyUrl = [NSString stringWithFormat:@"http://121.40.132.44:92/pt/checkUser?userName=%@",_telephoneField.text];
        [MyDownLoadManager getNsurl:vertifyUrl whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",result);
            if ([[result objectForKey:@"error"] isEqualToString:@"1"]) {
                
                [button setEnabled:YES];
                [self showHUDComplete:[result objectForKey:@"msg"]];
//                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[result objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//
//                
//                [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }]];
//                [self presentViewController:alertView animated:YES completion:nil];
                
                
            }else{
                //可以注册
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@2 forKey:@"ttl"];
                [AVOSCloud requestSmsCodeWithPhoneNumber:_telephoneField.text templateName:@"regist" variables:dict callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //操作成功
                        NSLog(@"success");
                        [self showHUDComplete:@"发送验证码请求成功"];
                    } else {
                        NSLog(@"%@", error);
                        [self showHUDComplete:@"发送验证码请求失败"];
                        [button setEnabled:YES];
                    }
                }];
            }
        } andFailure:^(NSString *error) {
            [self showHUDComplete:@"发送验证码请求失败"];
            [button setEnabled:YES];
            [self hideHUD];
        }];
    }
}


#pragma mark   ------------textfield delegate -------
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //  NSLog(@"%ld",textField.text.length);
    
    if (textField.tag ==104) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        
       
        if (strLength==11) {
            NSLog(@"=------textfield -------%@",textField.text);
            
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/pt/checkUser?userName=%@%@",textField.text,string] whenSuccess:^(id representData) {
                
                id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                if ([result[@"error"] isEqualToString:@"1"]) {
                    _telephoneUsed = YES;
                    //初始化提示框；
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",result[@"msg"]] preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                    }]];
                    
                    //弹出提示框；
                    [self presentViewController:alert animated:true completion:nil];
                    
                    
                }else{
                    
                    _telephoneUsed = NO;
                    
                }
                
            } andFailure:^(NSString *error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"消息发送失败" preferredStyle:  UIAlertControllerStyleAlert];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
                
                
            }];
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -100,SCREENWIDTH,self.view.frame.size.height);;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 0,SCREENWIDTH,self.view.frame.size.height);;
    [UIView commitAnimations];
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
