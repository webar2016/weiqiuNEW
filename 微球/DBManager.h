//
//  DBManager.h
//  Limit_1509
//
//  Created by gaokunpeng on 15/8/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBBig_AreaModel.h"
#import <sqlite3.h>


@interface DBManager : NSObject

//获取单例对象
+ (DBManager *)sharedInstance;

//增加
- (void)addCollect:(WBBig_AreaModel *)cItem;
//判断是否已收藏
-(BOOL)isAppFavorite:(NSInteger)areaId;

//查询所有收藏的数据
- (NSArray *)searchAllFavoriteApps;

-(void)deleteAllData;
@end
