//
//  WBHomeHeadTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHomeHeadTableViewCell.h"
#import "WBDataModifiedViewController.h"
#import "UIImageView+WebCache.h"

@implementation WBHomeHeadTableViewCell
{
    
    UIImageView *_backgroundImageView;
    UIImageView *_headImageView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UILabel *_nickNameLabel;
    UILabel *_attentionLabel;
    UIButton *_attentionLeftButton;
    UIButton *_attentionRightButton;
    
    UIButton *_attentionButton;
    UIPageViewController *_pageViewController;
    
    
    UIView *_lineView;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSelfHomePage:(BOOL)isSelfHomePage
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 168)];
        _backgroundImageView.backgroundColor = [UIColor initWithBackgroundGray];
        _backgroundImageView.tag = 101;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBankgroundImage)];
        [_backgroundImageView addGestureRecognizer:tap];
        [self.contentView addSubview:_backgroundImageView];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-32, 168-32, 64, 64)];
        _headImageView.backgroundColor = [UIColor initWithDarkGray];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 32;
        _headImageView.tag = 102;
        [self.contentView addSubview:_headImageView];
        _headImageView.image = [WBUserDefaults headIcon];
        
        //个人资料修改
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"icon_personalinfo.png"] forState:UIControlStateNormal];
        _leftButton.tag = 400;
        _leftButton.frame = CGRectMake(10, 168+6, 32, 32);
        [_leftButton addTarget:self action:@selector(selfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //个人信息
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"icon_chat.png"] forState:UIControlStateNormal];
        _rightButton.frame = CGRectMake(SCREENWIDTH-10-32, 168+6, 32, 32);
        // 判断是不是自己访问自己的个人主页
        
        if (isSelfHomePage) {
            [self.contentView addSubview:_leftButton];
            [self.contentView addSubview:_rightButton];
        }
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-100, 168+32+20, 200, 20)];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.translatesAutoresizingMaskIntoConstraints = YES;
        _nickNameLabel.tag = 402;
        [self.contentView addSubview:_nickNameLabel];
        
        _attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-100, 168+32+20+30, 200, 20)];
        _attentionLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_attentionLabel];
        
        _attentionLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionLeftButton.frame = CGRectMake(SCREENWIDTH/2-100, 168+32+20+30, 95, 20);
        [self.contentView addSubview:_attentionLeftButton];
        _attentionLeftButton.titleLabel.font = MAINFONTSIZE;
        _attentionLeftButton.tag = 500;
        [_attentionLeftButton addTarget:self action:@selector(selfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_attentionLeftButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_attentionLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        _attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-5, 168+32+20+30, 10, 20)];
        _attentionLabel.text = @".";
        [self.contentView addSubview:_attentionLabel];
        
        
        _attentionRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionRightButton.frame = CGRectMake(SCREENWIDTH/2+5, 168+32+20+30, 95, 20);
        [self.contentView addSubview:_attentionRightButton];
        _attentionRightButton.titleLabel.font = MAINFONTSIZE;
        _attentionRightButton.tag = 501;
        [_attentionRightButton addTarget:self action:@selector(selfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_attentionRightButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_attentionRightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.backgroundColor = [UIColor initWithGreen];
        _attentionButton.frame = CGRectMake(SCREENWIDTH/2-25, 168+32+20+30+41, 50, 20) ;
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attentionButton.layer.masksToBounds = YES;
        _attentionButton.layer.cornerRadius = 3;
        _attentionButton.titleLabel.font = MAINFONTSIZE;
        // 判断是不是自己访问自己的个人主页
        
        if (!isSelfHomePage) {
            [self.contentView addSubview:_attentionButton];
        }
        
        NSArray *buttonNameArray = @[@"频道问题",@"问题",@"地图"];
        for (NSInteger i=0; i<3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*SCREENWIDTH/3, 168+32+20+30+41+20+29, SCREENWIDTH/3, 20);
            [button setTitle:buttonNameArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            button.tag = 200+i;
            [button addTarget:self action:@selector(changeViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 168+32+20+30+41+20+29+30, SCREENWIDTH/3, 2)];
        _lineView.backgroundColor = [UIColor initWithGreen];
        [self.contentView addSubview:_lineView];
        _lineView.tag = 300;
        
        UIView *seperateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 168+32+20+30+41+20+29+30+2, SCREENWIDTH, 8)];
        seperateLine.backgroundColor = [UIColor initWithBackgroundGray];
        [self.contentView addSubview:seperateLine];
    }
    return self;
}

//跳转到个人资料修改页面
-(void)selfBtnClicked:(UIButton *)btn{
  //  NSLog(@"------btn-----");
    [self.delegate pushViewBtnClicked:btn];
    
}

//切换页面事件
-(void)changeViewBtnClicked:(UIButton *)btn{
    UIView *lineView = (UIView *)[self.contentView viewWithTag:300];
    
    if (btn.tag == 200) {
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center = CGPointMake(SCREENWIDTH/6, lineView.center.y);
        }];
        [self.delegate changeTableViewBody:1];
        
    }else if (btn.tag ==201){
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center = CGPointMake(SCREENWIDTH/2, lineView.center.y);
        }];
        [self.delegate changeTableViewBody:2];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center = CGPointMake(5*SCREENWIDTH/6, lineView.center.y);
        }];
        
        
    }
}


-(void)setUIWithUserInfo:(NSDictionary *)userInfo{
    
    NSLog(@"nick name = %@",[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]);
    
    _nickNameLabel.text =userInfo[@"nickname"]; //[NSString stringWithFormat:@"%@",[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]];
    
    
    [_attentionLeftButton setTitle:[NSString stringWithFormat:@"关注%@",[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"concerns"]]forState:UIControlStateNormal];
    
    
    [_attentionRightButton setTitle:[NSString stringWithFormat:@"粉丝%@",[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"fans"]] forState:UIControlStateNormal];
    NSLog(@"headIcon = %@",[WBUserDefaults headIcon]);
    _headImageView.image = [WBUserDefaults headIcon];
    
    //  [_backgroundImageView sd_setImageWithURL:[userInfo objectForKey:@"personalImage"]];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
