//
//  WBSexViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate
- (void)setSexValue:(NSString *)value;
@end

@interface WBSexViewController : UIViewController


@property(nonatomic, retain) id<PassValueDelegate> passDelegate;


@end
