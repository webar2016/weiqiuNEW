//
//  WBImageViewer.h
//  微球
//
//  Created by 徐亮 on 16/4/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBImageViewer : UIViewController

@property (nonatomic, weak) UIImage *image;

@property (nonatomic, copy) NSString *dir;

-(instancetype)initWithImage:(UIImage *)image;

-(instancetype)initWithDir:(NSString *)dir;

@end
