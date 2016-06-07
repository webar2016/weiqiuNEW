//
//  WBMapBubble.h
//  微球
//
//  Created by 徐亮 on 16/5/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBMapBubble : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, assign) BOOL isUnlock;


@end
