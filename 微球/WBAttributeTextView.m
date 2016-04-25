//
//  WBAttributeTextView.m
//  微球
//
//  Created by 徐亮 on 16/3/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAttributeTextView.h"
#import "UIImage+MultiFormat.h"
#import "WBTextAttachment.h"

@interface WBAttributeTextView (){
    NSArray *_contentArray;
    NSArray *_imagesArray;
    NSMutableParagraphStyle *_paragraphStyle;
}

@end

@implementation WBAttributeTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

#pragma mark - 初始化
- (void)commonInit
{
    _contentArray = [NSArray array];
    _imagesArray = [NSArray array];
    _paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    _maxSize = [UIScreen mainScreen].bounds.size;
    _lineSpacing = 5;
    _paragraphSpacing = 10;
}

-(void)showContent{
    
    if (_content == nil && _images == nil) {
        NSLog(@"没有内容");
        return;
    }
    
    _contentArray = [_content componentsSeparatedByString:_contentSeparateSign];
    NSUInteger contentCount = [_contentArray count];
    _imagesArray = [_images componentsSeparatedByString:_imageSeparateSign];
    NSUInteger imageCount = [_imagesArray count];
    
    for (NSUInteger index = 0; index < contentCount; index ++) {
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:_contentArray[index]];
        
        [self.textStorage appendAttributedString:string];
        
        if (index != contentCount-1) {
            WBTextAttachment *textAttachment = [[WBTextAttachment alloc] init] ;
            
            textAttachment.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imagesArray[index]]]];
            
            textAttachment.maxSize = self.maxSize;
            
            NSMutableAttributedString *attachmentString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:textAttachment];
            
            if (index != imageCount) {
                [self.textStorage appendAttributedString:attachmentString];
            }
            
        }
    }
    
    _paragraphStyle.lineSpacing = self.lineSpacing;
    _paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    NSDictionary *attributes = @{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:_paragraphStyle};
    
    [self.textStorage addAttributes:attributes range:NSMakeRange(0, self.textStorage.length)];
    
    self.textColor = self.fontColor;
}

-(void)showDraftWithDraft:(WBDraftSave *)draft{
    
    if (!draft) {
        NSLog(@"没有内容");
        return;
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"draft"];
    NSString *currentDraft = [NSString stringWithFormat:@"%@-%@-%@", draft.userId,draft.type,draft.contentId];
    NSString *draftPath = [path stringByAppendingPathComponent:currentDraft];
    
    _contentArray = [draft.content componentsSeparatedByString:_contentSeparateSign];
    NSUInteger contentCount = [_contentArray count];
    _imagesArray = [draft.nameArray componentsSeparatedByString:_imageSeparateSign];
    NSUInteger imageCount = [_imagesArray count];
    NSArray *rateArray = [draft.imageRate componentsSeparatedByString:_imageSeparateSign];
    
    for (NSUInteger index = 0; index < contentCount; index ++) {
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:_contentArray[index]];
        
        [self.textStorage appendAttributedString:string];
        
        if (index != contentCount-1) {
            WBTextAttachment *textAttachment = [[WBTextAttachment alloc] init] ;
            
            textAttachment.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[draftPath stringByAppendingPathComponent:_imagesArray[index]]]];
            
            textAttachment.name = _imagesArray[index];
            
            textAttachment.maxSize = self.maxSize;
            
            textAttachment.imageRate = rateArray[index];
            
            NSMutableAttributedString *attachmentString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:textAttachment];
            
            if (index != imageCount) {
                [self.textStorage appendAttributedString:attachmentString];
            }
            
        }
    }
    
    _paragraphStyle.lineSpacing = self.lineSpacing;
    _paragraphStyle.paragraphSpacing = self.paragraphSpacing;
    NSDictionary *attributes = @{ NSFontAttributeName:self.font, NSParagraphStyleAttributeName:_paragraphStyle};
    
    [self.textStorage addAttributes:attributes range:NSMakeRange(0, self.textStorage.length)];
    
    self.textColor = self.fontColor;
}



@end
