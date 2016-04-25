//
//  WBAnswerDetailController.m
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAnswerDetailController.h"
#import "WBAnswerListController.h"
#import "WBIndividualIncomeViewController.h"
#import "WBSingleAnswerModel.h"
#import "WBHomepageViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBAttributeTextView.h"
#import "WBTextAttachment.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "UIImage+image.h"
#import "NSString+string.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "WBUpdateIntegral.h"

#define ANSWERURL @"http://app.weiqiu.me/tq/getAnswerById?answerId=%ld"

@interface WBAnswerDetailController () <UITextViewDelegate>

//navigation bar
@property (nonatomic, strong) UIView *titleView;

//点击显示完整问题
@property (nonatomic, strong) UIView *titleDetail;

//小箭头
@property (nonatomic, strong) UIImageView *narrow;

//包含用户信息和回答的视图
@property (nonatomic, strong) UIView *wraperView;

//回答详情
@property (nonatomic, strong) WBAttributeTextView *answerDetail;

//头部用户信息
@property (nonatomic, strong) UIView *headerView;

//头像
@property (nonatomic, strong) UIButton *userIcon;

//点赞
@property (nonatomic, strong) UIButton *likeButton;

//点赞
@property (nonatomic, strong) UIImageView *likeTip;

//完整问题是否已经显示
@property (nonatomic, assign) BOOL titleIsShow;

//完整问题视图尺寸
@property (nonatomic, assign) CGSize titleDetailSize;

@property (nonatomic, strong) WBSingleAnswerModel *singleAnswer;

//分数
@property (nonatomic, assign) float score;

@end

@implementation WBAnswerDetailController

-(WBSingleAnswerModel *)singleAnswer{
    if (_singleAnswer) {
        return _singleAnswer;
    }
    _singleAnswer = [[WBSingleAnswerModel alloc] init];
    return _singleAnswer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    [self setUpTitleView];
    
    [self setUpTitleDetail];
    
    [self loadData];
    
    [self showHUDIndicator];
    
    [self addGestureRecognizer];
    
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建子控件

-(void)setUpTitleView{
    self.titleIsShow = NO;
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 0.5, 44)];
    
    UILabel *quesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, SCREENWIDTH * 0.5, 20)];
    quesLabel.font = BIGFONTSIZE;
    quesLabel.textColor = [UIColor initWithNormalGray];
    quesLabel.text = self.questionText;
    quesLabel.textAlignment = NSTextAlignmentCenter;
    
    _narrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.25 - 4, 34, 8, 8)];
    _narrow.image = [UIImage imageNamed:@"icon_spread1"];
    
    [self.titleView addSubview:quesLabel];
    if (!self.fromHomePage) {
        [self.titleView addSubview:_narrow];
    }
    self.navigationItem.titleView = self.titleView;
}

-(void)setUpTitleDetail{
    self.titleDetailSize = [self.questionText adjustSizeWithWidth:SCREENWIDTH - MARGINOUTSIDE * 2 andFont:MAINFONTSIZE];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MARGINOUTSIDE, 0, SCREENWIDTH - MARGINOUTSIDE * 2, self.titleDetailSize.height + 14)];
    label.text = self.questionText;
    label.font = MAINFONTSIZE;
    label.numberOfLines = 0;
    label.textColor = [UIColor initWithNormalGray];
    
    self.titleDetail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.titleDetailSize.height + 14)];
    self.titleDetail.backgroundColor = [UIColor whiteColor];
    self.titleDetail.center = CGPointMake(SCREENWIDTH / 2, - self.titleDetailSize.height / 2 -7);
    [self.titleDetail addSubview:label];
    [self.view addSubview:self.titleDetail];
    
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:ANSWERURL,(long)self.answerId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        self.singleAnswer = [WBSingleAnswerModel mj_objectWithKeyValues:result[@"answer"]];
        
        [self hideHUD];
        [self setUpAnswerWraper];
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
    
}

-(void)setUpAnswerWraper{
    self.wraperView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGINOUTSIDE, SCREENWIDTH, SCREENHEIGHT- 10 - MARGINOUTSIDE)];
    
    [self.view addSubview:self.wraperView];
    
    [self setUpHeaderView];
    [self setUpAnswerDetail];
}

-(void)setUpHeaderView{
    self.userIcon = [[UIButton alloc] initWithFrame:CGRectMake(MARGININSIDE, 5, 40, 40)];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderColor = [UIColor initWithGreen].CGColor;
    self.userIcon.layer.borderWidth = 1;
    self.userIcon.layer.cornerRadius = 20;
    [self.userIcon setImage:[UIImage sd_imageWithData:[NSData dataWithContentsOfURL:self.dir]] forState:UIControlStateNormal];
    [self.userIcon addTarget:self action:@selector(enterHomepage) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(40 + MARGININSIDE * 2, 10, SCREENWIDTH * 0.5, 14)];
    nickName.font = MAINFONTSIZE;
    nickName.text = self.nickname;
    nickName.textColor = [UIColor initWithNormalGray];
    
    UILabel *createTime = [[UILabel alloc] initWithFrame:CGRectMake(40 + MARGININSIDE * 2, 30, SCREENWIDTH * 0.5, 10)];
    createTime.font = SMALLFONTSIZE;
    createTime.text = self.timeStr;
    createTime.textColor = [UIColor initWithNormalGray];
    
    CGFloat frameX = CGRectGetMaxX(createTime.frame);
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.frame = CGRectMake(frameX, 0, SCREENWIDTH - frameX, 50);
    [self.likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    self.likeButton.titleLabel.font = MAINFONTSIZE;
    _score = self.getIntegral;
    if (self.getIntegral > 1000) {
        [self.likeButton setTitle:[NSString stringWithFormat:@" %dk球币",(int)_score/1000] forState:UIControlStateNormal];
    }else{
        [self.likeButton setTitle:[NSString stringWithFormat:@" %ld球币",(long)_score] forState:UIControlStateNormal];
    }
    [self.likeButton addTarget:self action:@selector(likeTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeTip = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点赞转积分提示.png"]];
    self.likeTip.frame = CGRectMake(SCREENWIDTH / 2, 0, 124, 23);
    self.likeTip.alpha = 0;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:self.userIcon];
    [self.headerView addSubview:nickName];
    [self.headerView addSubview:createTime];
    [self.headerView addSubview:self.likeButton];
    [self.headerView addSubview:self.likeTip];
    
    [self.wraperView addSubview:self.headerView];
}

-(void)setUpAnswerDetail{
    CGFloat maxY = CGRectGetMaxY(self.wraperView.frame);
    
    self.answerDetail = [[WBAttributeTextView alloc] initWithFrame:CGRectMake(0, 51, SCREENWIDTH, maxY - 51 - 59)];
    self.answerDetail.delegate = self;
    self.answerDetail.editable = NO;
    self.answerDetail.backgroundColor = [UIColor whiteColor];
    self.answerDetail.textContainerInset = UIEdgeInsetsMake(MARGININSIDE, MARGININSIDE, self.titleDetailSize.height + MARGININSIDE * 2, MARGININSIDE);
    self.answerDetail.content = self.singleAnswer.answerText;
    self.answerDetail.images = self.singleAnswer.dir;
    self.answerDetail.contentSeparateSign = IMAGE;
    self.answerDetail.imageSeparateSign = @";";
    self.answerDetail.lineSpacing = MARGINOUTSIDE;
    self.answerDetail.paragraphSpacing = MARGINOUTSIDE * 2;
    self.answerDetail.font = MAINFONTSIZE;
    self.answerDetail.fontColor = [UIColor initWithNormalGray];
    self.answerDetail.maxSize = CGSizeMake(self.answerDetail.textContainer.size.width - MARGINOUTSIDE, 300);
    
    [self.answerDetail showContent];
    
    [self.wraperView addSubview:self.answerDetail];;
}

-(void)shareThisAnswer{
    NSArray* imageArray = @[[UIImage imageNamed:@"shareIcon.png"]];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
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
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"好的"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"好的"
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加点击事件

-(void)addGestureRecognizer{
    if (self.fromHomePage) {
        return;
    }
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTap)];
    [self.navigationItem.titleView addGestureRecognizer:titleTap];
    
    UITapGestureRecognizer *questionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questionTap)];
    [self.titleDetail addGestureRecognizer:questionTap];
}

-(void)titleTap{
    if (!self.titleIsShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleDetail.center = CGPointMake(SCREENWIDTH / 2, self.titleDetailSize.height / 2 + 7);
            self.wraperView.frame = CGRectMake(0, self.titleDetailSize.height + 14 + MARGINOUTSIDE, SCREENWIDTH, SCREENHEIGHT - 10 - self.titleDetailSize.height - 14);
            _narrow.transform = CGAffineTransformRotate(_narrow.transform, M_PI);
        } completion:^(BOOL finished) {
            self.titleIsShow = !self.titleIsShow;
        }];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.titleDetail.center = CGPointMake(SCREENWIDTH / 2, - self.titleDetailSize.height / 2 -7);
        self.wraperView.frame = CGRectMake(0, MARGINOUTSIDE, SCREENWIDTH, SCREENHEIGHT - 10 - MARGINOUTSIDE);
        _narrow.transform = CGAffineTransformRotate(_narrow.transform, M_PI);
    } completion:^(BOOL finished) {
        self.titleIsShow = !self.titleIsShow;
    }];
    
}

-(void)questionTap{
    if (self.hasPrevPage) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    WBAnswerListController *answerListController = [[WBAnswerListController alloc] init];
    answerListController.fromFindView = self.fromFindView;
    answerListController.isMaster = self.isMaster;
    answerListController.questionText = self.questionText;
    answerListController.questionId = self.questionId;
    answerListController.allAnswers = self.allAnswers;
    answerListController.allIntegral = self.allIntegral;
    [self.navigationController pushViewController:answerListController animated:YES];
}

-(void)enterHomepage{
    WBHomepageViewController *homepage = [[WBHomepageViewController alloc] init];
    homepage.userId = [NSString stringWithFormat:@"%ld",(long)self.userId];
    [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark - 点赞操作

-(void)likeTap{
    if (![WBUserDefaults userId]) {
        [self showHUDText:@"请登录后再打赏"];
        return;
    }
    if ([[WBUserDefaults userId] integerValue] == self.userId) {
        [self showHUDText:@"不能打赏自己哦！"];
        return;
    }
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://app.weiqiu.me/integral/checkIntegral?userId=%@&updateNum=5",[WBUserDefaults userId]] whenSuccess:^(id representData) {
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString: @"true"]) {
            
            [self upLoadLikeTap];
            [self.likeButton setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5f animations:^{
                self.likeButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self.likeTip.frame = CGRectMake(SCREENWIDTH * 2 / 3, 0, 124, 23);
                self.likeTip.alpha = 1;
                _score += 5;
                if (self.getIntegral > 1000) {
                    [self.likeButton setTitle:[NSString stringWithFormat:@" %.1fk球币",_score/1000] forState:UIControlStateNormal];
                }else{
                    [self.likeButton setTitle:[NSString stringWithFormat:@" %ld球币",(long)_score] forState:UIControlStateNormal];
                }
            } completion:^(BOOL finished) {
                [self performSelector:@selector(hideWindow:) withObject:nil afterDelay:0];
            }];
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你当前的积分不足，请充值后再来打赏吧！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
                action;
            })];
            [alert addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    WBIndividualIncomeViewController *chargeView = [[WBIndividualIncomeViewController alloc] init];
                    [self.navigationController pushViewController:chargeView animated:YES];
                }];
                action;
            })];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    } andFailure:^(NSString *error) {
        [self showHUDText:@"网络状态不佳，请稍后再试！"];
    }];
}

-(void)upLoadLikeTap{
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://app.weiqiu.me/tq/answerPraise?answerId=%ld&userId=%@&toUserId=%ld",(long)self.answerId,[WBUserDefaults userId],(long)self.userId] whenSuccess:^(id representData) {
        
    } andFailure:^(NSString *error) {
        
    }];
}

- (void)hideWindow:(id)object{
    [UIView animateWithDuration:0.5f animations:^{
        self.likeButton.transform = CGAffineTransformMakeScale(1,1);
        self.likeTip.frame = CGRectMake(SCREENWIDTH, 0, 124, 23);
    } completion:^(BOOL finished) {
        self.likeTip.alpha = 0;
        self.likeTip.frame = CGRectMake(SCREENWIDTH / 2, 0, 124, 23);
    }];
}


#pragma mark - text view delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(WBTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    if (!textAttachment.image) {
        [self showHUDText:@"未获取到图片，请重试"];
        return YES;
    }
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithImage:textAttachment.image];
    [self presentViewController:viewer animated:YES completion:nil];
    return YES;
}

@end
