//
//  CustomAnnotationView.h
//  微球
//
//  Created by 徐亮 on 16/5/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "WBMapBubble.h"




typedef void(^GoUnlockBlock)(NSString *sceneryName,NSString *sceneryId,NSString *cityId);

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) GoUnlockBlock goUnlockBlock;

-(void)goUnlockView:(GoUnlockBlock)block;

@property (nonatomic, strong) WBMapBubble *calloutView;
@property (nonatomic, strong) UIImage *bubbleImage;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *sceneryName;
@property (nonatomic, copy) NSString *sceneryId;
@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL isUnlock;

@end
