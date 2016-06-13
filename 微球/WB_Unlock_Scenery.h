//
//  WB_Unlock_Scenery.h
//  微球
//
//  Created by 贾玉斌 on 16/6/13.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WB_Unlock_Scenery : NSObject

@property (nonatomic,assign)int Id;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *sceneryId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *unlockDir;
@property (nonatomic,copy) NSString *content;



@end
