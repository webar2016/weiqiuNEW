//
//  WBMapIntroduceViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/5/20.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "WBRefreshViewController.h"

@interface WBMapIntroduceViewController : WBRefreshViewController

@property (weak, nonatomic) IBOutlet UILabel *sceneryNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *datePick;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) NSString *sceneryName;
@property (nonatomic, copy) NSString *sceneryId;
@property (nonatomic, copy) NSString *cityId;

@end
