//
//  WBMainTabBarController.h
//  微球
//
//  Created by 徐亮 on 16/2/24.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBMainTabBarController : UITabBarController
@property (nonatomic, assign) BOOL isGroup;
@end

@protocol CommonDelegate <NSObject>
- (void)changeBROptionsButtonLocaitonTo:(NSInteger)location animated:(BOOL)animated;
@end