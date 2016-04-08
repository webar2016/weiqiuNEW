//
//  MyDBmanager.h
//  微球
//
//  Created by 贾玉斌 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBBig_AreaModel.h"
#import "WBTbl_Unlock_City.h"
#import "WBHelp_Group_Sign.h"
#import <sqlite3.h>


typedef NS_ENUM(NSInteger, TableName) {
    //以下是枚举成员
    Big_area = 0,
    Tbl_unlock_city = 1,
    Help_group_sign = 2,
    Tbl_unlocking_city = 3
    
};


@interface MyDBmanager : NSObject

//初始化
-(instancetype)initWithStyle:(TableName)style;
//创建或者打开数据库
-(void)createOrOpenSqliteWithStyle:(TableName)style;
//添加数据
-(void)addItem:(id)model;
//是否添加数据
-(BOOL)isAddedItemsID:(NSInteger)headId;
//搜索所有的数据
-(NSArray *)searchAllItems;
//修改数据
-(void)modifiedWithItem:(id)Item;
//删除摸个数据
-(void)deletedataWithKey:(NSString *)key andValue:(id)value;
//删除所有数据
-(void)deleteAllData;
//关闭数据库
-(void)closeFBDM;

@end
