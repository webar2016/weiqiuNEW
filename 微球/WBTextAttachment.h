//
//  WBTextAttachment.h
//  Pods
//
//  Created by 徐亮 on 16/3/7.
//
//

#import <UIKit/UIKit.h>

@interface WBTextAttachment : NSTextAttachment <NSCoding>

@property (nonatomic, assign) CGSize maxSize;

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign) NSString *imageRate;

@property (nonatomic, copy) NSString *name;

@end
