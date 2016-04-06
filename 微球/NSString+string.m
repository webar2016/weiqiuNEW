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
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}

-(instancetype)replaceImageSign{
    
    NSString *currentString = [[NSString alloc] init];
    
    NSArray *array = [self componentsSeparatedByString:IMAGE];
    NSUInteger count = array.count;
    for (NSUInteger i = 0; i < count; i ++) {
        NSString *string = [array[i]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (i == count - 1) {
            currentString = [currentString stringByAppendingString:string];
        }else{
            currentString = [currentString stringByAppendingString:[NSString stringWithFormat:@"%@%@",string,@"[图片]"]];
        }
    }
    return currentString;
}

+(NSString *)ret32bitString{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

@end
