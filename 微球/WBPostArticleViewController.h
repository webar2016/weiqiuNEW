//
//  WBPostArticleViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBArticalBaseViewController.h"

@interface WBPostArticleViewController : WBArticalBaseViewController

@property (nonatomic,copy) NSString *topicID;

- (instancetype)initWithTopicId:(NSString *)topicId title:(NSString *)title;

@end
