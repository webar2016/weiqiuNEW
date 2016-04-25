//
//  WBAnswerQuestionViewController.m
//  微球
//
//  Created by 徐亮 on 16/4/18.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAnswerQuestionViewController.h"

@interface WBAnswerQuestionViewController ()

@end

@implementation WBAnswerQuestionViewController

- (instancetype)initWithGroupId:(NSString *)groupId questionId:(NSString *)questionId title:(NSString *)title{
    if (self = [super init]) {
        self.draftTitle = title;
        self.groupId = groupId;
        self.questionId = questionId;
        self.url = @"http://121.40.132.44:92/tq/setAnswer";
    }
    return self;
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
    [self.parameters setObject:self.groupId forKey:@"groupId"];
    [self.parameters setObject:self.questionId forKey:@"questionId"];
    [self.parameters setObject:plainString forKey:@"answerText"];
}

- (NSDictionary *)draftDic{
    NSString *plainString = [self.textView.textStorage getPlainStringWithImageArray:self.imageArray byNameArray:self.nameArray byImageRate:self.imageRate];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [WBUserDefaults userId];
    dic[@"type"] = @"1";
    dic[@"aim"] = self.groupId;
    dic[@"contentId"] = self.questionId;
    dic[@"title"] = self.draftTitle;
    dic[@"content"] = plainString;
    dic[@"imagesArray"] = self.imageArray;
    dic[@"nameArray"] = self.nameArray;
    dic[@"imageRate"] = self.imageRate;
    return dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
