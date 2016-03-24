//
//  WBQuestionTableViewCell.m
//  微球
//
//  Created by 徐亮 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBQuestionTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "UILabel+label.h"
#import "NSString+string.h"

@interface WBQuestionTableViewCell ()

@property (nonatomic, assign) CGFloat maxHeight;

@end

@implementation WBQuestionTableViewCell

#pragma mark - 自定义cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withData:(WBQuestionsListModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpQuestionByText:model.questionText];
        
        [self setUpAnswerByText:model.hga.answerText];
        
        [self addGestureRecognizer];
        
        [self setUpWraper];
        
        [self addSubview:_wraperView];
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, SCREENWIDTH, _maxHeight + MARGINOUTSIDE);
    }
    return self;
}

#pragma mark - 创建子控件

-(void)setUpQuestionByText:(NSString *)text{
    
    CGSize quesSize = [text adjustSizeWithWidth:(CELLWIDTH - 65) andFont:MAINFONTSIZE];
    _questionLabel = [[UILabel alloc] initWithFrame:(CGRect){{MARGININSIDE, MARGININSIDE - 14/2}, {quesSize.width,quesSize.height + 14}}]; //14 --- MAINFONTSIZE
    _questionLabel.font = MAINFONTSIZE;
    _questionLabel.textColor = [UIColor initWithDarkGray];
    
    _questionSpread = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spread"]];
    _questionSpread.center = CGPointMake(CELLWIDTH -20, quesSize.height / 2 + MARGININSIDE);
    
    _questionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CELLWIDTH, quesSize.height + 1 + MARGININSIDE * 2)];
    _questionView.backgroundColor = [UIColor whiteColor];
    
    [_questionView addSubview:_questionSpread];
    [_questionView addSubview:_questionLabel];
}

-(void)setUpAnswerByText:(NSString *)text{
    if (text == nil) {
        return;
    }
    
    CGFloat quseViewMaxHeight = CGRectGetMaxY(_questionView.frame);
    CGSize answSize = [text adjustSizeWithWidth:(CELLWIDTH - 65 - MARGININSIDE) andFont:MAINFONTSIZE];
    answSize.height > 51 ? answSize.height = 51 : answSize.height;
    _answerLabel = [[UILabel alloc] initWithFrame:(CGRect){{60, MARGININSIDE }, answSize}];
    _answerLabel.font = MAINFONTSIZE;
    _answerLabel.textColor = [UIColor initWithNormalGray];
    
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGININSIDE, MARGININSIDE, 26, 26)];
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.borderColor = [UIColor initWithGreen].CGColor;
    _userIcon.layer.borderWidth = 1;
    _userIcon.layer.cornerRadius = 13;
    _userIcon.userInteractionEnabled = YES;
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGININSIDE - 2, MARGININSIDE + 30, 26 + MARGINOUTSIDE, 14)];
    _scoreLabel.font = SMALLFONTSIZE;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.backgroundColor = [UIColor initWithGreen];
    _scoreLabel.center = CGPointMake(MARGININSIDE + 13, MARGININSIDE + 37);
    _scoreLabel.layer.masksToBounds = YES;
    _scoreLabel.layer.cornerRadius = 3;
    
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGININSIDE, MARGININSIDE + 500, 20, 14)];
    _unitLabel.text = @"球票";
    _unitLabel.font = SMALLFONTSIZE;
    _unitLabel.textAlignment = NSTextAlignmentCenter;
    _unitLabel.textColor = [UIColor initWithNormalGray];
    _unitLabel.center = CGPointMake(MARGININSIDE + 13, MARGININSIDE + 52);
    
    _answerView = [[UIView alloc] initWithFrame:CGRectMake(0, quseViewMaxHeight +1, CELLWIDTH, 80)];
    _answerView.backgroundColor = [UIColor whiteColor];
    
    [_answerView addSubview:_scoreLabel];
    [_answerView addSubview:_unitLabel];
    [_answerView addSubview:_userIcon];
    [_answerView addSubview:_answerLabel];
}

-(void)setUpWraper{
    if (_answerView) {
        _maxHeight = CGRectGetMaxY(_answerView.frame);
    }else{
        _maxHeight = CGRectGetMaxY(_questionView.frame);
    }
    
    _wraperView = [[UIView alloc] initWithFrame:CGRectMake(MARGINLEFT, 10, CELLWIDTH, _maxHeight)];
    _wraperView.layer.masksToBounds = YES;
    _wraperView.layer.cornerRadius = 10;
    
    [_wraperView addSubview:_questionView];
    [_wraperView addSubview:_answerView];
}

#pragma mark - 添加点击事件

-(void)addGestureRecognizer{
    UITapGestureRecognizer *questionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questionTap)];
    [_questionView addGestureRecognizer:questionTap];
    
    UITapGestureRecognizer *answerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerTap)];
    [_answerView addGestureRecognizer:answerTap];
    
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
    [_userIcon addGestureRecognizer:iconTap];
}

-(void)questionTap{
    if (_delegate && [_delegate respondsToSelector:@selector(questionView:)]) {
        [_delegate questionView:self];
    }
}
    
-(void)answerTap{
    if (_delegate && [_delegate respondsToSelector:@selector(answerView:)]) {
        [_delegate answerView:self];
    }
}

-(void)iconTap{
    if (_delegate && [_delegate respondsToSelector:@selector(iconView:)]) {
        [_delegate iconView:self];
    }
}

#pragma mark - 添加数据

-(void)setModel:(WBQuestionsListModel *)model{
    _model = model;
    _questionLabel.text = model.questionText;
    _questionLabel.numberOfLines = 0;
    [_questionLabel setLineSpace:LINESPACE withContent:model.questionText];
    
    _answerLabel.text = [model.hga.answerText replaceImageSign];
    _answerLabel.numberOfLines = 3;
    
    [_userIcon sd_setImageWithURL:model.hga.tblUser.dir];
    
    float score = (float)model.hga.getIntegral;
    if (score >= 1000) {
        score = score / 1000;
        _scoreLabel.text = [NSString stringWithFormat:@"%.1fk",score];
    }else{
        _scoreLabel.text = [NSString stringWithFormat: @"%ld", (long)score];
    }
    
}
@end
