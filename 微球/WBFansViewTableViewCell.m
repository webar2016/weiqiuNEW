//
//  WBFansViewTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBFansViewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyDownLoadManager.h"

@implementation WBFansViewTableViewCell
{
    UIImageView *_headImageView;
    UILabel *_nickNameLabel;
    UIButton *_rightButton;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 20;
        [self.contentView addSubview:_headImageView];
        
        
        _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 200, 20)];
        _nickNameLabel.font = MAINFONTSIZE;
        _nickNameLabel.textColor = [UIColor initWithLightGray];
        [self.contentView addSubview:_nickNameLabel];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(SCREENWIDTH-60, 20, 50, 20);
        _rightButton.titleLabel.font = MAINFONTSIZE;
        [_rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.cornerRadius = 2;
        [self.contentView addSubview:_rightButton];
    }
    return self;
}

-(void)setModel:(WBFansModel *)model{
    _fansId = model.fansId;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    
    _nickNameLabel.text = model.nickname;
    
    if (model.isFriend) {
        _rightButton.backgroundColor = [UIColor initWithBackgroundGray];
        [_rightButton setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        _rightButton.backgroundColor = [UIColor initWithGreen];
        [_rightButton setTitle:@"关注" forState:UIControlStateNormal];
        
        
    }
    
    
}

-(void)rightBtnClicked{

    
    if ([_rightButton.titleLabel.text isEqualToString:@"已关注"]) {
        NSLog(@" _model.fansId %@",_model);
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/cancelFollow?userId=%@&friendId=%@",[WBUserDefaults userId],self.fansId] whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"msg"]isEqualToString:@"取消关注成功"]) {
                _rightButton.backgroundColor = [UIColor initWithGreen];
                [_rightButton setTitle:@"关注" forState:UIControlStateNormal];
            }
            
        } andFailure:^(NSString *error) {
            
        }];
    }else{
        
        
        [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/followFriend?userId=%@&friendId=%@",[WBUserDefaults userId],self.fansId] whenSuccess:^(id representData) {
            id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
            if ([[result objectForKey:@"msg"]isEqualToString:@"关注成功"]) {
                _rightButton.backgroundColor = [UIColor initWithBackgroundGray];
                [_rightButton setTitle:@"已关注" forState:UIControlStateNormal];
            }
            
        } andFailure:^(NSString *error) {
            
        }];
    }
    
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
