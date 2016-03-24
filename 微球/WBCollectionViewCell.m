//
//  WBCollectionViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBCollectionViewCell.h"
#import "UIImageView+WebCache.h"
/*
 UIImageView *_mainImageView;
 UIView *_backgroundViewTop;
 UIView *_backgroundViewButtom;
 UIImageView *_headImageView;
 UIButton *_ageButton;
 UIImageView *_leftImageView;
 UIImageView *_rightImageView;
 UILabel *_leftLabel;
 UILabel *_rightLabel;*/
@implementation WBCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mainImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_mainImageView];
        
        _backgroundViewTop = [[UIView alloc]init];
        [self.contentView addSubview:_backgroundViewTop];
        
        _backgroundViewButtom = [[UIView alloc]init];
        [self.contentView addSubview:_backgroundViewButtom];
        
        _headImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImageView];
        
        _nickName = [[UILabel alloc]init];
        [self.contentView addSubview:_nickName];
        
        _timelabel= [[UILabel alloc]init];
        [self.contentView addSubview:_timelabel];
        
        _ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_ageButton];
        
        _leftImageView = [[UIImageView alloc]init];
        [_backgroundViewButtom addSubview:_leftImageView];
        
        _rightImageView = [[UIImageView alloc]init];
        [_backgroundViewButtom addSubview:_rightImageView];
        
        _leftLabel = [[UILabel alloc]init];
        [_backgroundViewButtom addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc]init];
        [_backgroundViewButtom addSubview:_rightLabel];
        
        self.contentView.backgroundColor = [UIColor initWithBackgroundGray];
        //beijin
        
        _backgroundViewTop.backgroundColor = [UIColor whiteColor];
       // _mainImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
       // _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_mainImageView.clipsToBounds = YES;
        //_mainImageView.backgroundColor = [UIColor greenColor];
        _mainImageView.layer.cornerRadius = 5.0f;
        _mainImageView.layer.masksToBounds = YES;
    }
    return self;
}
- (void)createUI:(CGFloat)imageHeight{
    
        
    _mainImageView.frame = CGRectMake(0, 0, CollectionCellWidth, imageHeight);
    _backgroundViewTop.frame = CGRectMake(0, imageHeight, CollectionCellWidth, 40);
    _headImageView.frame = CGRectMake(4, imageHeight+5, 30, 30);
    _nickName.frame = CGRectMake(40, imageHeight+10, 80, 10);
    _timelabel.frame = CGRectMake(40, imageHeight+10+15, 80, 10);
    _ageButton.frame = CGRectMake(130, imageHeight+10, 20, 10);
    _leftImageView.frame = CGRectMake(6.5, 3, 13, 13);
    _backgroundViewButtom.frame = CGRectMake(0, imageHeight+42, CollectionCellWidth, 20);
    _leftLabel.frame =CGRectMake(25, 3, 100, 13);
    _rightImageView.frame =CGRectMake(100, 3, 13, 13);
    _rightLabel.frame = CGRectMake(120, 3, 100, 13);



}

- (void)setModel:(WBCollectionViewModel *)model imageHeight:(CGFloat)imageHeight{
    [self createUI:imageHeight];
    
    
    //大图
    

    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    
    
   
    
   
   [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 15;
    
   
    _nickName.text = model.tblUser.nickname;
    _nickName.font = [UIFont systemFontOfSize:12];
    _nickName.textColor = [UIColor initWithLightGray];
    
   
    _timelabel.text = model.beginTime;
    _timelabel.font = SMALLFONTSIZE;
    _timelabel.textColor = [UIColor initWithLightGray];

       _ageButton.layer.cornerRadius = 3;
    [_ageButton setImage:[UIImage imageNamed:@"icon_male.png"] forState:UIControlStateNormal];
    [_ageButton setTitle:[NSString stringWithFormat:@"%ld",model.tblUser.age]  forState:UIControlStateNormal];
    _ageButton.backgroundColor = [UIColor initWithGreen];
    _ageButton.titleLabel.font = SMALLFONTSIZE;
    
        _backgroundViewButtom.backgroundColor = [UIColor whiteColor];
    
   
    _leftImageView.image = [UIImage imageNamed:@"icon_qiupiao.png"];
    
        _leftLabel.text = [NSString stringWithFormat:@"%ld球票",model.rewardIntegral];
    _leftLabel.font = MAINFONTSIZE;
    _leftLabel.textColor = [UIColor initWithLightGray];
    
    
    
    _rightImageView.image = [UIImage imageNamed:@"icon_member.png"];
    
    
    _rightLabel.text = [NSString stringWithFormat:@"%ld球票",model.members];
    _rightLabel.font = MAINFONTSIZE;
    _rightLabel.textColor = [UIColor initWithLightGray];
    
  //  [self setFrame:_mainImageView.frame];
  //  NSLog(@"------cell ------");

}



@end
