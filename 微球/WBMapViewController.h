//
//  WBMapViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/5/10.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
#import "WBIntroView.h"

@interface WBMapViewController : BaseMapViewController <CalloutViewDelegate>

@property (nonatomic, copy) NSString *userNameTitle;
@property (nonatomic, strong) UIImage *titleImage;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, assign) CLLocationCoordinate2D location;

@end
