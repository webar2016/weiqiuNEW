//
//  NSAttributedString + attributedString.m
//  微球
//
//  Created by 徐亮 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "NSAttributedString + attributedString.h"
#import "WBTextAttachment.h"
#import "WBImage.h"

@implementation NSAttributedString (NSAttributedString)

- (NSString *)getPlainStringWithImageArray:(NSMutableArray *)imageArray{
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[WBTextAttachment class]]) {
                          WBTextAttachment *attachment = (WBTextAttachment *)value;
                          WBImage *image = [WBImage imageWithImage:attachment.image name:attachment.name rate:attachment.imageRate];
                          [imageArray addObject:image];
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:IMAGE];
                          base += IMAGE.length - 1;
                      }
                  }];
    return plainString;
}

//-(void)replacePlaceHolderImageWithImages:(NSArray *)imageArray{
//    
//}

@end
