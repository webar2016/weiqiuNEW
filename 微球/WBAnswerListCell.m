//
//  WBAnswerListCell.m
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAnswerListCell.h"

#import "NSString+string.h"
#import "UIImageView+WebCache.h"

@interface WBAnswerListCell ()

@end

@implementation WBAnswerListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _margin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        _margin.backgroundColor = [UIColor initWithBackgroundGray];
        
        [self setUpHeadIcon];
        
        [self setUpNickName];
        
        [self setUpAnswer];
        
        [self setUpScore];
        
        [self setUpUnit];
        
        [self addSubview:_margin];
        [self addSubview:_nickName];
        [self addSubview:_userIcon];
        [self addSubview:_answer];
        [self addSubview:_score];
        [self addSubview:_unit];
    }
    return self;
}

-(void)setUpHeadIcon{
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGINOUTSIDE, MARGINOUTSIDE, 26, 26)];
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.borderColor = [UIColor initWithGreen].CGColor;
    _userIcon.layer.borderWidth = 1;
    _userIcon.layer.cornerRadius = 13;
}

-(void)setUpNickName{
    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(MARGINOUTSIDE * 3 + 26, MARGINOUTSIDE + 6, SCREENWIDTH / 2, 14)];
    _nickName.font = MAINFONTSIZE;
    _nickName.textColor = [UIColor initWithLightGray];
}

-(void)setUpAnswer{
    _answer = [[UILabel alloc] initWithFrame:CGRectZero];
    _answer.font = MAINFONTSIZE;
    _answer.textColor = [UIColor initWithNormalGray];
}

-(void)setUpScore{
    _score = [[UILabel alloc] initWithFrame:CGRectMake(MARGINOUTSIDE / 2, 26 + MARGINOUTSIDE * 1.5, 26 + MARGINOUTSIDE, 14)];
    _score.font = SMALLFONTSIZE;
    _score.textColor = [UIColor whiteColor];
    _score.textAlignment = NSTextAlignmentCenter;
    _score.backgroundColor = [UIColor initWithGreen];
    _score.layer.masksToBounds = YES;
    _score.layer.cornerRadius = 3;
}

-(void)setUpUnit{
    _unit = [[UILabel alloc] initWithFrame:CGRectMake(MARGINOUTSIDE, MARGINOUTSIDE * 2 + 43, 20, 14)];
    _unit.text = @"球币";
    _unit.font = SMALLFONTSIZE;
    _unit.textAlignment = NSTextAlignmentCenter;
    _unit.textColor = [UIColor initWithNormalGray];
    _unit.center = CGPointMake(MARGINOUTSIDE + 13, MARGINOUTSIDE * 2 + 43);
}

#pragma mark - 添加数据

-(void)setModel:(WBSingleAnswerModel *)model{
    _model = model;
    
    _nickName.text = model.tblUser.nickname;
    
    _answer.text = [model.answerText replaceImageSign];
    CGSize size = [_answer.text adjustSizeWithWidth:(SCREENWIDTH -MARGINOUTSIDE * 3 - 35) andFont:MAINFONTSIZE];
    size.height > 51 ? size.height = 51 : size.height;
    _answer.numberOfLines = 3;
    _answer.frame = (CGRect){{MARGINOUTSIDE * 3 + 26, MARGINOUTSIDE * 1.5 + 20}, {size.width,size.height + 14}};
    
    [_userIcon sd_setImageWithURL:model.tblUser.dir];
    
    float score = (float)model.getIntegral;
    if (score >= 1000) {
        score = score / 1000;
        _score.text = [NSString stringWithFormat:@"%dk",(int)score];
    }else{
        _score.text = [NSString stringWithFormat: @"%ld", (long)score];
    }
}

+(CGFloat)getCellHeightWithModel:(WBSingleAnswerModel *)model{
    CGFloat answerHeight = [[model.answerText replaceImageSign] adjustSizeWithWidth:(SCREENWIDTH -MARGINOUTSIDE * 3 - 35) andFont:MAINFONTSIZE].height;
    answerHeight > 51 ? answerHeight = 51 : answerHeight;
    return MAX(MARGINOUTSIDE * 2 + 57, answerHeight + MARGINOUTSIDE * 1.5 + 34);
}


@end
