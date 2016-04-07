//
//  WBTopicDetailTableViewCell.m
//  微球
//
//  Created by 贾玉斌 on 16/3/5.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MyDownLoadManager.h"
#import "WBTopicCommentTableViewController.h"
#import "WBIndividualIncomeViewController.h"

@implementation WBTopicDetailTableViewCell
{
    //视频页面所需
    UIImageView *_iconImageView;
    NSString *_medioUrl;
    
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _background = [[UIView alloc]init];
        _background.backgroundColor = [UIColor initWithBackgroundGray];
        _background.userInteractionEnabled = YES;
        
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_background addSubview:_mainView];
        
        [self.contentView addSubview:_background];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
        _headImageView.userInteractionEnabled =YES;
        UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoSelfPage)];
        [_headImageView addGestureRecognizer:headTap];
        [_mainView addSubview:_headImageView];
        
        _nickName = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 100, 30)];
        _nickName.font = MAINFONTSIZE;
        _nickName.textColor = [UIColor initWithLightGray];
        [_mainView addSubview:_nickName];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 31, 100, 15)];
        _timeLabel.font = SMALLFONTSIZE;
        _timeLabel.textColor = [UIColor initWithLightGray];
        [_mainView addSubview:_timeLabel];
        
        _mainImageView = [[UIImageView alloc]init];
        [_background addSubview:_mainImageView];

        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = MAINFONTSIZE;
        _contentLabel.textColor = [UIColor initWithLightGray];
        [_background addSubview:_contentLabel];
        
        
        _footerView = [[UIView alloc]init];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_background addSubview:_footerView];
        
        //分享画面
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.titleLabel.font = MAINFONTSIZE;
        [self.contentView addSubview:_shareButton];
        
        
        //评论页面
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setImage:[UIImage imageNamed:@"icon_comment.png"] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [self.contentView addSubview:_commentButton];
        

        _commentButton.titleLabel.font = MAINFONTSIZE;
        [_commentButton addTarget: self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        //点赞
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
       // [_praiseButton setImage:[UIImage imageNamed:@"icon_like.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_praiseButton];
        [_praiseButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _praiseButton.titleLabel.font = MAINFONTSIZE;
        //点赞
        _zanBtn=[[CatZanButton alloc] init];
        [self.contentView addSubview:_zanBtn];
        [_zanBtn setType:CatZanButtonTypeFirework];
        
       
        //点赞跳出的提示框
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点赞转积分提示.png"]];
        _imageView.frame = CGRectMake(_praiseButton.frame.origin.x-124, _praiseButton.frame.origin.y-5, 124, 23);
        [self.contentView addSubview:_imageView];
        _imageView.alpha = 0;
        
    }
    return self;
}

- (void)setModel:(TopicDetailModel *)model  labelHeight:(CGFloat)labelHeight{
    //尺寸设置
    _model = model;
    CGFloat imageHeight = [model.imgRate floatValue]*SCREENWIDTH;
    _background.frame = CGRectMake(0, 0, SCREENWIDTH, 120+labelHeight+imageHeight);
    
    _userId = model.userId;
    
    _mainView.frame = CGRectMake(0, 9, SCREENWIDTH, 60+imageHeight+17+labelHeight+10);
    
    _mainImageView.frame=CGRectMake(0, 60, SCREENWIDTH, imageHeight);
    _contentLabel.frame= CGRectMake(10, 60+imageHeight+17, SCREENWIDTH-20, labelHeight);
    _footerView.frame =CGRectMake(0, 60+imageHeight+17+labelHeight+10+5, SCREENWIDTH, 40);
    _shareButton.frame =CGRectMake(10, 60+imageHeight+17+labelHeight+10+10, 80, 16);
    
    _commentButton.frame =CGRectMake(SCREENWIDTH/3+10, 60+imageHeight+17+labelHeight+10+10, 80, 16);
    _praiseButton.frame =CGRectMake(SCREENWIDTH-120,  60+imageHeight+17+labelHeight+10+10, 100,16);
    _zanBtn.frame = CGRectMake(SCREENWIDTH-120, 60+imageHeight+17+labelHeight+10+10, 20, 20);
    
    __unsafe_unretained WBTopicDetailTableViewCell *wfindShopVC = self;
    [_zanBtn setClickHandler:^(CatZanButton *zanButton) {
        if (_model.userId ==[[WBUserDefaults userId] integerValue]) {
            [wfindShopVC.delegate alertViewIntergeal:@"不能给自己充值" messageOpreation:nil cancelMessage:@"取消"];
            [zanButton setIsZan:NO];
        }else{
            if (zanButton.isZan) {
                NSLog(@"Zan!");
                [wfindShopVC praiseBtnClicked];
            }else{
                NSLog(@"Cancel zan!");
            }

        
        
        }
            }];
    
    
    _imageView.frame = CGRectMake(_praiseButton.frame.origin.x-124, _praiseButton.frame.origin.y-5, 124, 23);
    
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.tblUser.dir]];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    
    _nickName.text =model.tblUser.nickname;
    _timeLabel.text = model.timeStr;
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.dir]];
        _contentLabel.text = model.comment;
        [_commentButton setTitle:[NSString stringWithFormat:@"%ld条评论",(long)model.descussNum] forState:UIControlStateNormal];
        [_praiseButton setTitle:[NSString stringWithFormat:@"%ld球币",(long)model.getIntegral] forState:UIControlStateNormal];

}



#pragma 点击事件

//去个人主页
-(void)gotoSelfPage{
    [self.delegate gotoHomePage:_indexPath];

}

//分享事件
-(void)shareBtnClicked{
    
    NSArray* imageArray = @[_mainImageView.image];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_contentLabel.text
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
}

//评论点击事件
-(void)commentBtnClicked{
    //  NSLog(@" id = %ld",self.model.commentId);
    [self.delegate commentClickedPushView:self.indexPath];
}
#pragma mark -------点赞事件-------
//点赞事件
-(void)praiseBtnClicked{
    [self checkoutConfigDetail];
}

//检查积分配置信息
-(void)checkoutConfigDetail{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/integral/getIntegralConfigDetil?typeFlag=5"] whenSuccess:^(id representData) {
            NSString *str = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
            // NSLog(@"getIntegral = %ld",_model.getIntegral);
            [self checkoutIntegral:str];
    } andFailure:^(NSString *error) {
        [self.delegate alertViewIntergeal:@"查询积分出错" messageOpreation:nil cancelMessage:@"取消"];
    }];
}

//检查用户积分是否够用
-(void)checkoutIntegral:(NSString *)config{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/integral/checkIntegral?userId=%@&updateNum=5",[WBUserDefaults userId]] whenSuccess:^(id representData) {
        NSString *isEnough = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([isEnough isEqualToString:@"true"]) {
            [self uploadInformation];
        }else{
            [self.delegate alertViewIntergeal:@"你当前的积分不足，请充值后再来打赏吧！" messageOpreation:@"充值" cancelMessage:@"算了"];
            [_zanBtn setIsZan:NO];
        }
    } andFailure:^(NSString *error) {
    }];
}


//上传积分信息
-(void)uploadInformation{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/tq/topicPraise?commentId=%ld&userId=%@&toUserId=%ld",(long)_model.commentId,[WBUserDefaults userId],(long)_model.userId] whenSuccess:^(id representData) {
        [self.delegate changeGetIntegralValue:123 indexPath:_indexPath];
        [UIView animateWithDuration:0.5f animations:^{
            _imageView.alpha = 1;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hideWindow:) withObject:nil afterDelay:0.5f];
        }];
    } andFailure:^(NSString *error) {
        [self.delegate alertViewIntergeal:@"点赞失败" messageOpreation:nil cancelMessage:@"算了"];
        [_zanBtn setIsZan:NO];
    }];
}

//点赞事件动画消失
- (void)hideWindow:(id)object
{
    [UIView animateWithDuration:0.5f animations:^{
        _imageView.alpha = 0;
    }];
}

@end
