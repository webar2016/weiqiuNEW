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

typedef void (^ReloadDataBlock)(void);
@interface WBReChargeViewController : WBRefreshViewController
@property(nonatomic,copy)ReloadDataBlock reloadDataBlock;



@end
