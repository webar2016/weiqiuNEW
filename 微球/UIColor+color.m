//
//  UIColor+color.m
//  微球
//
//  Created by 徐亮 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "UIColor+color.h"

@implementation UIColor (UIColor)

+(instancetype)initWithGreen{
    return [UIColor colorWithRed:5/255.0 green:192/255.0 blue:171/255.0 alpha:1];
}

+(instancetype)initWithRed{
    return [UIColor colorWithRed:250/255.0 green:112/255.0 blue:112/255.0 alpha:1];
}

+(instancetype)initWithDarkGray{
    return [UIColor colorWithRed:44/255.0 green:47/255.0 blue:52/255.0 alpha:1];
}

+(instancetype)initWithLightGray{
    return [UIColor colorWithRed:57/255.0 green:60/255.0 blue:65/255.0 alpha:1];
}

+(instancetype)initWithNormalGray{
    return [UIColor colorWithRed:117/255.0 green:118/255.0 blue:120/255.0 alpha:1];
}

+(instancetype)initWithBackgroundGray{
    return [UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
}

+(instancetype)initWithPink{
    return [UIColor colorWithRed:253.f/255.f green:151.f/255.f blue:186.f/255.f alpha:1];
}

@end
