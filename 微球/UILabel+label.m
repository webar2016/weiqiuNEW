//
//  UILabel + label.m
//  微球
//
//  Created by 徐亮 on 16/3/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "UILabel+label.h"

@implementation UILabel (UILabel)

-(void)setLineSpace:(CGFloat)space withContent:(NSString *)content{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [self setAttributedText:attributedString];
}

@end
