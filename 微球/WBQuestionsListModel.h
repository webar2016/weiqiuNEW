//
//  WBQuestionsListModel.h
//  微球
//
//  Created by 徐亮 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBSingleAnswerModel.h"

@interface WBQuestionsListModel : NSObject

@property (nonatomic, assign) NSInteger allAnswers;

@property (nonatomic, assign) NSInteger allIntegral;

@property (nonatomic, assign) NSInteger questionId;

@property (nonatomic, copy) NSString *questionText;

@property (nonatomic, strong) WBSingleAnswerModel *hga;

@end
