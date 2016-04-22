//
//  WBDraftManager.h
//  微球
//
//  Created by 徐亮 on 16/4/14.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "WBDraftSave.h"

@interface WBDraftManager : NSObject

+ (WBDraftManager *)openDraft;

- (BOOL)draftWithData:(WBDraftSave *)draft;

- (BOOL)modifiedWithData:(WBDraftSave *)draft;

- (NSArray *)allDrafts;

- (WBDraftSave *)searchDraftWithType:(NSString *)type contentId:(NSString *)contentId;

- (BOOL)deleteDraftWithType:(NSString *)type contentId:(NSString *)contentId;

- (void)closeFBDM;

@end
