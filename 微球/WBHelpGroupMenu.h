//
//  WBHelpGroupMenu.h
//  微球
//
//  Created by 贾玉斌 on 16/5/4.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^MyHelpGroupBlock)(BOOL isAllHelpGroup);


typedef void (^CloseBlock)();

@interface WBHelpGroupMenu : UIView

-(instancetype)initWithHeight:(CGFloat)Height;

@property (copy, nonatomic)MyHelpGroupBlock block;
@property (copy, nonatomic)CloseBlock colseBlock;


- (void)show;



@end
