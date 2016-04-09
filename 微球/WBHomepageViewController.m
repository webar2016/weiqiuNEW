//
//  WBHomepageViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBHomepageViewController.h"
#import "MyDownLoadManager.h"
#import "WBDataModifiedViewController.h"
#import "WBWebViewController.h"
#import "WBPrivateViewController.h"
#import "WBAnswerListController.h"
#import "WBAnswerDetailController.h"
#import "WBArticalViewController.h"

#import "WBQuestionTableViewCell.h"
#import "WBFansView.h"
#import "WBAttentionView.h"
#import "WBTopicDetailCell.h"

#import "TopicDetailModel.h"
#import "WBSingleAnswerModel.h"
#import "WBQuestionsListModel.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "NSString+string.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface WBHomepageViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WBQuestionTableViewCellDelegate,ModefyData,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TransformValue> {
    
    UIView              *_headView;//头部视图
    UITableView         *_topicTableView;
    UITableView         *_answerTableView;
    
    UIImageView         *_coverImage;//封面图片
    UIImageView         *_headicon;
    UILabel             *_nicknameLabel;
    UIButton            *_sexButton;
    UILabel             *_profileLabel;
    
    UIButton            *_followButton;
    UIButton            *_attentionLeftButton;
    UIButton            *_attentionRightButton;
    
    UIButton            *_topicButton;
    UIButton            *_answerButton;
    UIButton            *_mapButton;
    UIView              *_underLine;

    CGFloat             _headHeight;
    CGFloat             _beginScoller;
    
    NSMutableArray      *_topicsArray;
    NSMutableArray      *_answersArray;
    NSMutableArray      *_rowHeightArray;
    
    NSUInteger          _topicPage;
    NSUInteger          _answerPage;
    
    NSDictionary        *_userInfo;
    
    WBWebViewController *_mapVC;
    
    UIImagePickerController *_imagePicker;
    
    UIImageView *_backgroundTopic;
    UIImageView *_backgroundAnswer;
}

@property (nonatomic, assign) int selectedRow;

@end

@implementation WBHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topicsArray = [NSMutableArray array];
    _answersArray = [NSMutableArray array];
    _rowHeightArray = [NSMutableArray array];
    
    _mapVC = [[WBWebViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.132.44:92/map/m?userId=%@",self.userId]] andTitle:@"征服地球"];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 19, 19);
    [rightButton setImage:[UIImage imageNamed:@"icon_share-2"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(mutableChoices) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    [self setUpHeadView];
    [self setUpTopicTable];
    [self setUpAnswerTable];
    
    [self showHUDIndicator];
    
    [self loadUserInfo];
    
    _backgroundTopic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _backgroundAnswer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _backgroundTopic.center = CGPointMake(SCREENWIDTH / 2, _headHeight + 80);
    _backgroundAnswer.center = _backgroundTopic.center;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning{
    
}

#pragma maek - create UI

-(void)setUpHeadView{
    _headView = [[UIView alloc] initWithFrame:CGRectZero];
    _headView.backgroundColor = [UIColor whiteColor];
    
    _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 168)];
    _coverImage.layer.masksToBounds = YES;
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    _coverImage.image = [UIImage imageNamed:@"cover"];
    _coverImage.userInteractionEnabled = YES;
    
    if ([self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeCoverImage)];
        _coverImage.userInteractionEnabled = YES;
        [_coverImage addGestureRecognizer:tap];
    }
    [_headView addSubview:_coverImage];
    
    _headicon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    _headicon.center = CGPointMake(SCREENWIDTH / 2, 168);
    _headicon.backgroundColor = [UIColor initWithBackgroundGray];
    _headicon.layer.masksToBounds = YES;
    _headicon.layer.cornerRadius = 32;
    _headicon.layer.borderWidth = 2;
    _headicon.layer.borderColor = [UIColor initWithGreen].CGColor;
    _headicon.userInteractionEnabled = YES;
    [_headView addSubview:_headicon];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setImage:[UIImage imageNamed:@"icon_personalinfo"] forState:UIControlStateNormal];
    infoBtn.frame = CGRectMake(15, 174, 32, 32);
    [infoBtn addTarget:self action:@selector(enterInfosView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setImage:[UIImage imageNamed:@"icon_chat"] forState:UIControlStateNormal];
    chatBtn.frame = CGRectMake(SCREENWIDTH - 47, 174, 32, 32);
    [chatBtn addTarget:self action:@selector(enterChatView) forControlEvents:UIControlEventTouchUpInside];
    if ([self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]) {
        [_headView addSubview:infoBtn];
        
    }else{
        [_headView addSubview:chatBtn];
    }
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, 18)];
    _nicknameLabel.font = BIGFONTSIZE;
    _nicknameLabel.textColor = [UIColor initWithNormalGray];
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
   // _nickname.text = [WBUserDefaults nickname];
    [_headView addSubview:_nicknameLabel];

    _sexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headView addSubview:_sexButton];

    _profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH / 4, 168+32+20+27, SCREENWIDTH / 2, 25)];
    _profileLabel.font = SMALLFONTSIZE;
    _profileLabel.numberOfLines = 2;
    _profileLabel.textAlignment = NSTextAlignmentCenter;
    _profileLabel.textColor = [UIColor initWithNormalGray];
    [_headView addSubview:_profileLabel];
    
    _attentionLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionLeftButton.frame = CGRectMake(SCREENWIDTH/2-100, 168+32+20+30+30, 95, 20);
    [_headView addSubview:_attentionLeftButton];
    _attentionLeftButton.titleLabel.font = MAINFONTSIZE;
    _attentionLeftButton.tag = 500;
    [_attentionLeftButton addTarget:self action:@selector(selfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_attentionLeftButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    [_attentionLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    UILabel *followAndCare = [[UILabel alloc] initWithFrame:CGRectMake(0, 250+33, SCREENWIDTH, 14)];
    followAndCare.font = MAINFONTSIZE;
    followAndCare.textColor = [UIColor initWithNormalGray];
    followAndCare.textAlignment = NSTextAlignmentCenter;
    followAndCare.text = @"·";
    [_headView addSubview:followAndCare];
    
    _attentionRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _attentionRightButton.frame = CGRectMake(SCREENWIDTH/2+5, 168+32+20+30+30, 95, 20);
    [_headView addSubview:_attentionRightButton];
    _attentionRightButton.titleLabel.font = MAINFONTSIZE;
    _attentionRightButton.tag = 501;
    [_attentionRightButton addTarget:self action:@selector(selfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_attentionRightButton setTitleColor:[UIColor initWithLightGray] forState:UIControlStateNormal];
    [_attentionRightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    CGSize buttonSize = CGSizeMake(SCREENWIDTH / 3, 44);
    CGPoint point;
    
    if (![self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _followButton.center = CGPointMake(SCREENWIDTH / 2, 330);
        _followButton.layer.masksToBounds = YES;
        _followButton.layer.cornerRadius = 4;
        _followButton.tag = 50;
        [_followButton addTarget:self action:@selector(concernsOperation:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_followButton];
        
        point = CGPointMake(0, 360);
    } else {
        point = CGPointMake(0, 300);
    }
    
    _topicButton = [[UIButton alloc] initWithFrame:(CGRect){point,buttonSize}];
    [_topicButton setTitle:@"话题" forState:UIControlStateNormal];
    [_topicButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [_topicButton addTarget:self action:@selector(changeSelectedPage:) forControlEvents:UIControlEventTouchUpInside];
    _topicButton.tag = 111;
    _answerButton = [[UIButton alloc] initWithFrame:(CGRect){{SCREENWIDTH / 3,point.y},buttonSize}];
    [_answerButton setTitle:@"问题" forState:UIControlStateNormal];
    [_answerButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [_answerButton addTarget:self action:@selector(changeSelectedPage:) forControlEvents:UIControlEventTouchUpInside];
    _answerButton.tag = 222;
    _mapButton = [[UIButton alloc] initWithFrame:(CGRect){{SCREENWIDTH / 3 * 2,point.y},buttonSize}];
    [_mapButton setTitle:@"地图" forState:UIControlStateNormal];
    [_mapButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [_mapButton addTarget:self action:@selector(changeSelectedPage:) forControlEvents:UIControlEventTouchUpInside];
    _mapButton.tag = 333;
    [_headView addSubview:_topicButton];
    [_headView addSubview:_answerButton];
    [_headView addSubview:_mapButton];
    
    _headHeight = CGRectGetMaxY(_topicButton.frame);
    
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 3, 2)];
    _underLine.center = CGPointMake(SCREENWIDTH / 6, _headHeight - 1);
    _underLine.backgroundColor = [UIColor initWithGreen];
    [_headView addSubview:_underLine];
    
    _headView.frame = CGRectMake(0, 0, SCREENWIDTH, _headHeight);
}

-(void)setConfigHeadView{
    

    if ([_userInfo objectForKey:@"personalImage"]) {
        
        [_coverImage sd_setImageWithURL:[NSURL URLWithString:[_userInfo objectForKey:@"personalImage"]] placeholderImage:[UIImage imageNamed:@"cover.png"]];
    }
    [_headicon sd_setImageWithURL:[NSURL URLWithString:[_userInfo objectForKey:@"dir"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageViewer)];
    [_headicon addGestureRecognizer:tap];
    _nicknameLabel.text = [_userInfo objectForKey:@"nickname"];
    
    
    CGSize size = [_nicknameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_nicknameLabel.font,NSFontAttributeName, nil]];
    _sexButton.frame = CGRectMake(SCREENWIDTH/2+size.width/2+15, _nicknameLabel.frame.origin.y + 2, 30, 15);
    _sexButton.layer.masksToBounds = YES;
    _sexButton.layer.cornerRadius = 2;
    _sexButton.backgroundColor = [UIColor initWithGreen];
    [_sexButton setImage:[UIImage imageNamed:@"icon_male.png"] forState:UIControlStateNormal];
    [_sexButton setTitle:[NSString stringWithFormat:@" %@",[_userInfo objectForKey:@"sex"]]  forState:UIControlStateNormal];
    _sexButton.backgroundColor = [UIColor initWithGreen];
    _sexButton.titleLabel.font = SMALLFONTSIZE;
    
    _profileLabel.text = [NSString stringWithFormat:@"%@",[_userInfo objectForKey:@"profile"]];
    
    [_attentionLeftButton setTitle:[NSString stringWithFormat:@"%@ 关注",[_userInfo objectForKey:@"concerns"]] forState:UIControlStateNormal];
    [_attentionRightButton setTitle:[NSString stringWithFormat:@"%@ 粉丝",[_userInfo objectForKey:@"fans"]] forState:UIControlStateNormal];
    [_attentionLeftButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [_attentionRightButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    
    if ([[_userInfo objectForKey:@"isFriend"]isEqualToString:@"0"]) {
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor initWithGreen]];
    }else{
       
        [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor initWithBackgroundGray]];
    }
    
}

-(void)setUpTopicTable{
    _topicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    _topicTableView.tag = 100;
    _topicTableView.delegate = self;
    _topicTableView.dataSource = self;
    _topicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topicTableView.backgroundColor = [UIColor initWithBackgroundGray];
    _topicTableView.tableHeaderView = _headView;
    [self.view addSubview:_topicTableView];
}

-(void)setUpAnswerTable{
    _answerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
    _answerTableView.tag = 200;
    _answerTableView.delegate = self;
    _answerTableView.dataSource = self;
    _answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _answerTableView.backgroundColor = [UIColor initWithBackgroundGray];
    _topicTableView.tableHeaderView = _headView;
    _answerTableView.hidden = YES;
    [self.view addSubview:_answerTableView];
}

-(void)showImageViewer{
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithImage:_headicon.image];
    [self presentViewController:viewer animated:YES completion:nil];
}

#pragma mark - load data

-(void)loadUserInfo{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/user/userHome?friendId=%@&userId=%@",self.userId,[WBUserDefaults userId]];
        [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userInfo = [result objectForKey:@"userInfo"];
            _userInfo = userInfo;
            self.navigationItem.title = userInfo[@"nickname"];
        }
        [self setConfigHeadView];
        [self loadTopics];
        [self loadAnswers];
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

-(void)loadTopics{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserComment?userId=%@",self.userId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        _topicsArray = [TopicDetailModel mj_objectArrayWithKeyValuesArray:result[@"topicCommentList"]];
        for (NSInteger i=0; i<_topicsArray.count; i++) {
            TopicDetailModel *model = _topicsArray[i];
            if (model.newsType == 1) {
                [_rowHeightArray addObject:[NSString stringWithFormat:@"%f",(136.0 + SCREENWIDTH)]];
            } else if (model.newsType == 2) {
                [_rowHeightArray addObject:[NSString stringWithFormat:@"%f",(110.0 + SCREENWIDTH)]];
            } else {
                [_rowHeightArray addObject:[NSString stringWithFormat:@"%f",285.0]];
            }
        }
        if (_topicsArray.count == 0) {
            [_topicTableView addSubview:_backgroundTopic];
        } else {
            [_backgroundTopic removeFromSuperview];
        }
        [self hideHUD];
        [_topicTableView reloadData];
        
    } andFailure:^(NSString *error) {
        [self hideHUD];
        [self showHUDComplete:@"网络状态不佳，请稍后再试！"];
    }];
}

-(void)loadAnswers{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserAnswer?userId=%@",self.userId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        _answersArray = [WBSingleAnswerModel mj_objectArrayWithKeyValuesArray:result[@"answers"]];
        if (_answersArray.count == 0) {
            [_answerTableView addSubview:_backgroundAnswer];
        } else {
            [_backgroundAnswer removeFromSuperview];
        }
        [_answerTableView reloadData];
        
    } andFailure:^(NSString *error) {
        [self showHUDComplete:@"网络状态不佳，请稍后再试！"];
    }];
}

#pragma mark - table delegate datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 100) {
        return _topicsArray.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 1;
    }
    return _answersArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 9;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        TopicDetailModel *model = _topicsArray[indexPath.section];
        if (model.newsType == 1) {
            static NSString *cellID1 = @"detailCellID1";
            WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
            if (cell == nil) {
                cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = model;
            return cell;
        } else if (model.newsType == 2) {
            static NSString *cellID2 = @"detailCellID2";
            WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
            if (cell == nil) {
                cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = model;
            return cell;
        } else {
            static NSString *cellID3 = @"detailCellID3";
            WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
            if (cell == nil) {
                cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = model;
            return cell;
        }
    } else {
        static NSString *SecondPageCell = @"SecondPageCell";
        WBQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondPageCell];
        if (cell == nil)
        {
            cell = [[WBQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondPageCell withData:_answersArray[indexPath.row]];
        }
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _answersArray[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return [_rowHeightArray[indexPath.section] floatValue];
    } else {
        UITableViewCell *cell = [self tableView:_answerTableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]] && tableView.tag == 100){
    return   UITableViewCellEditingStyleDelete;
    }else{
    
        return UITableViewCellEditingStyleNone;
    }
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]){
    
      if (editingStyle ==UITableViewCellEditingStyleDelete)
       {
          if (_topicTableView.hidden) {
              
              
          }else{
             [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/tq/deleteComment?commentId=%ld",(long)((TopicDetailModel *)_topicsArray[indexPath.section]). commentId] whenSuccess:^(id representData) {
                 [_topicsArray removeObjectAtIndex:indexPath.row];
                 [_topicTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
             } andFailure:^(NSString *error) {
                
             }];
        }
      }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicDetailModel *model = _topicsArray[indexPath.section];
    if (model.newsType == 3 && tableView.tag == 100) {
        WBArticalViewController *articalVC = [[WBArticalViewController alloc] init];
        articalVC.navigationItem.title = model.topicContent;
        articalVC.nickname = model.tblUser.nickname;
        articalVC.dir = model.tblUser.dir;
        articalVC.timeStr = model.timeStr;
        articalVC.commentId = model.commentId;
        articalVC.userId = model.userId;
        [self.navigationController pushViewController:articalVC animated:YES];
        return;
    }
}

#pragma mark - other operations

//获取粉丝和关注列表
-(void)selfBtnClicked:(UIButton *)btn{
    if (btn.tag ==500) {
        WBAttentionView *AVC = [[WBAttentionView alloc]init];
        if (![self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]) {
            AVC.showUserId = self.userId;
        }else{
            AVC.showUserId = [WBUserDefaults userId];
        }
        [self.navigationController pushViewController:AVC animated:YES];
        
    }else if (btn.tag ==501){
        WBFansView *FVC = [[WBFansView alloc]init];
        if (![self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]) {
            FVC.showUserId = self.userId;
        }else{
            FVC.showUserId = [WBUserDefaults userId];
        }
        [self.navigationController pushViewController:FVC animated:YES];
    
    }
}

-(void)concernsOperation:(UIButton *)btn{
    if (btn.tag == 50) {
        if ([btn.titleLabel.text isEqualToString:@"关注"]) {
            [self showHUD:@"正在关注" isDim:YES];
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/followFriend?userId=%@&friendId=%@",[WBUserDefaults userId],self.userId] whenSuccess:^(id representData) {
                id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                if ([[result objectForKey:@"msg"]isEqualToString:@"关注成功"]) {
                    [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
                    [_followButton setBackgroundColor:[UIColor initWithBackgroundGray]];
                    [self showHUDComplete:@"关注成功"];
                }else{
                [self showHUDComplete:@"关注失败"];
                }
            } andFailure:^(NSString *error) {
                [self showHUDComplete:@"关注失败"];
            }];
 
        }else{
            [self showHUD:@"正在取消关注" isDim:YES];
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/cancelFollow?userId=%@&friendId=%@",[WBUserDefaults userId],self.userId] whenSuccess:^(id representData) {
                id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                if ([[result objectForKey:@"msg"]isEqualToString:@"取消关注成功"]) {
                    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                    [_followButton setBackgroundColor:[UIColor initWithGreen]];
                    [self showHUDComplete:@"取消关注成功"];
                }else{
                [self showHUDComplete:@"取消关注失败"];
                
                }
                
            } andFailure:^(NSString *error) {
                [self showHUDComplete:@"取消关注失败"];
            }];
        
        }
    }
}

-(CGFloat)calculateStationWidth:(NSString *)string andWithTextWidth:(CGFloat)textWidth anfont:(CGFloat)fontSize{
    UIFont * tfont = [UIFont systemFontOfSize:fontSize];
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(textWidth,CGFLOAT_MAX);
    //    获取当前文本的属性
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    return actualsize.height;
}

-(void)changeSelectedPage:(UIButton *)sender{
    switch (sender.tag) {
        case 111:{
            _topicTableView.hidden = NO;
            _answerTableView.hidden = YES;
            _answerTableView.tableHeaderView = nil;
            _topicTableView.tableHeaderView = _headView;
            [_topicTableView setContentOffset:CGPointMake(0,0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                _underLine.center = CGPointMake(SCREENWIDTH / 6, _headHeight - 1);
            }];
        }
            
            break;
        case 222:{
            _topicTableView.hidden = YES;
            _answerTableView.hidden = NO;
            _topicTableView.tableHeaderView = nil;
            _answerTableView.tableHeaderView = _headView;
            [_answerTableView setContentOffset:CGPointMake(0,0) animated:NO];
            [UIView animateWithDuration:0.3 animations:^{
                _underLine.center = CGPointMake(SCREENWIDTH / 2, _headHeight - 1);
            }];
        }
            
            break;
        case 333:{
            [self.navigationController pushViewController:_mapVC animated:YES];
        }
            
            break;
    }
}

-(void)enterInfosView{
    WBDataModifiedViewController *DVC = [[WBDataModifiedViewController alloc]init];
    DVC.userInfo = _userInfo;
    DVC.delegate = self;
    [self.navigationController pushViewController:DVC animated:YES];
}

-(void)enterChatView{
    WBPrivateViewController *chatView = [[WBPrivateViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.userId];
    chatView.fromHomePage = YES;
    chatView.title = self.navigationItem.title;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)ModefyViewDelegate{
    
    _headicon.image= [WBUserDefaults headIcon];
    
    _nicknameLabel.text = [WBUserDefaults nickname];
}


#pragma mark -----   改变背景图  -------
-(void)changeCoverImage{
    _imagePicker = [[UIImagePickerController alloc]init];
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePicker.delegate = self;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    _imagePicker.allowsEditing = YES;
    _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相机
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:^{
            
        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:^{
            
        }];
        
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"个人主页封面" message:@"选一张你喜欢的照片作为你的个人主页封面吧！" preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    [self presentViewController:aleVC animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}


//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        [self showHUD:@"正在上传" isDim:YES];
        [_coverImage setImage:info[UIImagePickerControllerEditedImage]];
        
        NSDictionary *parameters = @{@"userId":[WBUserDefaults userId]};
        NSData *imageData = UIImageJPEGRepresentation(_coverImage.image, 0.4);
        [MyDownLoadManager postUrl:@"http://121.40.132.44:92/user/updateCover" withParameters:parameters fileData:imageData name:[WBUserDefaults userId] fileName:[NSString stringWithFormat:@"%@.jpg",[WBUserDefaults userId]] mimeType:@"image/jpeg" whenProgress:^(NSProgress *FieldDataBlock) {
            
        } andSuccess:^(id representData) {
            
            [WBUserDefaults setCoverImage:_coverImage.image];
            [self showHUDComplete:@"上传成功"];
        } andFailure:^(NSString *error) {
            [self showHUDComplete:@"上传失败"];
        }];
        
    }else{
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - question tableview cell tap delegate

-(void)questionView:(WBQuestionTableViewCell *)cell{
    [self answerView:cell];
}

-(void)answerView:(WBQuestionTableViewCell *)cell{
    self.selectedRow = (int)cell.tag;
    WBAnswerDetailController *answerDetailController = [[WBAnswerDetailController alloc] init];
    [answerDetailController setHidesBottomBarWhenPushed:YES];
    WBSingleAnswerModel *data = _answersArray[self.selectedRow];
    answerDetailController.questionText = data.questionText;
    answerDetailController.answerId = data.answerId;
    answerDetailController.questionId = data.questionId;
    answerDetailController.allIntegral = data.getIntegral;
    answerDetailController.dir = data.tblUser.dir;
    answerDetailController.nickname = data.tblUser.nickname;
    answerDetailController.timeStr = data.timeStr;
    answerDetailController.getIntegral = data.getIntegral;
    answerDetailController.userId = data.tblUser.userId;
    answerDetailController.fromHomePage = YES;
    [self.navigationController pushViewController:answerDetailController animated:YES];
}

-(void)mutableChoices{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self shareThisHomePage];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self wbPolice];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)wbPolice{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入举报信息" message:@"请勿恶意举报，否则可能导致您被封号！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [MyDownLoadManager postUrl:@"http://121.40.132.44:92/report/reportUser" withParameters:@{@"userId":[WBUserDefaults userId],@"toUserId":self.userId,@"content":alert.textFields.firstObject.text} whenProgress:^(NSProgress *FieldDataBlock) {
            } andSuccess:^(id representData) {
                [self showHUDText:@"举报成功"];
            } andFailure:^(NSString *error) {
                [self showHUDText:@"举报失败，请稍后再试"];
            }];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)shareThisHomePage{
    NSArray* imageArray = @[[UIImage imageNamed:@"shareIcon.png"]];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我分享了一个微球主页，简直太棒了！"
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.132.44:92/map/m?userId=%@",self.userId]]
                                          title:@"快来微球征服地球！"
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

#pragma mark ---cell delegate----
-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation cancelMessage:(NSString *)cancelMessage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageContent message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (!(cancelMessage == nil || cancelMessage == NULL)) {
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelMessage style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
    }else{
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            action;
        })];
    }
    
    NSLog(@"%@",opreation);
    if (!(opreation == nil || opreation == NULL)) {
        [alert addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:opreation style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            action;
        })];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)gotoHomePage:(NSIndexPath *)indexPath{
    return;
}

-(void)showImageViewer:(NSIndexPath *)indexPath{
    TopicDetailModel *model = _topicsArray[indexPath.section];
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithDir:model.dir andContent:model.comment];
    [self presentViewController:viewer animated:YES completion:nil];
}

-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath{
    [self loadUserInfo];
}

-(void)commentClickedPushView:(NSIndexPath *)indexPath{
    WBTopicCommentTableViewController *commentView = [[WBTopicCommentTableViewController alloc]init];
    commentView.commentId =((TopicDetailModel *)_topicsArray[indexPath.section]).commentId;
    commentView.userId =[NSString stringWithFormat:@"%ld", (long)((TopicDetailModel *)_topicsArray[indexPath.section]).userId];
    [self.navigationController pushViewController:commentView animated:YES];
}

-(void)playMedio:(NSIndexPath *)indexPath{
    NSString *url = ((TopicDetailModel *)_topicsArray[indexPath.section]).dir;
    _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url]];
    _player.movieSourceType=MPMovieSourceTypeStreaming;
    [_player.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    UIButton *closeVedio = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 35)];
    [closeVedio setTitle:@"关闭" forState:UIControlStateNormal];
    [closeVedio setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeVedio addTarget:self action:@selector(finishedPlay) forControlEvents:UIControlEventTouchUpInside];
    [_player.view addSubview:closeVedio];
    [self.view addSubview:_player.view];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [_player play];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

#pragma mark - 播放完成

- (void)finishedPlay
{    [_player.view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}

@end
