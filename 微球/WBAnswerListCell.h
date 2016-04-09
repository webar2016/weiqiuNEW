//
//  WBAnswerListCell.h
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSingleAnswerModel.h"

@interface WBAnswerListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *answer;
@property (nonatomic, strong) UILabel *score;
@property (nonatomic, strong) UILabel *unit;
@property (nonatomic, strong) UIView *margin;

@property (nonatomic, strong) WBSingleAnswerModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

+(CGFloat)getCellHeightWithModel:(WBSingleAnswerModel *)model;

@end
