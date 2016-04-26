//
//  WBDraftSave.m
//  
//
//  Created by 徐亮 on 16/3/30.
//
//

#import "WBDraftSave.h"

@implementation WBDraftSave

- (instancetype)initWithData:(NSDictionary *)data{
    if (self = [super init]) {
        
        self.userId = data[@"userId"];
        self.type = data[@"type"];
        self.aim = data[@"aim"];
        self.contentId = data[@"contentId"];
        self.title = data[@"title"];
        self.content = data[@"content"];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"draft"];
        NSString *currentDraft = [NSString stringWithFormat:@"%@-%@-%@",self.userId, self.type, self.contentId];
        NSString *draftPath = [path stringByAppendingPathComponent:currentDraft];//当前草稿图片文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:draftPath]) {
            [fileManager createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSArray *rateArray = data[@"imageRate"];
        NSArray *nameArray = data[@"nameArray"];
        NSArray *images = data[@"imagesArray"];
        NSString *rateString = [NSString string];
        NSString *nameString = [NSString string];
        
        NSInteger count = rateArray.count;
        for (int i = 0; i < count; i ++) {
            if (i == 0) {
                rateString = [rateString stringByAppendingString:rateArray[i]];
                nameString = [nameString stringByAppendingString:nameArray[i]];
            } else {
                rateString = [rateString stringByAppendingString:[NSString stringWithFormat:@";%@",rateArray[i]]];
                nameString = [nameString stringByAppendingString:[NSString stringWithFormat:@";%@",nameArray[i]]];
            }
            
            NSString *filename=[draftPath stringByAppendingPathComponent:nameArray[i]];
            UIImage *image = images[i];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            [data writeToFile:filename atomically:YES];
        }
        self.nameArray = nameString;
        self.imageRate = rateString;
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
    draftDic[@"nameArray"] = self.nameArray;
    draftDic[@"imageRate"] = self.imageRate;
    return draftDic;
}

@end
