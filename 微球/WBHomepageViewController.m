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
#import "WBMapViewController.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"

#import "WBHomeHeadTableViewCell.h"
#import "WBHomeFirstPageTableViewCell.h"
#import "WBQuestionTableViewCell.h"

#import "WBFansView.h"
#import "WBAttentionView.h"

#import "TopicDetailModel.h"
#import "WBSingleAnswerModel.h"

@interface WBHomepageViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,WBQuestionTableViewCellDelegate,ModefyData> {
    
    UIView              *_headView;//头部视图
    UITableView         *_topicTableView;
    UITableView         *_answerTableView;
    
    UIImageView         *_coverImage;//封面图片
    UIImageView         *_headicon;
    UILabel             *_nickname;
    UIButton            *_followButton;
    
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
    
    WBMapViewController *_mapVC;
}
@end

@implementation WBHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topicsArray = [NSMutableArray array];
    _answersArray = [NSMutableArray array];
    _labelHeightArrayOne = [NSMutableArray array];
    
    _mapVC = [[WBMapViewController alloc] init];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 19, 19);
    [rightButton setImage:[UIImage imageNamed:@"icon_share-2"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    [self setUpHeadView];
    [self setUpTopicTable];
    [self setUpAnswerTable];
    
    [self loadUserInfo];
    [self loadTopics];
    [self loadAnswers];
    
    
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
    _coverImage.image = [UIImage imageNamed:@"1.pic.jpg"];
    _coverImage.userInteractionEnabled = YES;
    [_headView addSubview:_coverImage];
    
    _headicon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    _headicon.center = CGPointMake(SCREENWIDTH / 2, 168);
    _headicon.layer.masksToBounds = YES;
    _headicon.layer.cornerRadius = 32;
    _headicon.layer.borderWidth = 2;
    _headicon.layer.borderColor = [UIColor whiteColor].CGColor;
    _headicon.image = [WBUserDefaults headIcon];
    [_headView addSubview:_headicon];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setImage:[UIImage imageNamed:@"icon_personalinfo"] forState:UIControlStateNormal];
    infoBtn.frame = CGRectMake(15, 174, 32, 32);
    [infoBtn addTarget:self action:@selector(enterInfosView) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:infoBtn];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setImage:[UIImage imageNamed:@"icon_chat"] forState:UIControlStateNormal];
    chatBtn.frame = CGRectMake(SCREENWIDTH - 47, 174, 32, 32);
    
    [_headView addSubview:chatBtn];
    
    _nickname = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, SCREENWIDTH, 18)];
    _nickname.font = BIGFONTSIZE;
    _nickname.textColor = [UIColor initWithNormalGray];
    _nickname.textAlignment = NSTextAlignmentCenter;
    _nickname.text = [WBUserDefaults nickname];
    [_headView addSubview:_nickname];

    UILabel *followAndCare = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, SCREENWIDTH, 14)];
    followAndCare.font = MAINFONTSIZE;
    followAndCare.textColor = [UIColor initWithNormalGray];
    followAndCare.textAlignment = NSTextAlignmentCenter;
    followAndCare.text = @"·";
    [_headView addSubview:followAndCare];
    
    CGSize buttonSize = CGSizeMake(SCREENWIDTH / 3, 44);
    CGPoint point;
    
    if (_friendId) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        _followButton.center = CGPointMake(SCREENWIDTH / 2, 300);
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor initWithGreen]];
        _followButton.layer.masksToBounds = YES;
        _followButton.layer.cornerRadius = 4;
        [_headView addSubview:_followButton];
        
        point = CGPointMake(0, 330);
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
    _answerTableView.hidden = YES;
    [self.view addSubview:_answerTableView];
}

#pragma mark - load data

-(void)loadUserInfo{
    NSString *url;
    if (_friendId==nil) {
        url = [NSString stringWithFormat:@"http://121.40.132.44:92/user/userHome?friendId=%@&userId=%@",[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"],[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]];
    }else{
        url = [NSString stringWithFormat:@"http://121.40.132.44:92/user/userHome?friendId=%@&userId=%@",_friendId,[WBUserDefaults getSingleUserDefaultsWithUserDefaultsKey:@"userId"]];
    }
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userInfo = [result objectForKey:@"userInfo"];
            _userInfo = userInfo;
            self.navigationItem.title = userInfo[@"nickname"];
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

-(void)loadTopics{
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserComment?userId=%@",@"29"];
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
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/tq/getUserAnswer?userId=%@",@"29"];
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
        static NSString *FirstPageCell = @"FirstPageCell";
        WBHomeFirstPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstPageCell];
        if (cell == nil)
        {   cell = [[WBHomeFirstPageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstPageCell ];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:_topicsArray[indexPath.row] withLabelHeight:[_labelHeightArrayOne[indexPath.row] floatValue]];
        return cell;
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
        if (((TopicDetailModel *)_topicsArray[indexPath.row]).newsType == 1) {
            return [((TopicDetailModel *)_topicsArray[indexPath.row]).imgRate floatValue]*SCREENWIDTH+[_labelHeightArrayOne[indexPath.row] floatValue]+132;
        }
        return 380;//168+32+20+30+41+20+29+40;
    } else {
        UITableViewCell *cell = [self tableView:_answerTableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}



#pragma mark - other operations

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

- (void)ModefyViewDelegate{
    NSLog(@"---ModefyViewDelegate----");
    ((UIImageView *)[self.view viewWithTag:102]).image = [WBUserDefaults headIcon];
    
    ((UILabel *)[self.view viewWithTag:402]).text = [WBUserDefaults nickname];
    
    
}

@end
