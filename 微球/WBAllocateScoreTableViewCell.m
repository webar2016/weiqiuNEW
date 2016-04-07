//
//  WBAllocateScoreTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAllocateScoreTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WBAllocateScoreTableViewCell
{
    UIView *_backgroundView;
    UIImageView *_headImage;
    UILabel *_nickNamelabel;
    UILabel *_contentLabel;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UILabel *_scoreLabel;
    

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor initWithBackgroundGray];
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 67)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backgroundView];
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 48, 48)];
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 24;
        _headImage.backgroundColor = [UIColor initWithBackgroundGray];
        [self.contentView addSubview:_headImage];
        
        _nickNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(48+20, 10, SCREENWIDTH / 2, 24)];
        _nickNamelabel.font = MAINFONTSIZE;
        _nickNamelabel.textColor = [UIColor initWithLightGray];
        [self.contentView addSubview:_nickNamelabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(48+20, 34, SCREENWIDTH / 2, 24)];
        _contentLabel.font = FONTSIZE12;
        _contentLabel.textColor = [UIColor initWithDarkGray];
        [self.contentView addSubview:_contentLabel];
        
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 20, 20) ;
        _leftButton.center = CGPointMake(SCREENWIDTH - 85, 33.5);
        [_leftButton setImage:[UIImage imageNamed:@"icon_minus.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_leftButton];
        [_leftButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        _scoreLabel.center = CGPointMake(SCREENWIDTH - 50, 33.5);
        _scoreLabel.layer.masksToBounds = YES;
        _scoreLabel.layer.cornerRadius = 18;
        _scoreLabel.backgroundColor = [UIColor initWithGreen];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.font = MAINFONTSIZE;
        _scoreLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_scoreLabel];
        
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 20, 20) ;
        _rightButton.center = CGPointMake(SCREENWIDTH - 15, 33.5);
        [_rightButton setImage:[UIImage imageNamed:@"icon_add_abled.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_rightButton];
         [_rightButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;

}

-(void)btnClicked:(UIButton *)btn{

    [self.delegate buttonClickedEvent:btn];
}


-(void)setModel:(WBAllocateScoreModel *)model cellScore:(NSString *)cellScore indexPath:(NSIndexPath *)indexPath{
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    
    _nickNamelabel.text = model.nickname;
    
    _contentLabel.text = [NSString stringWithFormat:@"回答了%ld个问题",(long)model.qNum];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%.0f",[cellScore floatValue]];
    
    _scoreLabel.tag = 100+indexPath.row*10;
    _leftButton.tag = 100+indexPath.row*10+1;
    _rightButton.tag = 100+indexPath.row*10+2;

}

@end
