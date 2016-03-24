//
//  WBUserInfosModel.h
//  微球
//
//  Created by 徐亮 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBUserInfosModel : NSObject

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSURL *dir;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *profile;

@end
