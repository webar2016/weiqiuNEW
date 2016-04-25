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
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSLog(@"------%@",path);
        
        self.userId = data[@"userId"];
        self.type = data[@"type"];
        self.aim = data[@"aim"];
        self.contentId = data[@"contentId"];
        self.title = data[@"title"];
        self.content = data[@"content"];
        
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
            
            NSString *filename=[path stringByAppendingPathComponent:nameArray[i]];
            UIImage *image = images[i];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            [data writeToFile:filename atomically:YES];
        }
        NSLog(@"%@---%@",self.nameArray, self.imageRate);
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
