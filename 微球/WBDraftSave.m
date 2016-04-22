//
//  WBDraftSave.m
//  
//
//  Created by 徐亮 on 16/3/30.
//
//

#import "WBDraftSave.h"
#import "WBImage.h"

@implementation WBDraftSave

- (instancetype)initWithData:(NSDictionary *)data{
    if (self = [super init]) {
        
        self.userId = data[@"userId"];
        self.type = data[@"type"];
        self.aim = data[@"aim"];
        self.contentId = data[@"contentId"];
        self.title = data[@"title"];
        self.content = data[@"content"];
        
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSInteger i = 0; i < ((NSArray *)data[@"imagesArray"]).count; i ++) {
//            [array addObject:[NSKeyedArchiver archivedDataWithRootObject:((NSArray *)data[@"imagesArray"])[i]]];
//        }
        self.imagesArray = [NSKeyedArchiver archivedDataWithRootObject:data[@"imagesArray"]];
        
        NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:self.imagesArray]);
    }
    return self;
}

- (NSDictionary *)showDraft{
    NSMutableDictionary *draftDic = [NSMutableDictionary dictionary];
    draftDic[@"userId"] = self.userId;
    draftDic[@"type"] = self.type;
    draftDic[@"aim"] = self.aim;
    draftDic[@"contentId"] = self.contentId;
    draftDic[@"title"] = self.title;
    draftDic[@"content"] = self.content;
    draftDic[@"imagesArray"] = [NSKeyedUnarchiver unarchiveObjectWithData:self.imagesArray];
    return draftDic;
}

@end
