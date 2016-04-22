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
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"draftSaver.sqlite"];
    
    _draftDB = [FMDatabase databaseWithPath:filePath];
    
    if ([_draftDB open]) {
        NSString *createSql =[NSString stringWithFormat:@"create table if not exists 'draftSaver'(userId text, type text,aim text,contentId text,title text,content text,imagesArray blob)"];
        
        BOOL isSuccess = [_draftDB executeUpdate:createSql];
        
        if (!isSuccess) {
            NSLog(@"创建草稿失败");
        }
    }
}

- (BOOL)draftWithData:(WBDraftSave *)draft{
    NSString *insertSql = [NSString stringWithFormat:@"insert into 'draftSaver' (userId, type, aim, contentId, title, content, imagesArray) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", draft.userId, draft.type, draft.aim, draft.contentId, draft.title, draft.content, draft.imagesArray];
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
        NSString *modifiedSql = [NSString stringWithFormat:@"UPDATE 'draftSaver' SET content='%@',imagesArray='%@' WHERE type='%@', contentId='%@'", draft.content, draft.imagesArray, draft.type, draft.contentId];
        isSuccess = [_draftDB executeUpdate:modifiedSql];
    }
    [self closeFBDM];
    return isSuccess;
}

- (NSArray *)allDrafts{
    NSMutableArray *allDrafts = [NSMutableArray array];
    FMResultSet *results = [_draftDB executeQuery:@"select * from 'draftSaver'"];
    
    while ([results next]) {
        WBDraftSave *draft = [[WBDraftSave alloc] init];
        draft.userId = [results stringForColumn:@"userId"];
        draft.type = [results stringForColumn:@"type"];
        draft.aim = [results stringForColumn:@"aim"];
        draft.contentId = [results stringForColumn:@"contentId"];
        draft.title = [results stringForColumn:@"title"];
        draft.content = [results stringForColumn:@"content"];
//        draft.imageRate = [results dataForColumn:@"imageRate"];
        draft.imagesArray = [results dataForColumn:@"imagesArray"];
        [allDrafts addObject:draft];
    }
    
    [self closeFBDM];
    return allDrafts;
}

- (WBDraftSave *)searchDraftWithType:(NSString *)type contentId:(NSString *)contentId{
    FMResultSet *result = [_draftDB executeQuery:@"select * from 'draftSaver' WHERE type='%@', contentId='%@'"];
    if (result) {
        WBDraftSave *draft = [[WBDraftSave alloc] init];
        draft.userId = [result stringForColumn:@"userId"];
        draft.type = [result stringForColumn:@"type"];
        draft.aim = [result stringForColumn:@"aim"];
        draft.contentId = [result stringForColumn:@"contentId"];
        draft.title = [result stringForColumn:@"title"];
        draft.content = [result stringForColumn:@"content"];
//        draft.imageRate = [result dataForColumn:@"imageRate"];
        draft.imagesArray = [result dataForColumn:@"imagesArray"];
        [self closeFBDM];
        return draft;
    } else {
        [self closeFBDM];
        return nil;
    }
}

- (BOOL)deleteDraftWithType:(NSString *)type contentId:(NSString *)contentId{
    BOOL isSuccess;
    if ([_draftDB open]) {
        NSString *deleteSql = [NSString stringWithFormat:@"delete from 'draftSaver' where type='%@', contentId='%@'", type, contentId];
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
