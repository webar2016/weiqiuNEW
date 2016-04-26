//
//  WBTopicCommentTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/4.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicCommentTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WBTopicCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)height;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor initWithBackgroundGray];
        _backGroundView = [[UIView alloc]init];
        [self.contentView addSubview:_backGroundView];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 14, 40, 40)];
        [self.contentView addSubview:_headImageView];
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterHomePage)];
        [_headImageView addGestureRecognizer:tap];
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 14, 200, 15)];
        _nickNameLabel.textColor = [UIColor initWithLightGray];
        [self.contentView addSubview:_nickNameLabel];
        _nickNameLabel.font = MAINFONTSIZE;
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 30, 200, 15)];
        _timeLabel.textColor = [UIColor initWithLightGray];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.font = SMALLFONTSIZE;
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 50, SCREENWIDTH-65-20, height)];
        _contentLabel.textColor = [UIColor initWithLightGray];
        //_contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
       // _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.font = MAINFONTSIZE;
        _contentLabel.numberOfLines = 0;
        //_contentLabel.backgroundColor = [UIColor initWithBackgroundGray];
         [self.contentView addSubview:_contentLabel];
        
        
    }
    return self;
}


- (void)setModel:(WBtopicCommentDetilListModel *)model
{
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.dir]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    
    if (model.typeFlag == 0) {
        _nickNameLabel.text = [NSString stringWithFormat:@"%@ 评论",model.userInfo.nickname];
    } else {
        _nickNameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@",model.userInfo.nickname,model.toUserInfo.nickname];
    }
    
    _timeLabel.text = model.timeStr;
    
    NSDictionary *attributes = @{NSFontAttributeName: MAINFONTSIZE};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    
   // NSLog(@"self = %f",_contentLabel.frame.size.height);
    CGRect rect = [model.comment
                   boundingRectWithSize:CGSizeMake(SCREENWIDTH-20-65, MAXFLOAT)
                   options:NSStringDrawingUsesLineFragmentOrigin
                   attributes:attributes
                   context:nil];
    //           NSLog(@"recxt = %f   tit = %f",rect.size.height,titleSize.height);

   _contentLabel.frame  = CGRectMake(65, 50, SCREENWIDTH-65-20, rect.size.height);
   //  NSLog(@"rect = %f",rect.size.height);
    _contentLabel.text = model.comment;
    
    //NSLog(@"--------");
    _backGroundView.backgroundColor = [UIColor whiteColor];
    _backGroundView.frame = CGRectMake(5, 5, SCREENWIDTH-10, 65+rect.size.height);
    _backGroundView.layer.masksToBounds = YES;
    _backGroundView.layer.cornerRadius = 5;
    
}

- (void)enterHomePage{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headIconTap:)]) {
        [self.delegate headIconTap:self];
    }
}

@end
