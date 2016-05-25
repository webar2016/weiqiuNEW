//
//  WBIntroView.h
//  微球
//
//  Created by 徐亮 on 16/5/25.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@protocol CalloutViewDelegate <NSObject>

- (void)clickBubbleHandle;

@end

@interface WBIntroView : UIView

@property (nonatomic, weak) id <CalloutViewDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name introduction:(NSString *)introduction;

@end
