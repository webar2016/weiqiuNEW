//
//  NSAttributedString + attributedString.m
//  微球
//
//  Created by 徐亮 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "NSAttributedString + attributedString.h"
#import "WBTextAttachment.h"

@implementation NSAttributedString (NSAttributedString)

- (NSString *)getPlainStringWithImageArray:(NSMutableArray *)imageArray byNameArray:(NSMutableArray *)nameArray{
//    imageArray = nil;
//    nameArray = nil;
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[WBTextAttachment class]]) {
                          [imageArray addObject:((WBTextAttachment *)value).image];
                          [nameArray addObject:((WBTextAttachment *)value).name];
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:IMAGE];
                          base += IMAGE.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
