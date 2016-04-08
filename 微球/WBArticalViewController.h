//
//  WBArticalViewController.h
//  微球
//
//  Created by 徐亮 on 16/4/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBArticalViewController : WBRefreshViewController

@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *dir;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *nickname;

@end
