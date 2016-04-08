//
//  WBReChargeViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/4/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRefreshViewController.h"
#import <StoreKit/StoreKit.h>

@interface WBReChargeViewController : WBRefreshViewController

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn12;
@property (weak, nonatomic) IBOutlet UIButton *btn18;
@property (weak, nonatomic) IBOutlet UIButton *btn24;
@property (weak, nonatomic) IBOutlet UIButton *btn30;

@end
