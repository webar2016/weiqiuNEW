//
//  WBSetInformationViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/28.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSetInformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexManBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexWomenBtn;


@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayPickLabel;


@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIButton *positionBtn;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@end
