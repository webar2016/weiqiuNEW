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

#import "WBQuestionTableViewCell.h"
#import "WBFansView.h"
#import "WBAttentionView.h"
#import "WBTopicDetailTableViewCell.h"
#import "WBTopicDetailTableViewCell2.h"
#import "WBTopicDetailTableViewCell3.h"



#import "TopicDetailModel.h"
#import "WBSingleAnswerModel.h"
#import "WBQuestionsListModel.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

@interface WBHomepageViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WBQuestionTableViewCellDelegate,ModefyData,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TransformValue,TransformValue2,TransformValue3> {
    
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
    NSMutableArray      *_labelHeightArrayOne;
    
    NSUInteger          _topicPage;
    NSUInteger          _answerPage;
    
    NSDictionary        *_userInfo;
    
    WBWebViewController *_mapVC;
    
    UIImagePickerController *_imagePicker;
}

@property (nonatomic, assign) int selectedRow;

@end

@implementation WBHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topicsArray = [NSMutableArray array];
    _answersArray = [NSMutableArray array];
    _labelHeightArrayOne = [NSMutableArray array];
    
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
    
    [self loadUserInfo];
//    [self loadTopics];
//    [self loadAnswers];
    
//    [self setConfigHeadView];
    
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
   // _headicon.image = [WBUserDefaults headIcon];
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

    _profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 168+32+20+30, SCREENWIDTH, 18)];
    _profileLabel.font = SMALLFONTSIZE;
    _profileLabel.textAlignment = NSTextAlignmentCenter;
    _profileLabel.textColor = [UIColor initWithLightGray];
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

    _nicknameLabel.text = [_userInfo objectForKey:@"nickname"];
    
    
    CGSize size = [_nicknameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_nicknameLabel.font,NSFontAttributeName, nil]];
    NSLog(@"%f,%f",size.height,size.width);
    _sexButton.frame = CGRectMake(SCREENWIDTH/2+size.width-10, _nicknameLabel.frame.origin.y+5, 28, 10);
    _sexButton.layer.masksToBounds = YES;
    _sexButton.layer.cornerRadius = 2;
    _sexButton.backgroundColor = [UIColor initWithGreen];
    [_sexButton setImage:[UIImage imageNamed:@"icon_male.png"] forState:UIControlStateNormal];
    [_sexButton setTitle:[NSString stringWithFormat:@"%@",[_userInfo objectForKey:@"sex"]]  forState:UIControlStateNormal];
    _sexButton.backgroundColor = [UIColor initWithGreen];
    _sexButton.titleLabel.font = SMALLFONTSIZE;
    
    _profileLabel.text = [NSString stringWithFormat:@"简介：%@",[_userInfo objectForKey:@"profile"]];
    
    [_attentionLeftButton setTitle:[NSString stringWithFormat:@"%@关注",[_userInfo objectForKey:@"concerns"]] forState:UIControlStateNormal];
    [_attentionRightButton setTitle:[NSString stringWithFormat:@"%@粉丝",[_userInfo objectForKey:@"fans"]] forState:UIControlStateNormal];
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
    _topicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
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

#pragma mark - load data

-(void)loadUserInfo{
    
    
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/user/userHome?friendId=%@&userId=%@",self.userId,[WBUserDefaults userId]];
        NSLog(@"%@",url);
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
        for (NSInteger i = 0 ; i<_topicsArray.count; i++) {
            _labelHeightArrayOne[i] =[NSString stringWithFormat:@"%f",[self calculateStationWidth:((TopicDetailModel *)_topicsArray[i]).comment andWithTextWidth:SCREENWIDTH-20 anfont:14]];
        }
        [_topicTableView reloadData];
        
    } andFailure:^(NSString *error) {
        
    }];
}

-(void)loadAnswers{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserAnswer?userId=%@",self.userId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        _answersArray = [WBSingleAnswerModel mj_objectArrayWithKeyValuesArray:result[@"answers"]];
        [_answerTableView reloadData];
        
    } andFailure:^(NSString *error) {
        
    }];
}

#pragma mark - table delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return _topicsArray.count;
    } else {
        return _answersArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (((TopicDetailModel *)_topicsArray[indexPath.row]).newsType == 1) {
            static NSString *topCellID = @"detailCellID";
            WBTopicDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
            if (cell == nil)
            {    cell = [[WBTopicDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID ];
                
            }
            TopicDetailModel *model = _topicsArray[indexPath.row];
            //  cell.backgroundColor = [UIColor initWithBackgroundGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setModel:model  labelHeight:[_labelHeightArrayOne[indexPath.row] floatValue]];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if(((TopicDetailModel *)_topicsArray[indexPath.row]).newsType == 2){
            static NSString *topCellID2 = @"detailCellID2";
            WBTopicDetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:topCellID2];
            if (cell == nil)
            {    cell = [[WBTopicDetailTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID2 ];
                
            }
            TopicDetailModel *model = _topicsArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setModel:model  labelHeight:[_labelHeightArrayOne[indexPath.row] floatValue]];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            static NSString *topCellID3 = @"detailCellID3";
            WBTopicDetailTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:topCellID3];
            if (cell == nil)
            {    cell = [[WBTopicDetailTableViewCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID3 ];
                
            }
            TopicDetailModel *model = _topicsArray[indexPath.row];
            //  cell.backgroundColor = [UIColor initWithBackgroundGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setModel:model  labelHeight:[_labelHeightArrayOne[indexPath.row] floatValue]];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        if (((TopicDetailModel *)_topicsArray[indexPath.row]).newsType==3) {
            
            return 175+[_labelHeightArrayOne[indexPath.row] floatValue]+120+20;
        }else if (((TopicDetailModel *)_topicsArray[indexPath.row]).newsType==1){
            return   [((TopicDetailModel *)_topicsArray[indexPath.row]).imgRate floatValue]*SCREENWIDTH+[_labelHeightArrayOne[indexPath.row] floatValue]+132;
        }else{
            return [((TopicDetailModel *)_topicsArray[indexPath.row]).imgRate floatValue]*SCREENWIDTH+[_labelHeightArrayOne[indexPath.row] floatValue]+132;
        }
    } else {
        UITableViewCell *cell = [self tableView:_answerTableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.userId isEqual:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]){
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
             [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/tq/deleteComment?commentId=%ld",((TopicDetailModel *)_topicsArray[indexPath.row]). commentId] whenSuccess:^(id representData) {
                 NSLog(@"----success-----");
                 [_topicsArray removeObjectAtIndex:indexPath.row];
                
                 [_topicTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
             } andFailure:^(NSString *error) {
                
             }];
        }
      }
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
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/followFriend?userId=%@&friendId=%@",[WBUserDefaults userId],self.userId] whenSuccess:^(id representData) {
                id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                if ([[result objectForKey:@"msg"]isEqualToString:@"关注成功"]) {
                    [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
                    [_followButton setBackgroundColor:[UIColor initWithBackgroundGray]];
                }
                
            } andFailure:^(NSString *error) {
                
            }];
 
        }else{
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://121.40.132.44:92/relationship/cancelFollow?userId=%@&friendId=%@",[WBUserDefaults userId],self.userId] whenSuccess:^(id representData) {
                id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                if ([[result objectForKey:@"msg"]isEqualToString:@"取消关注成功"]) {
                    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
                    [_followButton setBackgroundColor:[UIColor initWithGreen]];
                }
                
            } andFailure:^(NSString *error) {
                
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
    NSLog(@"---ModefyViewDelegate----");
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
            //share operations
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
                [self showHUDComplete:@"举报成功！"];
            } andFailure:^(NSString *error) {
                [self showHUDComplete:@"举报失败，请稍后再试"];
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
    WBHomepageViewController *HVC = [[WBHomepageViewController alloc]init];
    HVC.userId = [NSString stringWithFormat:@"%ld",(long)((TopicDetailModel *)_topicsArray[indexPath.row]).userId ];
    [self.navigationController pushViewController:HVC animated:YES];
}


-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath{
    [self loadUserInfo];
}

-(void)commentClickedPushView:(NSIndexPath *)indexPath{
    WBTopicCommentTableViewController *commentView = [[WBTopicCommentTableViewController alloc]init];
    commentView.commentId =((TopicDetailModel *)_topicsArray[indexPath.row]).commentId;
    commentView.userId =[NSString stringWithFormat:@"%ld", ((TopicDetailModel *)_topicsArray[indexPath.row]).userId];
    [self.navigationController pushViewController:commentView animated:YES];
}

-(void)playMedio:(NSIndexPath *)indexPath{
    NSString *url = ((TopicDetailModel *)_topicsArray[indexPath.row]).dir;
    _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url]];
    //1设置播放器的大小
    _player.movieSourceType=MPMovieSourceTypeStreaming;
    [_player.view setFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]; //16:9是主流媒体的样式
    //2将播放器视图添加到根视图
    [self.view addSubview:_player.view];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [_player play];
    //[self.player stop];
    //通过通知中心，以观察者模式监听视频播放状态
    //1 监听播放状态
    // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    //    //2 监听播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //    //3视频截图
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(caputerImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    //    //3视频截图
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(caputerImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    //
    //    //4退出全屏通知
    //   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitFullScreen) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    //异步视频截图,可以在attimes指定一个或者多个时间。
    //[player requestThumbnailImagesAtTimes:@[@10.0f, @20.0f] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    //    UIImageView *thumbnailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 200, 160, 90)];
    //    self.imageView = thumbnailImageView;
    //    [self.view addSubview:thumbnailImageView];
    
}

#pragma mark 播放完成
- (void)finishedPlay
{
    NSLog(@"播放完成");
    [_player.view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}




#pragma mark - MBprogress
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}
-(void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:2.0];
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0.3];
}



@end
