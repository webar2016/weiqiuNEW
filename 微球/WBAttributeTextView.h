//
//  WBAttributeTextView.h
//  微球
//
//  Created by 徐亮 on 16/3/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBAttributeTextView : UITextView

/**
 *需要展示的文本内容（带图片标识）
 */
@property (nonatomic, copy) NSString *content;

/**
 *需要展示的图片附件
 */
@property (nonatomic, copy) NSString *images;

/**
 *展示图片最大尺寸
 *长宽都小于最大尺寸时，以原尺寸展示
 *长宽中有一个超过时，以最大宽度展示，高度自适应
 */
@property (nonatomic, assign) CGSize maxSize;

/**
 *图片展示标识
 */
@property (nonatomic, copy) NSString *contentSeparateSign;

/**
 *图片分割标识
 */
@property (nonatomic, copy) NSString *imageSeparateSign;

/**
 *字体颜色
 */
@property (nonatomic, strong) UIColor *fontColor;

/**
 *行距
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 *段距
 */
@property (nonatomic, assign) CGFloat paragraphSpacing;

-(void)showContent;

@end
