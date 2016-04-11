//
//  MyDBmanager.m
//  微球
//
//  Created by 贾玉斌 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "MyDBmanager.h"
#import "FMDatabase.h"

@implementation MyDBmanager
{
    //数据库操作对象
    FMDatabase *_myDataBase;
    TableName _style;
    NSString *_tableName;
}


/*MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
 [manager  addItem:model];
 NSLog(@"1 -------%@",[manager searchAllItems]);
 [manager closeFBDM];*/

-(instancetype)initWithStyle:(TableName)style
{
    self = [super init];
    if (self) {
        //初始化数据库操作的对象
        [self createOrOpenSqliteWithStyle:style];
    }
    return self;
}


//创建数据库，并连接
-(void)createOrOpenSqliteWithStyle:(TableName)style
{
    _style = style;
    if (_style == 0) {
        _tableName = @"big_area";
    }else if(_style == 1){
    _tableName = @"tbl_unlock_city";
    }else if(_style == 2){
    _tableName = @"help_group_sign";
    }else if (_style == 3){
    _tableName = @"tbl_unlocking_city";
    }
    NSArray *doucumentDirectory=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *file=[doucumentDirectory objectAtIndex:0];
    NSString *dafile=[file stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",_tableName]];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:dafile])
    {
     //   NSLog(@"数据库已存在");
    }
    
    _myDataBase=[FMDatabase databaseWithPath:dafile];
    
    if (!_myDataBase)
    {
       // NSLog(@"数据库创建不成功");
    }
    else
    {   if([_myDataBase open])
            { //NSLog(@"数据库创建成功并打开");
                //创建数据库big_area
                if (_style == 0) {
                    NSString *createSql =[NSString stringWithFormat:@"create table if not exists '%@'(id integer primary key autoincrement, areaId integer,areaName text,isCountry integer)",_tableName];
                    BOOL flag = [_myDataBase executeUpdate:createSql];
                    if (flag) {
                    //    NSLog(@"表格创建成功");
                    }else{
                     //   NSLog(@"表格创建失败");
                    }
                }else if(_style == 1){
                    //创建数据库tbl_unlock_city
                    NSString *createSql =[NSString stringWithFormat:@"create table if not exists '%@'(id integer primary key autoincrement, userId integer,cityId integer,unlockDate date,areaId integer,marked integer)",_tableName];
                    BOOL flag = [_myDataBase executeUpdate:createSql];
                    if (flag) {
                      //  NSLog(@"表格创建成功");
                    }else{
                       // NSLog(@"表格创建失败");
                    }
                }else if(_style == 2){
                    //创建数据库help_group_sign
                    NSString *createSql =[NSString stringWithFormat:@"create table if not exists '%@'(id integer primary key autoincrement, sign_id integer,sign text,sign_describe text,type_flag text)",_tableName];
                    BOOL flag = [_myDataBase executeUpdate:createSql];
                    if (flag) {
                      //  NSLog(@"表格创建成功");
                    }else{
                      //  NSLog(@"表格创建失败");
                    }
                }else{
                    //创建数据库tbl_unlock_city
                    NSString *createSql =[NSString stringWithFormat:@"create table if not exists '%@'(id integer primary key autoincrement, userId text,provinceId text,cityId text,provinceName text,cityName text)",_tableName];
                    BOOL flag = [_myDataBase executeUpdate:createSql];
                    if (flag) {
                       // NSLog(@"表格创建成功");
                    }else{
                      //  NSLog(@"表格创建失败");
                    }
                }
            }else{
           // NSLog(@"数据库打开失败");
            }
    }
    
}

//添加
-(void)addItem:(id)model
{
    
    NSString *insertSql;
    if (_style == 0) {
        WBBig_AreaModel *cItem =model;
       insertSql = [NSString stringWithFormat:@"insert into '%@' (areaId, areaName, isCountry) values ('%ld', '%@', '%ld')", _tableName,(long)cItem.areaId,cItem.areaName ,(long)cItem.isCountry];
    }else if(_style == 1){
        WBTbl_Unlock_City *cItem =model;
        insertSql = [NSString stringWithFormat:@"insert into '%@' (userId, cityId, unlockDate,areaId,marked) values ('%ld', '%ld','%@', '%ld', '%ld')", _tableName,(long)cItem.userId,(long)cItem.cityId ,cItem.unlockDate,(long)cItem.areaId,(long)cItem.marked];
    }else if(_style == 2){
        WBHelp_Group_Sign *cItem =model;
        insertSql = [NSString stringWithFormat:@"insert into '%@' (sign_id, sign, sign_describe,type_flag) values ('%ld', '%@','%@', '%@')", _tableName,(long)cItem.sign_id,cItem.sign ,cItem.sign_describe,cItem.type_flag];
    }else if(_style == 3){
        WBTbl_Unlocking_City *cItem =model;
        insertSql = [NSString stringWithFormat:@"insert into '%@' (userId, provinceId, cityId, provinceName, cityName) values ('%@', '%@','%@', '%@', '%@')", _tableName, cItem.userId,cItem.provinceId ,cItem.cityId,cItem.provinceName,cItem.cityName];
    }
    
   // NSLog(@"----");
   //  NSString *insertSql = @"insert into bigarea(areaId,areaName,isCountry) values (@"",?,?)";
   
     //图片转化成二进制
       // NSData *data = UIImagePNGRepresentation(cItem.image);
    
    BOOL ret = [_myDataBase executeUpdate:insertSql];
    
  //  NSLog(@"ret = %d",ret);
    if (!ret) {
        NSLog(@"%@",_myDataBase.lastErrorMessage);
    }
  //  NSLog(@"添加成功");
    
}

//判断是否已收藏
-(BOOL)isAddedItemsID:(NSString *)cityId
{
    //查询
    //NSString *selectSql = @"select * from collect where applicationId = ?";
    //count(*)是数据库的函数，计算满足条件的数据个数
    //as cnt给数据个数值取一个别名，叫做"cnt"
  //  NSString *selectSql = @"select count(*) as cnt from bigarea where areaId = ?";
    NSString *selectSql = [NSString string];
    //获取记录的个数
    if (_style == 1 || _style == 3) {
        selectSql = [NSString stringWithFormat:@"select count(*) as cnt from '%@' where cityId = ?",_tableName];
    }
    FMResultSet *rs = [_myDataBase executeQuery:selectSql,cityId];
    int count = 0;
    if ([rs next]) {
        count = [rs intForColumn:@"cnt"];
    }
    if (count > 0) {
        return YES;
    }
    return NO;
}

-(NSArray *)searchAllItems
{
    //sql
    NSString *selectSql=[NSString stringWithFormat:@"select * from '%@'",_tableName];
    NSMutableArray *resultArray = [NSMutableArray array];
    if (_style ==0) {
        //selectSql = @"select * from bigarea";
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
    }else if (_style ==1){
        FMResultSet *rs = [_myDataBase executeQuery:selectSql];
        while ([rs next]) {
            //创建一个对象
            WBTbl_Unlock_City *cItem = [[WBTbl_Unlock_City alloc] init];
            cItem.Id = [rs intForColumn:@"id"];
            cItem.userId = [rs intForColumn:@"userId"];
            cItem.cityId = [rs intForColumn:@"cityId"];
            cItem.unlockDate = [rs dateForColumn:@"unlockDate"];
            cItem.areaId = [rs intForColumn:@"areaId"];
            cItem.marked = [rs intForColumn:@"marked"];
            //添加到数组中
            [resultArray addObject:cItem];
        }
    }else if (_style ==2){
        FMResultSet *rs = [_myDataBase executeQuery:selectSql];
        while ([rs next]) {
            //创建一个对象
            WBHelp_Group_Sign *cItem = [[WBHelp_Group_Sign alloc] init];
            cItem.Id = [rs intForColumn:@"id"];
            cItem.sign_id = [rs intForColumn:@"sign_id"];
            cItem.sign = [rs stringForColumn:@"sign"];
            cItem.sign_describe = [rs stringForColumn:@"sign_describe"];
            cItem.type_flag = [rs stringForColumn:@"type_flag"];
            //添加到数组中
            [resultArray addObject:cItem];
        }
    }else if (_style ==3){
        FMResultSet *rs = [_myDataBase executeQuery:selectSql];
        while ([rs next]) {
            //创建一个对象
            WBTbl_Unlocking_City *cItem = [[WBTbl_Unlocking_City alloc] init];
            cItem.Id = [rs intForColumn:@"id"];
            cItem.userId = [rs stringForColumn:@"userId"];
            cItem.provinceId = [rs stringForColumn:@"provinceId"];
            cItem.cityId = [rs stringForColumn:@"cityId"];
            cItem.provinceName = [rs stringForColumn:@"provinceName"];
            cItem.cityName = [rs stringForColumn:@"cityName"];
            //添加到数组中
            [resultArray addObject:cItem];
        }
    }
    //cItem.areaId,cItem.areaName,cItem.isCountry
    //存储查询结果
    return resultArray;
}

//修改数据
-(void)modifiedWithItem:(id)Item
{
    NSString *modifiedSql;
    if ([_myDataBase open])
    {
        if (_style == 0) {
            WBBig_AreaModel *model = Item;
             modifiedSql = [NSString stringWithFormat:@"UPDATE '%@' SET areaId='%ld',areaName='%@',isCountry='%ld' WHERE id='%d'",_tableName,(long)model.areaId,model.areaName,(long)model.isCountry,model.Id];
            [_myDataBase executeUpdate:modifiedSql];
        }else if (_style == 1){
            WBTbl_Unlock_City *model = Item;
            modifiedSql = [NSString stringWithFormat:@"UPDATE '%@' SET userId='%ld',cityId='%ld',unlockDate='%@',areaId='%ld',marked='%ld' WHERE id='%d'",_tableName,(long)model.userId,(long)model.cityId,model.unlockDate,(long)model.areaId,(long)model.marked,model.Id];
            [_myDataBase executeUpdate:modifiedSql];
        
        }else if (_style == 2){
            WBHelp_Group_Sign *model = Item;
            modifiedSql = [NSString stringWithFormat:@"UPDATE '%@' SET sign_id='%ld',sign='%@',sign_describe='%@',type_flag='%@' WHERE id='%d'",_tableName,(long)model.sign_id,model.sign,model.sign_describe,model.type_flag,model.Id];
            [_myDataBase executeUpdate:modifiedSql];
            
        }else if (_style == 3){
            WBTbl_Unlocking_City *model = Item;
            modifiedSql = [NSString stringWithFormat:@"UPDATE '%@' SET userId='%@',provinceId='%@',cityId='%@',provinceName='%@',cityName='%@' WHERE id='%d'",_tableName,model.userId,model.provinceId,model.cityId,model.provinceName,model.cityName,model.Id];
            [_myDataBase executeUpdate:modifiedSql];
            
        }
    }
}
//删除数据
-(void)deletedataWithKey:(NSString *)key andValue:(NSString *)value
{
    NSString *deleteSql;
    if ([_myDataBase open])
    {
        
            deleteSql = [NSString stringWithFormat:@"delete from '%@' where %@ ='%@'",_tableName,key,value];
        [_myDataBase executeUpdate:deleteSql];
        
      //  NSLog(@"--------%d",[_myDataBase executeUpdate:deleteSql]);
    }
}

//删除所有数据


-(void)deleteAllData
{
    NSString *deleteSql;
    if ([_myDataBase open])
    {
            deleteSql = [NSString stringWithFormat:@"delete  from '%@' ",_tableName];
            [_myDataBase executeUpdate:deleteSql];
    }
}

-(void)closeFBDM{
    [_myDataBase close];

}

@end
