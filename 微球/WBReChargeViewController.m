//
//  WBReChargeViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/4/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBReChargeViewController.h"

@interface WBReChargeViewController ()

@end

@implementation WBReChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    [self createNavi];
    [self createUI];
}

-(void)createNavi{
    self.navigationItem.title =@"我的收益";
    //设置标题
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置返回按钮
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationController.navigationBar.topItem;
    item.title = @"返回";
    self.navigationController.navigationBar.tintColor = [UIColor initWithGreen];
}

-(void)createUI{
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 18;
    if ([WBUserDefaults headIcon]) {
        _headImageView.image =[WBUserDefaults headIcon];
    }
    _nicknameLabel.text = [WBUserDefaults nickname];
    
    _contentLabel.layer.masksToBounds = YES;
    _contentLabel.layer.cornerRadius = 3;
    
    _confirmBtn.backgroundColor = [UIColor initWithGreen];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
  //  _confirmBtn
    
    


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
