//
//  NSString+string.h
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString)

/**
 *高度自适应,返回调整后的size
 */
-(CGSize)adjustSizeWithWidth:(CGFloat)width andFont:(UIFont *)font;

/**
 *替换图片标识
 */
-(NSString *)replaceImageSign;

@end
