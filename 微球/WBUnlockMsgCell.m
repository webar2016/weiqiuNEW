//
//  WBUnlockMsgCell.m
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#define CELL_WIDTH SCREENWIDTH * 0.75

#import "WBUnlockMsgCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+string.h"

@interface WBUnlockMsgCell () {
    
    UILabel     *_content;
    UIImageView *_unlockImage;
    UIImageView *_bubbleBackgroundView;
    
    CGSize      _bubbleBackgroundViewSize;
    
}
@end

@implementation WBUnlockMsgCell

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
    _bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:_bubbleBackgroundView];
    
    _unlockImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _unlockImage.backgroundColor = [UIColor initWithBackgroundGray];
    _unlockImage.contentMode = UIViewContentModeScaleAspectFill;
    _unlockImage.layer.masksToBounds = YES;
    [_bubbleBackgroundView addSubview:_unlockImage];
    
    _content = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    _content.font = MAINFONTSIZE;
    _content.numberOfLines = 0;
    _content.textColor = [UIColor initWithNormalGray];
    [_bubbleBackgroundView addSubview:_content];
    
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
    WBUnlockMessage *message = (WBUnlockMessage *)self.model.content;
    CGSize contentSize = CGSizeZero;
    if (message) {
        CGFloat rate;
        if (message.extra) {
            rate = [message.extra floatValue];
        } else {
            rate = 1;
        }
        CGSize imageSize = CGSizeMake(CELL_WIDTH - 30, CELL_WIDTH - 30 * rate);
        _unlockImage.frame = (CGRect){{18, 9},imageSize};
        [_unlockImage sd_setImageWithURL:[NSURL URLWithString:message.imageURL]];
        _content.text = message.content;
        contentSize = [message.content adjustSizeWithWidth:CELL_WIDTH - 20 andFont:MAINFONTSIZE];
    }
    CGFloat imageMaxHeight = CGRectGetMaxY(_unlockImage.frame);
    _content.frame = CGRectMake(18, imageMaxHeight + 9, CELL_WIDTH - 20, contentSize.height);
    CGFloat contentMaxHeight = CGRectGetMaxY(_content.frame);
    _bubbleBackgroundViewSize = (CGSize){CELL_WIDTH,contentMaxHeight + 9};
    
    _bubbleBackgroundView.frame = (CGRect){{-8,0},_bubbleBackgroundViewSize};
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
    
    messageContentViewRect.size.width = _bubbleBackgroundViewSize.width;
    self.messageContentView.frame = messageContentViewRect;
    UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
    _bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
}

+ (CGSize)getBubbleBackgroundViewSize:(WBUnlockMessage *)message {
    CGFloat rate;
    if (message.extra) {
        rate = [message.extra floatValue];
    } else {
        rate = 1;
    }
    CGFloat imageHeight = CELL_WIDTH - 30 * rate;
    
    CGFloat contentHeight = [message.content adjustSizeWithWidth:CELL_WIDTH - 20 andFont:MAINFONTSIZE].height;
    CGSize size = CGSizeMake(CELL_WIDTH - 20, imageHeight + contentHeight + 27);
    return size;
}

@end
