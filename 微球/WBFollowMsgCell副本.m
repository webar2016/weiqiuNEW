//
//  WBFollowMsgCell.m
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#define CELL_WIDTH SCREENWIDTH * 0.75

#import "WBFollowMsgCell.h"
#import "UIImageView+WebCache.h"

@interface WBFollowMsgCell () {
    
    UILabel     *_tip;
    UIImageView *_headIcon;
    UILabel     *_nickname;
    UIImageView *_bubbleBackgroundView;
    
}
@end

@implementation WBFollowMsgCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _bubbleBackgroundView = [[UIImageView alloc] initWithFrame:(CGRect){{-8,0},{CELL_WIDTH,95}}];
    [self.messageContentView addSubview:_bubbleBackgroundView];
    
    
    _tip = [[RCAttributedLabel alloc] initWithFrame:CGRectMake(18, 9, CELL_WIDTH - 20, 16)];
    _tip.font = FONTSIZE16;
    _tip.numberOfLines = 1;
    _tip.textColor = [UIColor initWithNormalGray];
    _tip.text = @"又有新的小伙伴关注你啦！";
    [_bubbleBackgroundView addSubview:_tip];
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 34, 48, 48)];
    _headIcon.backgroundColor = [UIColor initWithBackgroundGray];
    _headIcon.contentMode = UIViewContentModeScaleAspectFit;
    _headIcon.layer.masksToBounds = YES;
    _headIcon.layer.cornerRadius = 24;
    [_bubbleBackgroundView addSubview:_headIcon];
    
    _nickname = [[RCAttributedLabel alloc] initWithFrame:CGRectMake(80, 34, CELL_WIDTH - 100, 48)];
    _nickname.font = MAINFONTSIZE;
    _nickname.numberOfLines = 1;
    _nickname.textColor = [UIColor initWithNormalGray];
    [_bubbleBackgroundView addSubview:_nickname];
    
    UITapGestureRecognizer *textMessageTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTextMessage:)];
    textMessageTap.numberOfTapsRequired = 1;
    textMessageTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:textMessageTap];
    self.userInteractionEnabled = YES;
}

- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    WBFollowMessage *message = (WBFollowMessage *)self.model.content;
    if (message) {
        _nickname.text = message.nickname;
        [_headIcon sd_setImageWithURL:[NSURL URLWithString:message.imageURL]];
    }
    
    CGSize bubbleBackgroundViewSize = (CGSize){CELL_WIDTH,95};
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    
    messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
    self.messageContentView.frame = messageContentViewRect;
    UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
    _bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
}

+ (CGSize)getBubbleBackgroundViewSize{
    return (CGSize){CELL_WIDTH,95};
}

@end
