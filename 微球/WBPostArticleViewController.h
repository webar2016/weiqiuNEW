//
//  WBPostArticleViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPostArticleViewController : WBRefreshViewController

@property (nonatomic, assign) BOOL isQuestionAnswer;

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic,copy) NSString *topicID;

@end
