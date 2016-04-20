//
//  WBAnswerQuestionViewController.h
//  微球
//
//  Created by 徐亮 on 16/4/18.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBArticalBaseViewController.h"

@interface WBAnswerQuestionViewController : WBArticalBaseViewController

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *questionId;

- (instancetype)initWithGroupId:(NSString *)groupId questionId:(NSString *)questionId title:(NSString *)title;

@end
