//
//  WBMapViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/5/10.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
#import "WBMapBubble.h"

@interface WBMapViewController : BaseMapViewController <MapBubbleDelegate>

@property (nonatomic, copy) NSString *userNameTitle;
@property (nonatomic, strong) UIImage *titleImage;

@end
