//
//  WBPlaceChooseViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassPositionDelegate
- (void)setPositionProvinceId:(NSNumber *)provinceId andCityId:(NSNumber *)cityId;
@end
@interface WBPlaceChooseViewController : UIViewController

@property(nonatomic, retain) id<PassPositionDelegate> passPositionDelegate;

@property (nonatomic, assign) BOOL fromNextPage;

@end
