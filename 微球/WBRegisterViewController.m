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

@interface WBRegisterViewController ()<UITextFieldDelegate>
{
    UITextField *_telephoneField;
    UITextField *_registerNumber;
    UIButton *_sendButton;
    UITextField *_passwordField;
   
    


}
@end

@implementation WBRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createUI];
}


-(void)createUI{
    _telephoneField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, SCREENWIDTH-40, 50)];
    _telephoneField.placeholder = @"电话号码";
    _telephoneField.delegate = self;
    _telephoneField.backgroundColor = [UIColor initWithNormalGray];
    _telephoneField.tag = 50;
    [self.view addSubview:_telephoneField];
    
    _registerNumber = [[UITextField alloc]initWithFrame:CGRectMake(20, 160, SCREENWIDTH-40-100, 50)];
    _registerNumber.placeholder = @"验证码";
    _registerNumber.backgroundColor =[UIColor initWithNormalGray];
    [self.view addSubview:_registerNumber];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.backgroundColor =[UIColor initWithNormalGray];
    [_sendButton setTitle:@"发动信息" forState:UIControlStateNormal];
    [self.view addSubview:_sendButton];
    _sendButton.frame = CGRectMake(SCREENWIDTH-100, 160, 80, 50);
    [_sendButton addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(20, 220, SCREENWIDTH-40, 50)];
    [self.view addSubview:_passwordField];
    _passwordField.placeholder = @"密码";
    _passwordField.backgroundColor = [UIColor initWithLightGray];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(20, 280, 200, 50);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnClickedConfirm) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---------btnClick----------
-(void)btnClicked{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:@2 forKey:@"ttl"];
    [AVOSCloud requestSmsCodeWithPhoneNumber:_telephoneField.text templateName:@"regist" variables:dict callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //操作成功
            NSLog(@"success");
        } else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)btnClickedConfirm{
    if (_telephoneUsed == NO) {
        [AVOSCloud verifySmsCode:_registerNumber.text mobilePhoneNumber:_telephoneField.text callback:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                //验证成功
                NSLog(@"success");
                NSDictionary *parameters = @{@"username":_telephoneField.text,@"password":_registerNumber.text};
                
                [MyDownLoadManager postUrl:@"http://121.40.132.44:92/pt/regist" withParameters:parameters whenProgress:^(NSProgress *uploadProgress) {
                    
                } andSuccess:^(id representData) {
                    NSLog(@"success");
                    id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",result);
                    
                    
                    [WBUserDefaults setUserId:[result objectForKey:@"userId"]];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getRCToken" object:self];
                    }];
                    
                    
                } andFailure:^(NSString *error) {
                    NSLog(@"%@",error);
                }];
                
            }else{
                NSLog(@"failure");
                
            }
        }];

    }
    

}

#pragma mark   ------------textfield delegate -------
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //  NSLog(@"%ld",textField.text.length);
    
    if (textField.tag ==50) {
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
