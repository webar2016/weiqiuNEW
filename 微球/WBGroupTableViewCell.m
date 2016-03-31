//
//  WBJoinTableViewCell.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WBMyGroupModel.h"
#import "RongIMKit/RCKitUtility.h"

#define FONT_SIZE [UIFont systemFontOfSize:12]

@implementation WBGroupTableViewCell{
    BOOL _isMaster;
    NSDate *_currentDate;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier isMater:(BOOL)isMaster{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _isMaster = isMaster;
        _currentDate = [[NSDate alloc] init];
        
        [self iconsView];
        
        [self groupName];
        
        [self totalNumber];
        
        [self talkTime];
        
        [self talkDetail];
        
        [self disturbSign];
    }
    return self;
}

-(void)iconsView{
    _iconsView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 49, 49)];
    _iconsView.layer.masksToBounds = YES;
    _iconsView.layer.cornerRadius = 5;
    _iconsView.contentMode = UIViewContentModeScaleToFill;
    
    _unReadTip = [[UILabel alloc] initWithFrame:CGRectMake(48, 4, 20, 20)];
    _unReadTip.backgroundColor = [UIColor redColor];
    _unReadTip.textColor = [UIColor whiteColor];
    _unReadTip.textAlignment = NSTextAlignmentCenter;
    _unReadTip.layer.masksToBounds = YES;
    _unReadTip.layer.cornerRadius = 10;
    _unReadTip.font = FONTSIZE12;
    [self addSubview:_iconsView];
}

-(void)groupName{
    _groupName = [[UILabel alloc] initWithFrame:CGRectMake(69, 15, SCREENWIDTH - 190, 14)];
    [_groupName setFont:MAINFONTSIZE];
    _groupName.textColor = [UIColor initWithLightGray];
    [self addSubview:_groupName];
}

-(void)totalNumber{
    _totalNumber = [[UILabel alloc] initWithFrame:CGRectMake(69, 40, 70, 16)];
    [_totalNumber setFont:FONT_SIZE];
    _totalNumber.textColor = [UIColor whiteColor];
    _totalNumber.backgroundColor = [UIColor initWithGreen];
    _totalNumber.textAlignment = NSTextAlignmentCenter;
    _totalNumber.layer.masksToBounds = YES;
    _totalNumber.layer.cornerRadius = 3;
    [self addSubview:_totalNumber];
}

-(void)talkTime{
    _talkTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 120, 15, 110, 14)];
    [_talkTime setFont:FONT_SIZE];
    _talkTime.textAlignment = NSTextAlignmentRight;
    _talkTime.textColor = [UIColor initWithNormalGray];
    [self addSubview:_talkTime];
}

-(void)talkDetail{
    _talkDetail = [[UILabel alloc] initWithFrame:CGRectMake(145, 40, SCREENWIDTH - 180, 16)];
    [_talkDetail setFont:FONT_SIZE];
    _talkDetail.textColor = [UIColor initWithNormalGray];
    [self addSubview:_talkDetail];
}

-(void)disturbSign{
    _disturbSign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nodistubance"]];
    _disturbSign.center = CGPointMake(SCREENWIDTH - 20, 47);
    _disturbSign.hidden = YES;
    [self addSubview:_disturbSign];
}

-(void)setDataModel:(RCConversationModel *)model{
    [super setDataModel:model];
    [_iconsView sd_setImageWithURL:((WBMyGroupModel *)model.extend).dir placeholderImage:[UIImage imageNamed:@"placeholder-17"]];
    _groupName.text = model.conversationTitle;
    if (_isMaster) {
        _totalNumber.text = [NSString stringWithFormat:@"%ld个回答",(long)((WBMyGroupModel *)model.extend).answers];
    }else {
        _totalNumber.text = [NSString stringWithFormat:@"%ld个问题",(long)((WBMyGroupModel *)model.extend).questions];
    }
    if ([((WBMyGroupModel *)model.extend).isPush isEqual: @"N"]) {
        _disturbSign.hidden = NO;
    } else {
        _disturbSign.hidden = YES;
    }
    if (model.unreadMessageCount > 0) {
        _unReadTip.text = [NSString stringWithFormat:@"%d",model.unreadMessageCount];
        [self addSubview:_unReadTip];
    }else{
        [_unReadTip removeFromSuperview];
    }
    
    //最新时间显示
    
    _talkTime.text = [RCKitUtility ConvertChatMessageTime:model.sentTime / 1000];
    
    //    最新消息显示
    
    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMsg = (RCTextMessage *)model.lastestMessage;
        [_talkDetail setText:textMsg.content];
    } else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]) {
        [_talkDetail setText:@"[图片]"];
    } else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]) {
        [_talkDetail setText:@"[语音]"];
    } else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]) {
        [_talkDetail setText:@"[位置]"];
    }else if ([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *textMsg = (RCInformationNotificationMessage *)model.lastestMessage;
        [_talkDetail setText:textMsg.message];
    } else {
        [_talkDetail setText:@"[暂不支持显示此消息]"];
    }
}

@end
