//
//  WBAllListViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface WBAllListViewController : WBRefreshViewController
@property(strong,nonatomic)NSMutableArray *dataSource;

@end
