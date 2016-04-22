//
//  WBQuestionTableViewCell.m
//  微球
//
//  Created by 徐亮 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBQuestionTableViewCell.h"
#import "WBQuestionsListModel.h"
#import "WBSingleAnswerModel.h"

#import "UIImageView+WebCache.h"
#import "UILabel+label.h"
#import "NSString+string.h"

@interface WBQuestionTableViewCell ()

@end

@implementation WBQuestionTableViewCell

#pragma mark - 自定义cell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpQuestion];
        
        [self setUpAnswer];
        
        [self setUpWraper];
        
        [self addGestureRecognizer];
    }
    return self;
}

#pragma mark - 创建子控件

-(void)setUpQuestion{
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _questionLabel.font = MAINFONTSIZE;
    _questionLabel.textColor = [UIColor initWithDarkGray];
    
    _questionSpread = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_spread"]];
    
    _questionView = [[UIView alloc] initWithFrame:CGRectZero];
    _questionView.backgroundColor = [UIColor whiteColor];
    
    [_questionView addSubview:_questionSpread];
    [_questionView addSubview:_questionLabel];
}

-(void)setUpAnswer{
    
    _answerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _answerLabel.font = MAINFONTSIZE;
    _answerLabel.textColor = [UIColor initWithNormalGray];

    _userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];//CGRectMake(MARGININSIDE, MARGININSIDE, 26, 26)
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.borderColor = [UIColor initWithGreen].CGColor;
    _userIcon.layer.borderWidth = 1;
    _userIcon.layer.cornerRadius = 13;
    _userIcon.userInteractionEnabled = YES;
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];//CGRectMake(MARGININSIDE - 2, MARGININSIDE + 30, 26 + MARGINOUTSIDE, 14)
    _scoreLabel.font = SMALLFONTSIZE;
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.backgroundColor = [UIColor initWithGreen];
    _scoreLabel.center = CGPointMake(MARGININSIDE + 13, MARGININSIDE + 37);
    _scoreLabel.layer.masksToBounds = YES;
    _scoreLabel.layer.cornerRadius = 3;
    
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];//CGRectMake(MARGININSIDE, MARGININSIDE + 500, 20, 14)
    _unitLabel.text = @"球币";
    _unitLabel.font = SMALLFONTSIZE;
    _unitLabel.textAlignment = NSTextAlignmentCenter;
    _unitLabel.textColor = [UIColor initWithNormalGray];
    _unitLabel.center = CGPointMake(MARGININSIDE + 13, MARGININSIDE + 52);
    
    _answerView = [[UIView alloc] initWithFrame:CGRectZero];
    _answerView.backgroundColor = [UIColor whiteColor];
    
    [_answerView addSubview:_scoreLabel];
    [_answerView addSubview:_unitLabel];
    [_answerView addSubview:_userIcon];
    [_answerView addSubview:_answerLabel];
}

-(void)setUpWraper{
    _wraperView = [[UIView alloc] initWithFrame:CGRectZero];
    _wraperView.layer.masksToBounds = YES;
    _wraperView.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor clearColor];
    [_wraperView addSubview:_questionView];
    [_wraperView addSubview:_answerView];
    [self addSubview:_wraperView];
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

-(void)setModel:(id)model{
    _model = model;
    if ([model isKindOfClass:[WBQuestionsListModel class]]) {
        
        WBQuestionsListModel *currentModel = model;
        NSString *text = [NSString stringWithFormat:@"【%@】%@",currentModel.cityStr,currentModel.questionText];
        CGSize quesSize = [text adjustSizeWithWidth:(CELLWIDTH - 65) andFont:MAINFONTSIZE];
        _questionLabel.frame = (CGRect){{MARGININSIDE, MARGININSIDE - 14/2}, {quesSize.width,quesSize.height + 14}};
        _questionLabel.text = text;
        _questionLabel.numberOfLines = 0;
        [_questionLabel setLineSpace:LINESPACE withContent:text];
        
        _questionSpread.center = CGPointMake(CELLWIDTH -20, quesSize.height / 2 + MARGININSIDE);
        _questionView.frame = CGRectMake(0, 0, CELLWIDTH, quesSize.height + 1 + MARGININSIDE * 2);
        CGFloat maxHeight = CGRectGetMaxY(_questionView.frame);
        
        if (currentModel.hga.answerText) {
            NSString *answerText = [currentModel.hga.answerText replaceImageSign];
            
            CGFloat quseViewMaxHeight = CGRectGetMaxY(_questionView.frame);
            _answerView.frame = CGRectMake(0, quseViewMaxHeight +1, CELLWIDTH, 80);
            
            CGSize answSize = [answerText adjustSizeWithWidth:(CELLWIDTH - 65 - MARGININSIDE) andFont:MAINFONTSIZE];
            answSize.height > 51 ? answSize.height = 51 : answSize.height;
            _answerLabel.frame = (CGRect){{60, MARGININSIDE }, {CELLWIDTH - 65 - MARGININSIDE,answSize.height}};
            _answerLabel.text = answerText;
            _answerLabel.numberOfLines = 3;
            
            _userIcon.frame = CGRectMake(MARGININSIDE, MARGININSIDE, 26, 26);
            _scoreLabel.frame = CGRectMake(MARGININSIDE - 2, MARGININSIDE + 30, 26 + MARGINOUTSIDE, 14);
            _unitLabel.frame = CGRectMake(MARGININSIDE, MARGININSIDE + 500, 20, 14);
            
            [_userIcon sd_setImageWithURL:currentModel.hga.tblUser.dir];
            
            float score = (float)currentModel.hga.getIntegral;
            if (score >= 1000) {
                score = score / 1000;
                _scoreLabel.text = [NSString stringWithFormat:@"%.1fk",score];
            }else{
                _scoreLabel.text = [NSString stringWithFormat: @"%ld", (long)score];
            }
            maxHeight = CGRectGetMaxY(_answerView.frame);
        }
        _wraperView.frame = CGRectMake(MARGINLEFT, 10, CELLWIDTH, maxHeight);
        
    } else if ([model isKindOfClass:[WBSingleAnswerModel class]]) {
        
        WBSingleAnswerModel *currentModel = model;
        NSString *text = [NSString stringWithFormat:@"【%@】%@",currentModel.cityStr,currentModel.questionText];
        CGSize quesSize = [text adjustSizeWithWidth:(CELLWIDTH - 65) andFont:MAINFONTSIZE];
        _questionLabel.frame = (CGRect){{MARGININSIDE, MARGININSIDE - 14/2}, {quesSize.width,quesSize.height + 14}};
        _questionLabel.text = text;
        _questionLabel.numberOfLines = 0;
        [_questionLabel setLineSpace:LINESPACE withContent:text];
        
        _questionSpread.center = CGPointMake(CELLWIDTH -20, quesSize.height / 2 + MARGININSIDE);
        _questionView.frame = CGRectMake(0, 0, CELLWIDTH, quesSize.height + 1 + MARGININSIDE * 2);
        CGFloat maxHeight = CGRectGetMaxY(_questionView.frame);
        
        if (currentModel.answerText) {
            NSString *answerText = [currentModel.answerText replaceImageSign];
            
            CGFloat quseViewMaxHeight = CGRectGetMaxY(_questionView.frame);
            _answerView.frame = CGRectMake(0, quseViewMaxHeight +1, CELLWIDTH, 80);
            
            CGSize answSize = [answerText adjustSizeWithWidth:(CELLWIDTH - 65 - MARGININSIDE) andFont:MAINFONTSIZE];
            answSize.height > 51 ? answSize.height = 51 : answSize.height;
            _answerLabel.frame = (CGRect){{60, MARGININSIDE }, {CELLWIDTH - 65 - MARGININSIDE,answSize.height}};
            _answerLabel.text = answerText;
            _answerLabel.numberOfLines = 3;
            
            _userIcon.frame = CGRectMake(MARGININSIDE, MARGININSIDE, 26, 26);
            _scoreLabel.frame = CGRectMake(MARGININSIDE - 2, MARGININSIDE + 30, 26 + MARGINOUTSIDE, 14);
            _unitLabel.frame = CGRectMake(MARGININSIDE, MARGININSIDE + 500, 20, 14);
            
            [_userIcon sd_setImageWithURL:currentModel.tblUser.dir];
            
            float score = (float)currentModel.getIntegral;
            if (score >= 1000) {
                score = score / 1000;
                _scoreLabel.text = [NSString stringWithFormat:@"%dk",(int)score];
            }else{
                _scoreLabel.text = [NSString stringWithFormat: @"%ld", (long)score];
            }
            maxHeight = CGRectGetMaxY(_answerView.frame);
        }
        _wraperView.frame = CGRectMake(MARGINLEFT, 10, CELLWIDTH, maxHeight);
        
    } else {
        NSLog(@"数据错误");
    }
}

+(CGFloat)getCellHeightWithModel:(id)model{
    if ([model isKindOfClass:[WBQuestionsListModel class]]) {
        
        WBQuestionsListModel *currentModel = model;
        
        CGFloat questionHeight = [[NSString stringWithFormat:@"【%@】%@",currentModel.cityStr,currentModel.questionText]  adjustSizeWithWidth:(CELLWIDTH - 65) andFont:MAINFONTSIZE].height + 1 + MARGININSIDE * 2;
        
        CGFloat answerHeight = 0;
        if (currentModel.hga.answerText) {
            answerHeight = 81;
        }
        
        return questionHeight +answerHeight + 10;
        
    } else if ([model isKindOfClass:[WBSingleAnswerModel class]]) {
        
        WBSingleAnswerModel *currentModel = model;
        
        CGFloat questionHeight = [[NSString stringWithFormat:@"【%@】%@",currentModel.cityStr,currentModel.questionText]  adjustSizeWithWidth:(CELLWIDTH - 65) andFont:MAINFONTSIZE].height + 1 + MARGININSIDE * 2;
        
        CGFloat answerHeight = 0;
        if (currentModel.answerText) {
            answerHeight = 81;
        }
        
        return questionHeight +answerHeight + 10;
        
    } else {
        NSLog(@"数据错误");
        return 0;
    }
}
@end
