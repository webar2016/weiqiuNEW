//
//  WBUserListTableViewCell.m
//  微球
//
//  Created by 徐亮 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUserListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WBUserListTableViewCell {
    UIImageView *_headIcon;
    UILabel *_nickName;
    UILabel *_profile;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13.5, 48, 48)];
        _headIcon.layer.masksToBounds = YES;
        _headIcon.layer.cornerRadius = 24;
        
        _nickName = [[UILabel alloc] initWithFrame:CGRectMake(76, 13.5, SCREENWIDTH - 76, 20)];
        _nickName.font = MAINFONTSIZE;
        _nickName.textColor = [UIColor initWithGreen];
        
        _profile = [[UILabel alloc] initWithFrame:CGRectMake(76, 41.5, SCREENWIDTH - 76, 20)];
        _profile.font = FONTSIZE12;
        _profile.textColor = [UIColor initWithNormalGray];
        
        [self addSubview:_headIcon];
        [self addSubview:_nickName];
        [self addSubview:_profile];
    }
    return self;
}

-(void)setModel:(WBUserInfosModel *)model{
    _model = model;
    
    [_headIcon sd_setImageWithURL:model.dir placeholderImage:[UIImage imageNamed:@"placeholder-17"]];
    _nickName.text = model.nickname;
    _profile.text = model.profile;
}

@end
