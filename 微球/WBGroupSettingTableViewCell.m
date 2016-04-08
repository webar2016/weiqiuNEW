//
//  WBGroupSettingTableViewCell.m
//  微球
//
//  Created by 徐亮 on 16/3/10.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGroupSettingTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation WBGroupSettingTableViewCell{
    UIImageView     *_userIcon;
    UILabel         *_nickName;
    
    UILabel         *_aimPlace;
    UILabel         *_closeDate;
    UILabel         *_totalTime;
    UILabel         *_groupTag;
    UILabel         *_memberLimit;
    UILabel         *_totalScore;
    
    UISwitch        *_messagePush;
//    UISwitch        *_QAPush;
    
    UIView          *_cutLine;
    
    BOOL            _isPush;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(NSUInteger)section isMaster:(BOOL)isMaster withGroupDetail:(WBCollectionViewModel *)detail messageIsPush:(BOOL)isPush{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.isMaster = isMaster;
    self.detail = detail;
    _isPush = isPush;
    if (self) {
        _cutLine = [[UIView alloc] init];
        _cutLine.backgroundColor = [UIColor initWithBackgroundGray];
        if (section == 0) {
            [self setUpMemberList];
        }
        if (section == 1) {
            [self setUpGroupDetail];
        }
        if (section == 2) {
            [self setUpPushChoice];
        }
        if (section == 3) {
            [self setUpCloseButton];
        }
    }
    return self;
}

-(void)setUpMemberList{
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.cornerRadius = 24;
    _userIcon.image = [UIImage imageNamed:@"0.pic.jpg"];
    
    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(72, 26, SCREENWIDTH / 2, 16)];
    _nickName.font = MAINFONTSIZE;
    _nickName.textColor = [UIColor initWithNormalGray];
    _nickName.text = @"用户昵称用户昵称";
    
    _cutLine.frame = CGRectMake(10, 69, SCREENWIDTH - 10, 1);
    
    [self addSubview:_userIcon];
    [self addSubview:_nickName];
    [self addSubview:_cutLine];
}

-(void)setUpGroupDetail{
    UIView *detailWraper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 181)];
    
    NSArray *icons = @[@"icon_destination",@"icon_cuttime",@"icon_traveldate",@"icon_tag2",@"icon_grouplimit",@"icon_qiupiao2"];
    NSArray *titles = @[@"目的地",@"闭团日期",@"行程日期",@"标签",@"人数上限",@"悬赏球币"];
    
    NSMutableArray *infos = [NSMutableArray array];
    if (self.detail) {
        NSString *memberLimit = [NSString stringWithFormat:@"%ld",(long)self.detail.maxMembers];
        NSString *travelTime = [[NSString alloc] init];
        if (self.detail.planBegin == nil || self.detail.planEnd == nil) {
            travelTime = [NSString stringWithFormat:@"未填写"];
        } else {
            travelTime = [NSString stringWithFormat:@"%@至%@",self.detail.planBegin,self.detail.planEnd];
        }
        NSString *rewardIntegral = [NSString stringWithFormat:@"%ld",(long)self.detail.rewardIntegral];
        
        infos = (NSMutableArray *)@[self.detail.destination,self.detail.beginTime,travelTime,self.detail.groupSignStr,memberLimit,rewardIntegral];
    }else{
        infos = (NSMutableArray *)@[@"目的地",@"闭团日期",@"行程日期",@"标签",@"人数上限",@"悬赏球币"];
    }
    
    for (int i = 0; i < 6 ; i ++) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icons[i]]];
        
        UILabel *title = [[UILabel alloc] init];
        title.textColor = [UIColor initWithNormalGray];
        title.font = MAINFONTSIZE;
        title.text = titles[i];
        
        UILabel *info = [[UILabel alloc] init];
        info.textColor = [UIColor initWithNormalGray];
        info.textAlignment = NSTextAlignmentRight;
        info.font = MAINFONTSIZE;
        info.text = infos[i];
        
        if (i > 3) {
            icon.center = CGPointMake(30, 20 * (i + 1) + 21 * i);
            title.frame = CGRectMake(50, 13 * (i + 1) + 1 + 27 * i, 70, 14);
            info.frame = CGRectMake(SCREENWIDTH / 2 - 100, 13 * (i + 1) + 1 + 27 * i, SCREENWIDTH / 2 + 100, 14);
        }
        icon.center = CGPointMake(30, 20 * (i + 1) + 20 * i);
        title.frame = CGRectMake(50, 13 * (i + 1) + 27 * i, 70, 14);
        info.frame = CGRectMake(SCREENWIDTH / 2 - 100, 13 * (i + 1) + 27 * i, SCREENWIDTH / 2 - 22 + 100, 14);
        
        _cutLine.frame = CGRectMake(10, 160, SCREENWIDTH - 10, 1);
        
        [detailWraper addSubview:icon];
        [detailWraper addSubview:title];
        [detailWraper addSubview:info];
        [detailWraper addSubview:_cutLine];
        [self addSubview:detailWraper];
    }
    
}

-(void)setUpPushChoice{
    UIView *pushWraper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    
    UILabel *messagePush = [[UILabel alloc] initWithFrame:CGRectMake(22, 13, 70, 14)];
    messagePush.font = MAINFONTSIZE;
    messagePush.textColor = [UIColor initWithNormalGray];
    messagePush.text = @"消息提醒";
    
//    UILabel *QAPush= [[UILabel alloc] initWithFrame:CGRectMake(22, 54, 70, 14)];
//    QAPush.font = MAINFONTSIZE;
//    QAPush.textColor = [UIColor initWithNormalGray];
//    if (self.isMaster) {
//        QAPush.text = @"答案推送";
//    }else{
//        QAPush.text = @"问题推送";
//    }
    
    _messagePush = [[UISwitch alloc] init];
    _messagePush.center = CGPointMake(SCREENWIDTH - 45, 20);
    _messagePush.onTintColor = [UIColor initWithGreen];
    [_messagePush addTarget:self action:@selector(messagePush) forControlEvents:UIControlEventValueChanged];
    
    if (_isPush) {
        _messagePush.on = YES;
    } else {
        _messagePush.on = NO;
    }
    
//    _QAPush = [[UISwitch alloc] init];
//    _QAPush.center = CGPointMake(SCREENWIDTH - 45, 61);
//    _QAPush.onTintColor = [UIColor initWithGreen];
//    [_QAPush addTarget:self action:@selector(QAPush) forControlEvents:UIControlEventValueChanged];
//    _QAPush.on = YES;
//    if (!_isPush) {
//        _QAPush.on = NO;
//    }
//    _cutLine.frame = CGRectMake(10, 41, SCREENWIDTH - 10, 1);
    
    [pushWraper addSubview:messagePush];
//    [pushWraper addSubview:QAPush];
    [pushWraper addSubview:_messagePush];
//    [pushWraper addSubview:_QAPush];
    [pushWraper addSubview:_cutLine];
    [self addSubview:pushWraper];
}

-(void)setUpCloseButton{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
    footerView.backgroundColor = [UIColor initWithBackgroundGray];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.15, 25, SCREENWIDTH * 0.7, 35)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"bg-23"] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = FONTSIZE16;
    if (self.isMaster) {
        [closeButton setTitle:@"闭团 & 颁发悬赏" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeGroup) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [closeButton setTitle:@"退出帮帮团" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(quitGroup) forControlEvents:UIControlEventTouchUpInside];
    }
    [footerView addSubview:closeButton];
    [self addSubview:footerView];
}

#pragma mark - 添加数据

-(void)setUserInfos:(WBUserInfosModel *)userInfos{
    _userInfos = userInfos;
    
    [_userIcon sd_setImageWithURL:userInfos.dir];
    
    _nickName.text = userInfos.nickname;
    
}

#pragma mark - 操作点击

-(void)closeGroup{
    if (_delegate && [_delegate respondsToSelector:@selector(closeGroup:)]) {
        [_delegate closeGroup:self];
    }
}

-(void)quitGroup{
    if (_delegate && [_delegate respondsToSelector:@selector(quitGroup:)]) {
        [_delegate quitGroup:self];
    }
}

-(void)messagePush{
    if (_delegate && [_delegate respondsToSelector:@selector(messagePush:isOn:)]) {
        [_delegate messagePush:self isOn:_messagePush.on];
    }
}

//-(void)QAPush{
//    if (_delegate && [_delegate respondsToSelector:@selector(QAPush:isOn:)]) {
//            [_delegate QAPush:self isOn:_QAPush.on];
//    }
//}


@end
