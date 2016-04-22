//
//  WBImage.m
//  微球
//
//  Created by 徐亮 on 16/4/16.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBImage.h"

@implementation WBImage

+ (WBImage *) imageWithImage:(UIImage *)image name:(NSString *)name rate:(NSString *)rate{
    WBImage *wbImage = [[WBImage alloc] init];
    wbImage.image = image;
    wbImage.imageName = name;
    wbImage.imageRate = rate;
    return wbImage;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.imageRate = [aDecoder decodeObjectForKey:@"imageRate"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.imageRate forKey:@"imageRate"];
}

@end
