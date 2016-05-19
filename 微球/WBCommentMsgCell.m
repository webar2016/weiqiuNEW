//
//  WBCommentMsgCell.m
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#define CELL_WIDTH SCREENWIDTH * 0.75

#import "WBCommentMsgCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+string.h"

@interface WBCommentMsgCell () {
    
    UILabel     *_nickname;
    UIImageView *_headIcon;
    UILabel     *_comment;
    UIImageView *_bubbleBackgroundView;
    
    CGSize      _bubbleBackgroundViewSize;
    
}
@end

@implementation WBCommentMsgCell

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
    _bubbleBackgroundView = [[UIImageView alloc] init];
    
    //_bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:_bubbleBackgroundView];
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 48, 48)];
    _headIcon.backgroundColor = [UIColor initWithBackgroundGray];
    _headIcon.contentMode = UIViewContentModeScaleAspectFit;
    _headIcon.layer.masksToBounds = YES;
    _headIcon.layer.cornerRadius = 24;
    [_bubbleBackgroundView addSubview:_headIcon];
    
    _nickname = [[RCAttributedLabel alloc] initWithFrame:CGRectMake(80, 9, CELL_WIDTH - 100, 16)];
    _nickname.font = FONTSIZE16;
    _nickname.numberOfLines = 1;
    
    _nickname.textColor = [UIColor initWithNormalGray];
    [_bubbleBackgroundView addSubview:_nickname];
    
    _comment =[[RCAttributedLabel alloc] init];
   _comment = [[RCAttributedLabel alloc] initWithFrame:CGRectMake(80, 30, CELL_WIDTH - 100, 60)];
    _comment.font = MAINFONTSIZE;
    _comment.numberOfLines = 2;
    
    _comment.textColor = [UIColor initWithNormalGray];
    [_bubbleBackgroundView addSubview:_comment];
    
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
    WBCommentMessage *message = (WBCommentMessage *)self.model.content;
    CGSize commentSize = CGSizeZero;
    if (message) {
        _nickname.text = [NSString stringWithFormat:@"来自 %@ 的评论",message.nickname];
        [_headIcon sd_setImageWithURL:[NSURL URLWithString:message.imageURL]];
        _comment.text = message.content;
        commentSize = [message.content adjustSizeWithWidth:CELL_WIDTH - 100 andFont:MAINFONTSIZE];
    }
   // NSLog(@"commentSize = %f",commentSize.height);
    if (commentSize.height > 60) {
        commentSize.height = 60;
        _bubbleBackgroundViewSize = (CGSize){CELL_WIDTH,100};
    } else if (commentSize.height < 32){
        _bubbleBackgroundViewSize = (CGSize){CELL_WIDTH,66};
    }else{
    
    _bubbleBackgroundViewSize = (CGSize){CELL_WIDTH,83};
    }
   // NSLog(@"commentSize.height = %f",commentSize.height);
    
    _bubbleBackgroundView.frame = (CGRect){{-8,0},_bubbleBackgroundViewSize};
    _comment.frame = CGRectMake(80, 34, CELL_WIDTH - 100, commentSize.height);
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    
    messageContentViewRect.size.width = _bubbleBackgroundViewSize.width;
    self.messageContentView.frame = messageContentViewRect;
    UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
    _bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
}

+ (CGSize)getBubbleBackgroundViewSize:(WBCommentMessage *)message {
    CGSize commentSize = [message.content adjustSizeWithWidth:CELL_WIDTH - 100 andFont:MAINFONTSIZE];
    CGSize size;
    if (commentSize.height > 60) {
        commentSize.height = 60;
        size = (CGSize){CELL_WIDTH,95};
    } else if (commentSize.height < 32){
        size = (CGSize){CELL_WIDTH,58};
    }else{
        size = (CGSize){CELL_WIDTH,76};
    
    }
    return size;
}

@end
