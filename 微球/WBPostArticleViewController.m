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
        self.title = title;
        self.topicID = topicId;
        self.url = @"http://app.weiqiu.me/tq/setComment";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setParameters{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray: self.imageArray];
    
    NSUInteger count = self.imageArray.count;
    
    NSString *rateString = [[NSString alloc] init];
    for (int i = 0; i < count; i ++) {
        if (i == 0) {
            rateString = [rateString stringByAppendingString:((WBImage *)self.imageArray[i]).imageRate];
        } else {
            rateString = [rateString stringByAppendingString:[NSString stringWithFormat:@";%@",((WBImage *)self.imageArray[i]).imageRate]];
        }
    }
    
    [self.parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
    [self.parameters setObject:rateString forKey:@"imgRate"];
    [self.parameters setObject:self.topicID forKey:@"topicId"];
    [self.parameters setObject:@"3" forKey:@"newsType"];
    [self.parameters setObject:plainString forKey:@"comment"];
}

- (NSDictionary *)draftDic{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray: self.imageArray];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [WBUserDefaults userId];
    dic[@"type"] = @"2";
    dic[@"aim"] = @"3";
    dic[@"contentId"] = self.topicID;
    dic[@"title"] = self.title;
    dic[@"content"] = plainString;
    dic[@"imagesArray"] = self.imageArray;
    return dic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
