//
//  CustomAnnotationView.h
//  微球
//
//  Created by 徐亮 on 16/5/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "WBMapBubble.h"

typedef void(^GoUnlockBlock)(NSString *name);

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) GoUnlockBlock goUnlockBlock;

-(void)goUnlockView:(GoUnlockBlock)block;

@property (nonatomic, strong) WBMapBubble *calloutView;
@property (nonatomic, strong) UIImage *bubbleImage;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *introduction;



@end
