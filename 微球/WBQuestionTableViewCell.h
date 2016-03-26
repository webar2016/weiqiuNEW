//
//  WBQuestionTableViewCell.h
//  微球
//
//  Created by 徐亮 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBQuestionTableViewCell;
@protocol WBQuestionTableViewCellDelegate <NSObject>
@optional
- (void)questionView:(WBQuestionTableViewCell *)cell;
- (void)answerView:(WBQuestionTableViewCell *)cell;
- (void)iconView:(WBQuestionTableViewCell *)cell;
@end

@interface WBQuestionTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WBQuestionTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIView *wraperView;

@property (nonatomic, strong) UIView *questionView;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIImageView *questionSpread;

@property (nonatomic, strong) UIView *answerView;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, retain) id model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(id)model;

@end
