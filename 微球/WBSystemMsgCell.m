//
//  WBSystemMsgCell.m
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#define CELL_WIDTH SCREENWIDTH * 0.75
#define CELL_HEIGHT SCREENWIDTH * 0.75 / 1.5

#import "WBSystemMsgCell.h"
#import "UIImageView+WebCache.h"

@interface WBSystemMsgCell () {
 
    UILabel *_title;
    
    UIImageView *_coverImage;
    
    UILabel *_content;
    
    UIImageView *_bubbleBackgroundView;
}
@end

@implementation WBSystemMsgCell

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
    _bubbleBackgroundView = [[UIImageView alloc] initWithFrame:(CGRect){{-8,0},{CELL_WIDTH,CELL_HEIGHT}}];
    [self.messageContentView addSubview:_bubbleBackgroundView];
    
    
    _title = [[RCAttributedLabel alloc] initWithFrame:CGRectMake(18, 9, CELL_WIDTH - 20, 16)];
    _title.font = FONTSIZE16;
    _title.numberOfLines = 1;
    _title.textColor = [UIColor initWithNormalGray];
    [_bubbleBackgroundView addSubview:_title];
    
    _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 34, CELL_WIDTH - 30, (CELL_WIDTH - 30) / 3.2)];
    _coverImage.backgroundColor = [UIColor initWithBackgroundGray];
    _coverImage.contentMode = UIViewContentModeScaleToFill;
    [_bubbleBackgroundView addSubview:_coverImage];
    
    CGFloat height = CGRectGetMaxY(_coverImage.frame);
    _content = [[RCAttributedLabel alloc] initWithFrame:CGRectMake(18, height + 9, CELL_WIDTH - 20, CELL_HEIGHT - height - 18)];
    _content.font = MAINFONTSIZE;
    _content.numberOfLines = 0;
    _content.lineBreakMode = NSLineBreakByWordWrapping;
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
    WBSystemMessage *message = (WBSystemMessage *)self.model.content;
    if (message) {
        _title.text = message.title;
        _content.text = message.content;
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:message.imageURL]];
    }
    
    CGSize bubbleBackgroundViewSize = (CGSize){CELL_WIDTH,CELL_HEIGHT};
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    //拉伸图片
        
    messageContentViewRect.size.width = bubbleBackgroundViewSize.width;
    self.messageContentView.frame = messageContentViewRect;
    UIImage *image = [RCKitUtility imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
    _bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
}

+ (CGSize)getBubbleBackgroundViewSize{
    return (CGSize){CELL_WIDTH,CELL_HEIGHT};
}

@end
