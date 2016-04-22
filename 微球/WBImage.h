//
//  WBImage.h
//  微球
//
//  Created by 徐亮 on 16/4/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBImage : NSObject <NSCoding>

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *imageRate;

+ (WBImage *) imageWithImage:(UIImage *)image name:(NSString *)name rate:(NSString *)rate;

@end
