//
//  WBFansModel.h
//  微球
//
//  Created by 贾玉斌 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBFansModel : NSObject

@property (nonatomic,copy)NSString *fansId;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,assign)BOOL isFriend;

@end
