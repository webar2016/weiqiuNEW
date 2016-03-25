//
//  WBHomeSecondTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WBSingleAnswerModel.h"

@class WBHomeSecondTableViewCell;
@protocol WBHomeSecondTableViewCell <NSObject>
@optional
- (void)questionView:(WBHomeSecondTableViewCell *)cell;
- (void)answerView:(WBHomeSecondTableViewCell *)cell;
@end

@interface WBHomeSecondTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WBHomeSecondTableViewCell> delegate;

@property (nonatomic, strong) UIView *wraperView;

@property (nonatomic, strong) UIView *questionView;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIImageView *questionSpread;

@property (nonatomic, strong) UIView *answerView;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, retain) WBSingleAnswerModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(WBSingleAnswerModel *)model;

@end