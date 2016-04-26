//
//  WBDraftManager.m
//  微球
//
//  Created by 徐亮 on 16/4/14.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBDraftManager.h"
#import "FMDatabase.h"
#import "WBDraftSave.h"

@interface WBDraftManager () {
    FMDatabase  *_draftDB;
}

@end

@implementation WBDraftManager

+ (WBDraftManager *)openDraft
{
    WBDraftManager *draft = [[WBDraftManager alloc] init];
    
    return draft;
}

- (instancetype)init{
    if (self = [super init]) {
        
        [self openDraftDB];
        
    }
    return self;
}

- (void)openDraftDB{
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory
, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"draftSaver.sqlite"];
    
    _draftDB = [FMDatabase databaseWithPath:filePath];
    
    if ([_draftDB open]) {
        NSString *createSql =[NSString stringWithFormat:@"create table if not exists 'draftSaver'(userId text, type text,aim text,contentId text,title text,content text,imageRate text,nameArray text)"];
        
        BOOL isSuccess = [_draftDB executeUpdate:createSql];
        
        if (!isSuccess) {
            NSLog(@"创建草稿失败");
        }
    }
}

- (BOOL)draftWithData:(WBDraftSave *)draft{
    NSString *insertSql = [NSString stringWithFormat:@"insert into 'draftSaver' (userId, type, aim, contentId, title, content, imageRate, nameArray) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", draft.userId, draft.type, draft.aim, draft.contentId, draft.title, draft.content, draft.imageRate, draft.nameArray];
    BOOL isSuccess = [_draftDB executeUpdate:insertSql];
    
    if (!isSuccess) {
        NSLog(@"创建草稿失败---%@", _draftDB.lastErrorMessage);
    }
    
    [self closeFBDM];
    return isSuccess;
}

- (BOOL)modifiedWithData:(WBDraftSave *)draft{
    BOOL isSuccess;
    if ([_draftDB open]) {
        NSString *modifiedSql = [NSString stringWithFormat:@"UPDATE 'draftSaver' SET content='%@',imageRate='%@',nameArray='%@' WHERE type='%@' and contentId='%@' and userId='%@'", draft.content, draft.imageRate, draft.nameArray, draft.type, draft.contentId, draft.userId];
        isSuccess = [_draftDB executeUpdate:modifiedSql];
    }
    [self closeFBDM];
    return isSuccess;
}

- (NSArray *)allDraftsWithUserId:(NSString *)userId{
    NSMutableArray *allDrafts = [NSMutableArray array];
    FMResultSet *results = [_draftDB executeQuery:[NSString stringWithFormat:@"select * from 'draftSaver' WHERE userId='%@'",userId]];
    
    while ([results next]) {
        WBDraftSave *draft = [[WBDraftSave alloc] init];
        draft.userId = [results stringForColumn:@"userId"];
        draft.type = [results stringForColumn:@"type"];
        draft.aim = [results stringForColumn:@"aim"];
        draft.contentId = [results stringForColumn:@"contentId"];
        draft.title = [results stringForColumn:@"title"];
        draft.content = [results stringForColumn:@"content"];
        draft.imageRate = [results stringForColumn:@"imageRate"];
        draft.nameArray = [results stringForColumn:@"nameArray"];
        [allDrafts addObject:draft];
    }
    
    [self closeFBDM];
    return allDrafts;
}

- (WBDraftSave *)searchDraftWithType:(NSString *)type contentId:(NSString *)contentId userId:(NSString *)userId{
    FMResultSet *result = [_draftDB executeQuery:[NSString stringWithFormat:@"select * from 'draftSaver' WHERE type='%@' and contentId='%@' and userId='%@'",type, contentId, userId]];
    WBDraftSave *draft = nil;
    while ([result next]) {
        draft = [[WBDraftSave alloc] init];
        draft.userId = [result stringForColumn:@"userId"];
        draft.type = [result stringForColumn:@"type"];
        draft.aim = [result stringForColumn:@"aim"];
        draft.contentId = [result stringForColumn:@"contentId"];
        draft.title = [result stringForColumn:@"title"];
        draft.content = [result stringForColumn:@"content"];
        draft.nameArray = [result stringForColumn:@"nameArray"];
        draft.imageRate = [result stringForColumn:@"imageRate"];
    }
    [self closeFBDM];
    return draft;
}

- (BOOL)deleteDraftWithType:(NSString *)type contentId:(NSString *)contentId userId:(NSString *)userId{
    BOOL isSuccess;
    if ([_draftDB open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from 'draftSaver' where type='%@' and contentId='%@' and userId='%@'", type, contentId, userId];
        isSuccess = [_draftDB executeUpdate:deleteSql];
        if (!isSuccess) {
            NSLog(@"删除失败");
        }
        [self closeFBDM];
    }
    return isSuccess;
}

-(void)closeFBDM{
    [_draftDB close];
}

@end
