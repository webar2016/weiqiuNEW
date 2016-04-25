//
//  WBCollectionViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "WBPositionList.h"

@implementation WBCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mainImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_mainImageView];
        
        _localLabel = [[UILabel alloc] init];
     //   _localLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _localLabel.textColor = [UIColor whiteColor];
        _localLabel.font = MAINFONTSIZE;
       // _localLabel.textAlignment = NSTextAlignmentCenter;
//        _localLabel.layer.masksToBounds = YES;
//        _localLabel.layer.cornerRadius = 3;
        _localLabel.shadowOffset = CGSizeMake(1, 1);
        _localLabel.shadowColor = [UIColor initWithDarkGray];
        
        [_mainImageView addSubview:_localLabel];
        
        _backgroundViewTop = [[UIView alloc]init];
        [self.contentView addSubview:_backgroundViewTop];
        
        _backgroundViewButtom = [[UIView alloc]init];
        [self.contentView addSubview:_backgroundViewButtom];
        _backgroundViewButtom.backgroundColor = [UIColor whiteColor];
        
        _headImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImageView];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 15;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
        [_headImageView addGestureRecognizer:tap];
        
        _nickName = [[UILabel alloc]init];
        [self.contentView addSubview:_nickName];
        _nickName.textColor = [UIColor initWithLightGray];
        
        _timelabel= [[UILabel alloc]init];
        [self.contentView addSubview:_timelabel];
        _timelabel.font = SMALLFONTSIZE;
        _timelabel.textColor = [UIColor initWithLightGray];
        
        _ageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_ageButton];
        _ageButton.layer.cornerRadius = 3;
        
        _leftImageView = [[UIImageView alloc]init];
        [_backgroundViewButtom addSubview:_leftImageView];
        
        _rightImageView = [[UIImageView alloc]init];
        [_backgroundViewButtom addSubview:_rightImageView];
        _rightImageView.image = [UIImage imageNamed:@"icon_member.png"];
       
        
        _leftLabel = [[UILabel alloc]init];
        [_backgroundViewButtom addSubview:_leftLabel];
        _leftLabel.font = FONTSIZE12;
        _leftLabel.textColor = [UIColor initWithLightGray];

        
        _rightLabel = [[UILabel alloc]init];
        [_backgroundViewButtom addSubview:_rightLabel];
        _rightLabel.font = FONTSIZE12;
        _rightLabel.textColor = [UIColor initWithLightGray];
        
        
        self.contentView.backgroundColor = [UIColor initWithBackgroundGray];
        _backgroundViewTop.backgroundColor = [UIColor whiteColor];
    }
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)createUI:(CGFloat)imageHeight withWidth:(CGFloat)labelWidth{
    _mainImageView.frame = CGRectMake(0, 0, CollectionCellWidth, imageHeight);
    
//    NSDictionary * tdic1 = [NSDictionary dictionaryWithObjectsAndKeys:MAINFONTSIZE,NSFontAttributeName,nil];
//    CGSize  actualsize1=[_model.destination boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic1 context:nil].size;
    
    _localLabel.frame = CGRectMake(0, imageHeight - 30, CollectionCellWidth, 30);
    _backgroundViewTop.frame = CGRectMake(0, imageHeight, CollectionCellWidth, 40);
    _headImageView.frame = CGRectMake(4, imageHeight+5, 30, 30);
    

    
    _timelabel.frame = CGRectMake(40, imageHeight+10+15, 80, 10);
//    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
//    CGSize  actualsize =[_model.tblUser.nickname boundingRectWithSize:CGSizeMake(MAXFLOAT, 10) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    _nickName.font = [UIFont systemFontOfSize:12];
    _nickName.frame = CGRectMake(40, imageHeight+10, CollectionCellWidth / 2, 10);
    _ageButton.frame = CGRectMake(40+CollectionCellWidth / 2+10, imageHeight+10, 20, 10);
    
    _backgroundViewButtom.frame = CGRectMake(0, imageHeight+41, CollectionCellWidth, 23);
    _leftImageView.frame = CGRectMake(5, 1, 17, 17);
    _leftLabel.frame =CGRectMake(20, 3, (CollectionCellWidth)/2, 13);
    _rightImageView.frame =CGRectMake((CollectionCellWidth)/2+5, 1, 17, 17);
    _rightLabel.frame = CGRectMake((CollectionCellWidth)/2+20, 3, 100, 13);
}

- (void)setModel:(WBCollectionViewModel *)model imageHeight:(CGFloat)imageHeight{
    self.model = model;
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
    CGSize  actualsize =[model.beginTime boundingRectWithSize:CGSizeMake(MAXFLOAT, 10) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    [self createUI:imageHeight withWidth:actualsize.width];
    //大图
   [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    
    _localLabel.text = [NSString stringWithFormat:@"  %@",model.destination];
   
   [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];

    _nickName.text = model.tblUser.nickname;
    
    _timelabel.text = model.beginTime;

    if ([model.tblUser.sex isEqualToString:@"男"]) {
        [_ageButton setImage:[UIImage imageNamed:@"icon_male.png"] forState:UIControlStateNormal];
        _ageButton.backgroundColor = [UIColor initWithGreen];

    }else{
        [_ageButton setImage:[UIImage imageNamed:@"icon_female.png"] forState:UIControlStateNormal];
        _ageButton.backgroundColor =[UIColor initWithPink];
    }
    
    [_ageButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.tblUser.age]  forState:UIControlStateNormal];
    _ageButton.titleLabel.font = SMALLFONTSIZE;

    _leftImageView.image = [UIImage imageNamed:@"icon_qiupiao.png"];
    
    if (model.rewardIntegral>999) {
        _leftLabel.text = [NSString stringWithFormat:@" %.1fK球币",(float)model.rewardIntegral/1000];
    }else{
    _leftLabel.text = [NSString stringWithFormat:@" %ld球币",(long)model.rewardIntegral];
    }
    _rightLabel.text = [NSString stringWithFormat:@" %ld团员",(long)model.members];
}
//去往个人主页
-(void)goHomePage:(UITapGestureRecognizer *)tap{
    [self.delegate goHomepage:[NSString stringWithFormat:@"%ld",(long)_model.userId]];
}


@end
