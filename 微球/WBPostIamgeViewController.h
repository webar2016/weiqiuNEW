//
//  WBPostIamgeViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRefreshViewController.h"


typedef void (^ReloadDataBlock)(void);

@interface WBPostIamgeViewController : WBRefreshViewController
@property (nonatomic,assign) NSInteger topicID;

//- (void) reloadData: (ReloadDataBlock)block;
@property (nonatomic,strong)ReloadDataBlock reloadDataBlock;

@end
