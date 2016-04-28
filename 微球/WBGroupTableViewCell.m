//
//  WBJoinTableViewCell.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WBMyGroupModel.h"

#define FONT_SIZE [UIFont systemFontOfSize:12]

@implementation WBGroupTableViewCell{
    BOOL _isJoin;
    
    UIImageView *_headIcon;
    UILabel *_groupName;
    UILabel *_numberLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isJoin:(BOOL)isJoin{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _isJoin = isJoin;
        
        [self groupIcon];
        [self groupName];
        [self groupNumbers];
        
    }
    return self;
}

- (void)groupIcon{
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
    _headIcon.layer.masksToBounds = YES;
    _headIcon.layer.cornerRadius = 5;
    _headIcon.contentMode = UIViewContentModeScaleAspectFill;
    _headIcon.backgroundColor = [UIColor initWithBackgroundGray];
    [self.contentView addSubview:_headIcon];
}

- (void)groupName{
    _groupName = [[UILabel alloc] initWithFrame:CGRectMake(66, 0, SCREENWIDTH / 2, 66)];
    _groupName.font = [UIFont boldSystemFontOfSize:14];
    _groupName.textColor = [UIColor initWithLightGray];
    [self.contentView addSubview:_groupName];
}

- (void)groupNumbers{
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 + 75, 0, SCREENWIDTH / 2 - 85, 66)];
    _numberLabel.font = MAINFONTSIZE;
    _numberLabel.textColor = [UIColor initWithLightGray];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_numberLabel];
}

- (void)setModel:(WBMyGroupModel *)model{
    _model = model;
    [_headIcon sd_setImageWithURL:model.dir];
    _groupName.text = [NSString stringWithFormat:@"%@的帮帮团",model.nickName];
    if (_isJoin) {
        _numberLabel.text = [NSString stringWithFormat:@"%ld 问题",(long)model.questions];
    } else {
        _numberLabel.text = [NSString stringWithFormat:@"%ld 回答",(long)model.answers];
    }
}

@end
