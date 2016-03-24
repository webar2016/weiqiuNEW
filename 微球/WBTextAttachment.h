//
//  WBTextAttachment.h
//  Pods
//
//  Created by 徐亮 on 16/3/7.
//
//

#import <UIKit/UIKit.h>

@interface WBTextAttachment : NSTextAttachment

@property (nonatomic, assign) CGSize maxSize;

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, copy) NSString *name;

@end
