//
//  WBPostArticleViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPostArticleViewController.h"

@interface WBPostArticleViewController ()

@end

@implementation WBPostArticleViewController

- (instancetype)initWithTopicId:(NSString *)topicId title:(NSString *)title{
    if (self = [super init]) {
        self.draftTitle = title;
        self.topicID = topicId;
        self.url = @"http://121.40.132.44:92/tq/setComment";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setParameters{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray:self.imageArray byNameArray:self.nameArray byImageRate:self.imageRate];
    
    NSUInteger count = self.imageArray.count;
    
    NSString *rateString = [[NSString alloc] init];
    for (int i = 0; i < count; i ++) {
        if (i == 0) {
            rateString = [rateString stringByAppendingString:self.imageRate[i]];
        } else {
            rateString = [rateString stringByAppendingString:[NSString stringWithFormat:@";%@",self.imageRate[i]]];
        }
    }
    
    [self.parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [self.parameters setObject:rateString forKey:@"imgRate"];
    [self.parameters setObject:self.topicID forKey:@"topicId"];
    [self.parameters setObject:@"3" forKey:@"newsType"];
    [self.parameters setObject:plainString forKey:@"comment"];
}

- (NSDictionary *)draftDic{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray:self.imageArray byNameArray:self.nameArray byImageRate:self.imageRate];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [WBUserDefaults userId];
    dic[@"type"] = @"2";
    dic[@"aim"] = @"3";
    dic[@"contentId"] = self.topicID;
    dic[@"title"] = self.draftTitle;
    dic[@"content"] = plainString;
    dic[@"imagesArray"] = self.imageArray;
    dic[@"nameArray"] = self.nameArray;
    dic[@"imageRate"] = self.imageRate;
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
