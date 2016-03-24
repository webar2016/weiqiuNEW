//
//  NSString+string.m
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "NSString+string.h"

@implementation NSString (NSString)


-(CGSize)adjustSizeWithWidth:(CGFloat)width andFont:(UIFont *)font{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

-(instancetype)replaceImageSign{
    
    NSString *currentString = [[NSString alloc] init];
    
    NSArray *array = [self componentsSeparatedByString:IMAGE];
    NSUInteger count = array.count;
    for (NSUInteger i = 0; i < count; i ++) {
        if (i == count - 1) {
            currentString = [currentString stringByAppendingString:array[i]];
        }else{
            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"%@%@",array[i],@"[图片]"]];
        }
        
    }
    
    return currentString;
}

@end
