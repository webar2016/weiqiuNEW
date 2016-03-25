//
//  WBSingleAnswerModel.h
//  微球
//
//  Created by 徐亮 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUserInfosModel.h"

@interface WBSingleAnswerModel : NSObject

@property (nonatomic, assign) NSInteger answerId;

@property (nonatomic, assign) NSInteger getIntegral;

@property (nonatomic, copy) NSString *answerText;

@property (nonatomic, copy) NSString *dir;

@property (nonatomic, strong) WBUserInfosModel *tblUser;

@property (nonatomic, copy) NSString *timeStr;

@property (nonatomic, assign) NSInteger questionId;

@property (nonatomic, copy) NSString *questionText;

@end
