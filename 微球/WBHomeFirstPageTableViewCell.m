//
//  WBHomeFirstPageTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/22.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHomeFirstPageTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WBHomeFirstPageTableViewCell
{
    UIImageView *_backgroungImage;
    
    
    UIView *_mainView;
    UIImageView *_headImageView;
    UILabel *_nickName;
    UILabel *_timeLabel;
    UIButton *_attentionButton;
    UIImageView *_mainImageView;
    UILabel *_contentLabel;
    
    
    UIView *_footerView;
    UIButton *_shareButton;
    UIButton *_commentButton;
    UIButton *_praiseButton;
    
    UIImageView *_imageView;


}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //   NSLog(@"height = %f,width = %f",imageHeight,labelHeight);
        _backgroungImage = [[UIImageView alloc]init];
        _backgroungImage.backgroundColor = [UIColor initWithBackgroundGray];
        
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_backgroungImage addSubview:_mainView];
        _mainView.layer.cornerRadius = 5.0f;
        
        [self.contentView addSubview:_backgroungImage];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
        [_mainView addSubview:_headImageView];
        
        _nickName = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 100, 30)];
        _nickName.font =MAINFONTSIZE;
        [_mainView addSubview:_nickName];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 31, 100, 15)];
        _timeLabel.font = SMALLFONTSIZE;
        [_mainView addSubview:_timeLabel];
        
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.frame = CGRectMake(SCREENWIDTH-70, 14+9, 60, 22) ;
        _attentionButton.titleLabel.font = MAINFONTSIZE;
        _attentionButton.layer.cornerRadius = 5.0f;
        [_attentionButton addTarget:self action:@selector(attentionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionButton];
        
        
        _mainImageView = [[UIImageView alloc]init];
        [_backgroungImage addSubview:_mainImageView];
        _mainImageView.layer.cornerRadius = 5.0f;
        _mainImageView.layer.masksToBounds = YES;
        
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = MAINFONTSIZE;
        [_backgroungImage addSubview:_contentLabel];
        
        
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_backgroungImage addSubview:_footerView];
        
        //分享画面
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.titleLabel.font = MAINFONTSIZE;
        [self.contentView addSubview:_shareButton];
        
        
        //评论页面
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] forState:UIControlStateNormal];
        
        [_commentButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [self.contentView addSubview:_commentButton];
        
        
        _commentButton.titleLabel.font = MAINFONTSIZE;
        [_commentButton addTarget: self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //点赞
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseButton setImage:[UIImage imageNamed:@"icon_like.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_praiseButton];
        [_praiseButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _praiseButton.titleLabel.font = MAINFONTSIZE;
        
        //点赞跳出的提示框
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点赞转积分提示.png"]];
        _imageView.frame = CGRectMake(_praiseButton.frame.origin.x-124, _praiseButton.frame.origin.y-5, 124, 23);
        [self.contentView addSubview:_imageView];
        _imageView.alpha = 0;

        
    }
    return  self;

}

- (void)setModel:(TopicDetailModel *)model withLabelHeight:(CGFloat)labelHeight{
    //尺寸设置
    CGFloat imageHeight = [model.imgRate floatValue]*SCREENWIDTH ;
    _backgroungImage.frame = CGRectMake(0, 0, SCREENWIDTH, 120+labelHeight+imageHeight);
    
    _mainView.frame = CGRectMake(0, 9, SCREENWIDTH, 60+imageHeight+17+labelHeight+10);
    
    _mainImageView.frame=CGRectMake(0, 60, SCREENWIDTH, imageHeight);
    _contentLabel.frame= CGRectMake(10, 60+imageHeight+17, SCREENWIDTH-20, labelHeight);
    _footerView.frame =CGRectMake(0, 60+imageHeight+17+labelHeight+10+5, SCREENWIDTH, 40);
    _shareButton.frame =CGRectMake(10, 60+imageHeight+17+labelHeight+10+10, 80, 16);
    
    _commentButton.frame =CGRectMake(SCREENWIDTH/3+10, 60+imageHeight+17+labelHeight+10+10, 80, 16);
    _praiseButton.frame =CGRectMake(SCREENWIDTH-120,  60+imageHeight+17+labelHeight+10+10, 100,16);
    _imageView.frame = CGRectMake(_praiseButton.frame.origin.x-124, _praiseButton.frame.origin.y-5, 124, 23);
    
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    
    _nickName.text =model.tblUser.nickname;
    // NSLog(@"nick = %@",);
    _timeLabel.text = model.timeStr;
    // NSLog(@"model.timeStr = %@",model.timeStr);
    
    if (model.isFriend) {
        [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        _attentionButton.backgroundColor = [UIColor initWithBackgroundGray];
        
    }else{
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        _attentionButton.backgroundColor = [UIColor initWithGreen];
    }
    //图片
    if (model.newsType == 1) {
       [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
        
        _contentLabel.text = model.comment;
        
        
        [_commentButton setTitle:[NSString stringWithFormat:@"%ld条评论",model.descussNum] forState:UIControlStateNormal];
        
        [_praiseButton setTitle:[NSString stringWithFormat:@"%ld球票",model.getIntegral] forState:UIControlStateNormal];
        //s视频
    }else if(model.newsType ==2){
        //图文
    }else{
        
        _mainImageView.frame =CGRectMake(10, 60, SCREENWIDTH-20, 175);
        _mainImageView.layer.borderWidth = 2;
        _mainImageView.layer.borderColor =[UIColor colorWithRed:236 green:240 blue:241 alpha:1].CGColor;
   //     [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
        
        _contentLabel.frame =CGRectMake(10, 60+175+17, SCREENWIDTH-20, _contentLabel.frame.size.height);
        _contentLabel.text = model.comment;
        
        
        _shareButton.frame = CGRectMake(10, 60+175+17+20+_contentLabel.frame.size.height, 100, 16);
        _commentButton.frame =CGRectMake(SCREENWIDTH/3+10,60+175+17+20+_contentLabel.frame.size.height, 100, 16);
        [_commentButton setTitle:[NSString stringWithFormat:@"%ld条评论",model.descussNum] forState:UIControlStateNormal];
        _praiseButton.frame =CGRectMake(SCREENWIDTH-120,  60+175+17+20+_contentLabel.frame.size.height, 100,16);
        
        [_praiseButton setTitle:[NSString stringWithFormat:@"%ld球票",model.getIntegral] forState:UIControlStateNormal];
        
    }
    
    
    // NSLog(@"comment id = %ld",model.commentId);
    
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
