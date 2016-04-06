//
//  WBDataModifiedViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRefreshViewController.h"


@protocol ModefyData <NSObject>
- (void)ModefyViewDelegate;
@end


@interface WBDataModifiedViewController : WBRefreshViewController
@property (nonatomic,retain) UIDatePicker *datePicker;

@property (nonatomic,copy) NSDictionary *userInfo;



@property (nonatomic,assign)id<ModefyData>delegate;
@end