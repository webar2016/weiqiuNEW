//
//  WBTopicDetailCell.m
//  微球
//
//  Created by 徐亮 on 16/4/6.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicDetailCell.h"
#import "NSString+string.h"
#import "UIImageView+WebCache.h"
#import "MyDownLoadManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CatZanButton.h"

@implementation WBTopicDetailCell

{
    UIImageView *_headIcon;
    UILabel     *_nickname;
    UILabel     *_timeLabel;
    
    UIView      *_mainContent;
    UIImageView *_mainImage;
    UILabel     *_contentLabel;
    
    UIToolbar   *_toolBar;
    UIButton    *_shareBtn;
    UIButton    *_commentBtn;
    UIButton    *_praiseBtn;
    
    UIImageView *_likeTip;
    
    CGFloat     _mainContentHeight;
    CGFloat     _maxHeight;
    CGFloat     _score;
    
    TopicDetailModel *_model;
    
    NSInteger   _cellType;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if ([reuseIdentifier isEqualToString:@"detailCellID1"]) {//photo
            _cellType = 1;
        } else if ([reuseIdentifier isEqualToString:@"detailCellID2"]) {//vedio
            _cellType = 2;
        } else {//arctial
            _cellType = 3;
        }
        
        [self setUpUserInfos];
        
        [self setUpMainContent];
        
        [self setUpToolbar];
        
        _maxHeight = CGRectGetMaxY(_toolBar.frame);
        self.contentView.frame = CGRectMake(0, 0, SCREENWIDTH, _maxHeight);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _likeTip = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点赞转积分提示.png"]];
        _likeTip.frame = CGRectMake(SCREENWIDTH / 2, _maxHeight - 40, 124, 23);
        _likeTip.alpha = 0;
        [self.contentView addSubview:_likeTip];
    }
    return self;
}

-(void)setUpUserInfos{
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    _headIcon.backgroundColor = [UIColor initWithBackgroundGray];
    _headIcon.layer.masksToBounds = YES;
    _headIcon.layer.cornerRadius = 20;
    _headIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSelfPage)];
    [_headIcon addGestureRecognizer:headTap];
    [userView addSubview:_headIcon];
    
    _nickname = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, SCREENWIDTH / 2, 30)];
    _nickname.font = MAINFONTSIZE;
    _nickname.textColor = [UIColor initWithLightGray];
    [userView addSubview:_nickname];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 31, SCREENWIDTH / 2, 15)];
    _timeLabel.font = SMALLFONTSIZE;
    _timeLabel.textColor = [UIColor initWithLightGray];
    [userView addSubview:_timeLabel];
    
    [self.contentView addSubview:userView];
}

-(void)setUpMainContent{
    _mainContent = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (_cellType == 1) {//photo
        
        _mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH)];
        _mainImage.backgroundColor = [UIColor initWithBackgroundGray];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.layer.masksToBounds = YES;
        
        _contentLabel = [[UILabel alloc] initWithFrame:(CGRect){{20,SCREENWIDTH + 10},{(SCREENWIDTH - 40),16}}];
        _contentLabel.font = MAINFONTSIZE;
        _contentLabel.numberOfLines = 1;
        _contentLabel.textColor = [UIColor initWithLightGray];
        
        _mainContent.frame = CGRectMake(0, 60, SCREENWIDTH, SCREENWIDTH + 26);
        [_mainContent addSubview:_mainImage];
        [_mainContent addSubview:_contentLabel];
        
    } else if (_cellType == 2) {//vedio
        
        _mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH)];
        _mainImage.backgroundColor = [UIColor initWithBackgroundGray];
        _mainImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPlay)];
        [_mainImage addGestureRecognizer:tap];
        
        UIImageView *playBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 6, SCREENWIDTH / 6)];
        playBtn.image = [UIImage imageNamed:@"icon_broadcast.png"];
        playBtn.center = _mainImage.center;
        [_mainImage addSubview:playBtn];
        
        _mainContent.frame = CGRectMake(0, 60, SCREENWIDTH, SCREENWIDTH);
        [_mainContent addSubview:_mainImage];
        
    } else {//arctial
        
        _mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, 175)];
        _mainImage.backgroundColor = [UIColor initWithBackgroundGray];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.layer.masksToBounds = YES;
        
        UIImageView *tipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_ariticle"]];
        tipIcon.frame = CGRectMake(SCREENWIDTH - 90, 145, 59.5, 22.5);
        [_mainImage addSubview:tipIcon];
        
        _mainContent.frame = CGRectMake(0, 60, SCREENWIDTH - 20, 175);
        [_mainContent addSubview:_mainImage];
        
    }
    
    _mainContentHeight = CGRectGetMaxY(_mainContent.frame);
    [self.contentView addSubview:_mainContent];
}

-(void)setUpToolbar{
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _mainContentHeight + 10, SCREENWIDTH, 40)];
    _toolBar.barTintColor = [UIColor whiteColor];
    
    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _shareBtn.tag = 111;
    [_shareBtn setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [_shareBtn setTitle:@" 分享" forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = MAINFONTSIZE;
    [_shareBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(toolbarOperations:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarBtn = [[UIBarButtonItem alloc] initWithCustomView:_shareBtn];
    
    _commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _commentBtn.tag = 222;
    [_commentBtn setImage:[UIImage imageNamed:@"icon_comment.png"] forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = MAINFONTSIZE;
    [_commentBtn addTarget:self action:@selector(toolbarOperations:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentBarBtn = [[UIBarButtonItem alloc] initWithCustomView:_commentBtn];
    
    _praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _praiseBtn.tag = 333;
    
    [_praiseBtn setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    _praiseBtn.titleLabel.font = MAINFONTSIZE;
    [_praiseBtn addTarget:self action:@selector(toolbarOperations:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *praiseBarBtn = [[UIBarButtonItem alloc] initWithCustomView:_praiseBtn];
    
    UIBarButtonItem *flexiBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *barBtns = @[flexiBarBtn,shareBarBtn,flexiBarBtn,commentBarBtn,flexiBarBtn,praiseBarBtn,flexiBarBtn];
    
    _toolBar.items = barBtns;
    [self.contentView addSubview:_toolBar];
}

-(void)setModel:(TopicDetailModel *)model withIsSelectState:(NSString *)selectState{
    
    _model = model;
    _score = model.getIntegral;
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];
    _nickname.text =model.tblUser.nickname;
    _timeLabel.text = model.timeStr;
    
    if (model.newsType == 1) {
        [_mainImage sd_setImageWithURL:[NSURL URLWithString:model.dir]];
        _mainImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewer)];
        [_mainImage addGestureRecognizer:tap];
        _contentLabel.text = model.comment;
    } else if (model.newsType == 2) {
        [_mainImage sd_setImageWithURL:[NSURL URLWithString:model.mediaPic]];
    } else {
        if (![model.dir isEqualToString:@";"]) {
            [_mainImage sd_setImageWithURL:[NSURL URLWithString:[model.dir componentsSeparatedByString:@";"].firstObject]];
        } else {
            [_mainImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
        }
        
    }
    
    if ([selectState isEqualToString:@"0"]) {
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_like.png"] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
    }
    
    
    [_commentBtn setTitle:[NSString stringWithFormat:@" %ld 评论",(long)model.descussNum] forState:UIControlStateNormal];
    
    if (_score > 1000) {
        [_praiseBtn setTitle:[NSString stringWithFormat:@" %.1fk球币",_score/1000] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setTitle:[NSString stringWithFormat:@" %ld球币",(long)_score] forState:UIControlStateNormal];
    }
}

#pragma mark - operations

-(void)gotoSelfPage{
    [self.delegate gotoHomePage:_indexPath];
}

-(void)videoPlay{
    [self.delegate playMedio:self.indexPath];
}

-(void)toolbarOperations:(UIButton *)sender{
    if (![WBUserDefaults userId]) {
        [self.delegate unloginAlert];
        return;
    }
    if (sender.tag == 333) {
        [self likeTap];
        return;
    }
    if (sender.tag == 222) {
        [self.delegate commentClickedPushView:self.indexPath];
        return;
    }
    [self shareBtnClicked];
}

-(void)showImageViewer{
    [self.delegate showImageViewer:self.indexPath];
}

#pragma mark - share

-(void)shareBtnClicked{
    
    NSString *shareURL = [NSString stringWithFormat:@"%@/share/topic?commentId=%ld&newsType=%ld",WEBAR_IP,(long)_model.commentId,(long)_cellType];
    
    UIImage *shareImage = [UIImage imageWithData:UIImageJPEGRepresentation(_mainImage.image, 0.1)];
    
    NSString *shareText = [NSString string];
    
    if (_cellType == 1) {
        shareText = [NSString stringWithFormat:@"我分享了 %@ 的照片，快来微球看看吧！",_model.tblUser.nickname];
    } else if (_cellType == 2) {
        shareText = [NSString stringWithFormat:@"我分享了 %@ 的视频，拍的太棒了，快来微球看看吧！",_model.tblUser.nickname];
    } else {
        shareText = [NSString stringWithFormat:@"我分享了 %@ 的文章，写得太绝了，快来微球看看吧！",_model.tblUser.nickname];
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:shareText
                                     images:@[shareImage]
                                        url:[NSURL URLWithString:shareURL]
                                      title:_model.topicContent
                                       type:SSDKContentTypeWebPage];
    
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"好的"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败，请稍后重试"
                                                                           message:nil//[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"好的"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           NSLog(@"%@",[NSString stringWithFormat:@"%@",error]);
                           break;
                       }
                       default:
                           break;
                   }
               }];
}

#pragma mark -------点赞-------

-(void)likeTap{
    
    if (![WBUserDefaults userId] || [[WBUserDefaults userId] integerValue] == _model.userId) {
        return;
    }
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"%@/integral/checkIntegral?userId=%@&updateNum=5",WEBAR_IP,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString: @"true"]) {
            [self upLoadLikeTap];
        }else{
            [self.delegate alertViewIntergeal:@"你当前的积分不足，请充值后再来打赏吧！" messageOpreation:@"充值" cancelMessage:@"算了"];
        }
    } andFailure:^(NSString *error) {
    }];
}

-(void)upLoadLikeTap{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"%@/tq/topicPraise?commentId=%ld&userId=%@&toUserId=%ld",WEBAR_IP,(long)_model.commentId,[WBUserDefaults userId],(long)_model.userId] whenSuccess:^(id representData) {
        NSLog(@"%@",_indexPath);
        [self.delegate changeGetIntegralValue:123 indexPath:self.indexPath];
        
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:1.0f animations:^{
            //                _praiseBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
            _likeTip.frame = CGRectMake(SCREENWIDTH * 2 / 3, _maxHeight - 40, 124, 23);
            _likeTip.alpha = 1;
            _score += 5;
            if (_score > 1000) {
                [_praiseBtn setTitle:[NSString stringWithFormat:@" %.1fk球币",_score/1000] forState:UIControlStateNormal];
            }else{
                [_praiseBtn setTitle:[NSString stringWithFormat:@" %ld球币",(long)_score] forState:UIControlStateNormal];
            }
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hideWindow:) withObject:nil afterDelay:0];
        }];
    } andFailure:^(NSString *error) {
        [self.delegate showHUDText:@"网络有问题，请检查网络"];
        
    }];
}

- (void)hideWindow:(id)object{
    [UIView animateWithDuration:0.5f animations:^{
//        _praiseBtn.transform = CGAffineTransformMakeScale(1,1);
        _likeTip.frame = CGRectMake(SCREENWIDTH, _maxHeight - 40, 124, 23);
    } completion:^(BOOL finished) {
        _likeTip.alpha = 0;
        _likeTip.frame = CGRectMake(SCREENWIDTH / 2, _maxHeight - 40, 124, 23);
    }];
}

@end
