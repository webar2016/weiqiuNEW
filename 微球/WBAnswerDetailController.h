//
//  WBAnswerDetailController.h
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBAnswerDetailController : WBRefreshViewController

@property (nonatomic, copy) NSString *questionText;
@property (nonatomic, assign) NSInteger answerId;
@property (nonatomic, strong) NSURL *dir;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) NSInteger getIntegral;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *groupId;

/**
 *点击问题后传给下一个controller的数据
 */
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, assign) NSInteger allAnswers;
@property (nonatomic, assign) NSInteger allIntegral;


@property (nonatomic, assign) BOOL hasPrevPage;
@property (nonatomic, assign) BOOL fromFindView;
@property (nonatomic, assign) BOOL fromHomePage;
@property (nonatomic, assign) BOOL isMaster;

@end
