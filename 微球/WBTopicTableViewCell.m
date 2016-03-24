//
//  WBTopicTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WBTopicTableViewCell
/* UIImageView *_backgroungImage;
 UILabel *_titleLabel;
 UIImageView *_leftImage;
 UILabel *_contentLabel;
 UILabel *_rightLabel;
 UIImageView *_imageView;*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width
{
   
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        _backgroungImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, width-20, 178-9)];
        _backgroungImage.backgroundColor = [UIColor greenColor];
        _backgroungImage.layer.cornerRadius =5;
        [self.contentView addSubview:_backgroungImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 29, width-20, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_backgroungImage addSubview:_titleLabel];
        
       
        
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 70, 14, 14 )];
        [_leftImage setImage:[UIImage imageNamed:@"icon_content"]];
        [_backgroungImage addSubview:_leftImage];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.5+14+5, 62, 100, 30)];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textAlignment = NSTextAlignmentJustified;
        [_backgroungImage addSubview:_contentLabel];
        
                
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_backgroungImage.frame.size.width-21-40, _backgroungImage.frame.size.height-11-24 , 40, 24)];
        [_rightImageView setImage:[UIImage imageNamed:@"icon_topic.png"]];
        [_backgroungImage addSubview:_rightImageView];
        
        self.contentView.backgroundColor = [UIColor initWithBackgroundGray];
    }
    return self;
}

- (void)setModel:(WBTopicModel *)model
{
    _model = model;
    [_backgroungImage sd_setImageWithURL:[NSURL URLWithString:model.dir]];
    _backgroungImage.layer.masksToBounds = YES;
    _backgroungImage.layer.cornerRadius = 5;
    _titleLabel.text = model.topicContent;
    _contentLabel.text = [NSString stringWithFormat:@"%ld条内容",model.commentNum];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
