//
//  WBTextAttachment.m
//  Pods
//
//  Created by 徐亮 on 16/3/7.
//
//

#import "WBTextAttachment.h"

@implementation WBTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    UIImage *image = self.image;
    CGSize size = image.size;
    
    if (size.height <= _maxSize.height && size.width <= _maxSize.width) {
        _imageSize = CGSizeMake(size.width, size.height);
        return CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    }
    
    CGFloat height = _maxSize.width * size.height / size.width;
    
    return CGRectMake(0, 0, _maxSize.width, height);
}

@end
