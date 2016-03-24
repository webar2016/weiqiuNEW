//
//  UIImage+image.m
//  微球
//
//  Created by 徐亮 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (UIImage)

+(instancetype)imageWithOriginal:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
