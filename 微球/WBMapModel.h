//
//  WBMapModel.h
//  微球
//
//  Created by 贾玉斌 on 16/6/6.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBMapModel : NSObject

@property (nonatomic, copy) NSString *sceneryId;
@property (nonatomic, copy) NSString *sceneryName;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *locat;
@property (nonatomic, assign) BOOL unlock;

@end
