//
//  DBManager.m
//  Limit_1509
//
//  Created by gaokunpeng on 15/8/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

typedef NS_ENUM(NSInteger, TableName) {
    //以下是枚举成员
    Big_area = 0,
    Tbl_unlock_city = 1,
    Help_group_sign = 2,
    
};

@implementation DBManager
{
    //数据库操作对象
    FMDatabase *_myDataBase;
}

+(DBManager *)sharedInstance
{
    static DBManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    
    
    dispatch_once(&onceToken, ^{
        //代码在程序运行过程中只执行一次
        manager = [[DBManager alloc] init];
    });
    
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        //初始化数据库操作的对象
        [self createDatabase];
    }
    return self;
}

//初始化数据库操作对象
- (void)createDatabase
{
    
    
    //本地数据库文件
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/app1.sqlite"];
    NSLog(@"%@",path);
//    //本地数据库文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
// NSLog(@"path = %@",paths);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//
//    NSLog(@"%@",documentDirectory);
//
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"123student.sqlite"];
//
    //1.获得数据库文件的路径
//      NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    
//      NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];
   
       //2.获得数据库
     //  _myDataBase=[FMDatabase databaseWithPath:fileName];
    
    //创建FMDatabase对象
//     NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"app.sqlite"];
//    NSLog(@"%@",path);
    _myDataBase = [[FMDatabase alloc] initWithPath:path];
    
//    if ([[NSFileManager defaultManager]fileExistsAtPath:path])
//    {
//        NSLog(@"数据库已存在");
//    }
//    
//    _myDataBase=[FMDatabase databaseWithPath:path];
//    
//    if (!_myDataBase)
//    {
//        NSLog(@"数据库创建不成功");
//        
//    }

    
    
    //打开数据库
    BOOL ret = [_myDataBase open];
    NSLog(@"%d",ret);
    if (ret) {
        //数据库打开正常
      /*  @property (nonatomic,assign)int Id;
        @property (nonatomic,assign) NSInteger areaId;
        @property (nonatomic,copy) NSString *areaName;
        @property (nonatomic,assign) NSInteger isCountry;*/
        //创建表格(对应于代码中的一个类)
        //表名:bigarea
        //字段:myId(数据库序号)、areaId(应用的id)、areaName(应用的名称)、isCountry(图片)
        NSString *createSql =[NSString stringWithFormat:@"create table if not exists '%@'(id integer primary key autoincrement, areaId integer(50),areaName text,isCountry integer)",@"bigarea"];         
        BOOL flag = [_myDataBase executeUpdate:createSql];
        
        if (flag) {
            
        }else{
            NSLog(@"表格创建失败");
        }
        
    }else{
        //数据库打开失败
        NSLog(@"数据库打开失败");
    }
    NSLog(@"数据库打开chenggong ");
       
    
}

//添加
-(void)addCollect:(id)model
{
    
    WBBig_AreaModel *cItem = model;
    NSLog(@"----");
   // NSString *insertSql = @"insert into bigarea(areaId,areaName,isCountry) values (@"",?,?)";
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into bigarea (areaId, areaName, isCountry) values ('%d', '%@', '%d'),('123', 'werrr', '123')", cItem.areaId,cItem.areaName ,cItem.isCountry];
   // 图片转化成二进制
//    NSData *data = UIImagePNGRepresentation(cItem.image);
    
    BOOL ret = [_myDataBase executeUpdate:insertSql];
    
    NSLog(@"ret = %d",ret);
    if (!ret) {
        NSLog(@"%@",_myDataBase.lastErrorMessage);
    }
    NSLog(@"添加成功");
    
}

//判断是否已收藏
-(BOOL)isAppFavorite:(NSInteger)areaId
{
    //查询
    //NSString *selectSql = @"select * from collect where applicationId = ?";
    //count(*)是数据库的函数，计算满足条件的数据个数
    //as cnt给数据个数值取一个别名，叫做"cnt"
    NSString *selectSql = @"select count(*) as cnt from bigarea where areaId = ?";
    FMResultSet *rs = [_myDataBase executeQuery:selectSql,areaId];
    //获取记录的个数
    int count = 0;
    if ([rs next]) {
        count = [rs intForColumn:@"cnt"];
    }
    
    if (count > 0) {
        return YES;
    }
    return NO;
}

-(NSArray *)searchAllFavoriteApps
{
    //sql
    NSString *selectSql = @"select * from bigarea";
    //cItem.areaId,cItem.areaName,cItem.isCountry
    //存储查询结果
    NSMutableArray *resultArray = [NSMutableArray array];
    FMResultSet *rs = [_myDataBase executeQuery:selectSql];
    while ([rs next]) {
        //创建一个对象
        WBBig_AreaModel *cItem = [[WBBig_AreaModel alloc] init];
        cItem.Id = [rs intForColumn:@"id"];
        cItem.areaId = [rs intForColumn:@"areaId"];
        cItem.areaName = [rs stringForColumn:@"areaName"];
        cItem.isCountry = [rs intForColumn:@"isCountry"];
       
        //添加到数组中
        [resultArray addObject:cItem];
    }
    return resultArray;
}
-(void)deleteAllData
{
    NSString *deleteSql;
    if ([_myDataBase open])
    {
        
            deleteSql = [NSString stringWithFormat:@"delete  from bigarea "];
            [_myDataBase executeUpdate:deleteSql];
       
        
    }
}

@end
