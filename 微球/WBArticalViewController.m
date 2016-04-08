//
//  WBArticalViewController.m
//  微球
//
//  Created by 徐亮 on 16/4/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBArticalViewController.h"
#import "WBIndividualIncomeViewController.h"
#import "WBHomepageViewController.h"

#import "WBAttributeTextView.h"
#import "WBTextAttachment.h"
#import "TopicDetailModel.h"

#import "MyDownLoadManager.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "MJExtension.h"

@interface WBArticalViewController () <UITextViewDelegate>

//包含用户信息和回答的视图
@property (nonatomic, strong) UIView *wraperView;

//回答详情
@property (nonatomic, strong) WBAttributeTextView *articalDetail;

//头部用户信息
@property (nonatomic, strong) UIView *headerView;

//头像
@property (nonatomic, strong) UIButton *userIcon;

//点赞
@property (nonatomic, strong) UIButton *likeButton;

//点赞
@property (nonatomic, strong) UIImageView *likeTip;

//完整问题视图尺寸
@property (nonatomic, assign) CGSize titleDetailSize;

//分数
@property (nonatomic, assign) float score;

@property (nonatomic, strong) TopicDetailModel *artical;

@end

@implementation WBArticalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    [self loadData];
    
    [self showHUDIndicator];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建子控件

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getCommentById?commentId=%ld",(long)self.commentId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];

        self.artical = [TopicDetailModel mj_objectWithKeyValues:result[@"topicComment"]];
        
        [self hideHUD];
        [self setUpArticalWraper];
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
    
}

-(void)setUpArticalWraper{
    self.wraperView = [[UIView alloc] initWithFrame:CGRectMake(0, MARGINOUTSIDE, SCREENWIDTH, SCREENHEIGHT- 10 - MARGINOUTSIDE)];
    
    [self.view addSubview:self.wraperView];
    
    [self setUpHeaderView];
    [self setUpArticalDetail];
}

-(void)setUpHeaderView{
    self.userIcon = [[UIButton alloc] initWithFrame:CGRectMake(MARGININSIDE, 5, 40, 40)];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.borderColor = [UIColor initWithGreen].CGColor;
    self.userIcon.layer.borderWidth = 1;
    self.userIcon.layer.cornerRadius = 20;
    [self.userIcon setImage:[UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dir]]] forState:UIControlStateNormal];
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
    _score = self.artical.getIntegral;
    if (_score > 1000) {
        [self.likeButton setTitle:[NSString stringWithFormat:@" %.1fk球币",_score/1000] forState:UIControlStateNormal];
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

-(void)setUpArticalDetail{
    CGFloat maxY = CGRectGetMaxY(self.wraperView.frame);
    
    self.articalDetail = [[WBAttributeTextView alloc] initWithFrame:CGRectMake(0, 51, SCREENWIDTH, maxY - 51 - 59)];
    self.articalDetail.delegate = self;
    self.articalDetail.editable = NO;
    self.articalDetail.backgroundColor = [UIColor whiteColor];
    self.articalDetail.textContainerInset = UIEdgeInsetsMake(MARGININSIDE, MARGININSIDE, self.titleDetailSize.height + MARGININSIDE * 2, MARGININSIDE);
    self.articalDetail.content = self.artical.comment;
    self.articalDetail.images = self.artical.dir;
    self.articalDetail.contentSeparateSign = IMAGE;
    self.articalDetail.imageSeparateSign = @";";
    self.articalDetail.lineSpacing = MARGINOUTSIDE;
    self.articalDetail.paragraphSpacing = MARGINOUTSIDE * 2;
    self.articalDetail.font = MAINFONTSIZE;
    self.articalDetail.fontColor = [UIColor initWithNormalGray];
    self.articalDetail.maxSize = CGSizeMake(self.articalDetail.textContainer.size.width - MARGINOUTSIDE, 300);
    
    [self.articalDetail showContent];
    
    [self.wraperView addSubview:self.articalDetail];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点赞操作

-(void)likeTap{
    if (![WBUserDefaults userId] || [[WBUserDefaults userId] integerValue] == self.userId) {
        return;
    }
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/integral/checkIntegral?userId=%@&updateNum=5",[WBUserDefaults userId]] whenSuccess:^(id representData) {
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString: @"true"]) {
            
            [self upLoadLikeTap];
            [self.likeButton setImage:[UIImage imageNamed:@"icon_liked.png"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5f animations:^{
                self.likeButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self.likeTip.frame = CGRectMake(SCREENWIDTH * 2 / 3, 0, 124, 23);
                self.likeTip.alpha = 1;
                _score += 5;
                if (_score > 1000) {
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
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/tq/topicPraise?commentId=%ld&userId=%@&toUserId=%ld",(long)self.commentId,[WBUserDefaults userId],(long)self.userId] whenSuccess:^(id representData) {
        
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

-(void)enterHomepage{
    WBHomepageViewController *homepage = [[WBHomepageViewController alloc] init];
    homepage.userId = [NSString stringWithFormat:@"%ld",(long)self.userId];
    [self.navigationController pushViewController:homepage animated:YES];
}


#pragma mark - text view delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(WBTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithImage:textAttachment.image];
    [self presentViewController:viewer animated:YES completion:nil];
    return YES;
}

@end
