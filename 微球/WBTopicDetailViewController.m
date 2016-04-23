//
//  WBTopicDetailViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/3/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTopicDetailViewController.h"
#import "UIColor+color.h"
#import "MyDownLoadManager.h"
#import "TopicDetailModel.h"
#import "MJExtension.h"
#import "UIColor+color.h"
#import "UIImageView+WebCache.h"
#import "WBHomepageViewController.h"
#import "LoadViewController.h"
#import "NSString+string.h"


#import "WBTopicCommentTableViewController.h"
#import "UIImageView+WebCache.h"
#import "WBTopicDetailCell.h"


#import "WBPostIamgeViewController.h"
#import "WBPostArticleViewController.h"
#import "WBArticalViewController.h"
#import <ALBBQuPaiPlugin/ALBBQuPaiPlugin.h>

#define TopicCommentURL @"http://app.weiqiu.me/tq/getTopicComment?topicId=%ld&p=%ld&ps=%d"

@interface WBTopicDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TransformValue>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_rowHeightArray;
    
    UIImageView *_background;
    
    NSInteger _page;
}

@end

@implementation WBTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _dataArray = [NSMutableArray array];
    _rowHeightArray = [NSMutableArray array];
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _background.center = CGPointMake(SCREENWIDTH / 2, 170);
    
    [self createNavi];
    [self createUI];
    
    [self showHUDIndicator];
    
    MJRefreshAutoNormalFooter *footer = [ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [footer setTitle:@"加载更多内容" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载内容" forState:MJRefreshStateRefreshing];
    
    _tableView.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
        [footer setTitle:@"加载更多内容" forState:MJRefreshStateIdle];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _tableView.mj_header = header;
}

-(void)viewWillAppear:(BOOL)animated{
    _page = 1;
    [self loadData];
    [super viewWillAppear:YES];
    
}

-(void)createNavi{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor initWithBackgroundGray];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self createMenuButton];
}

#pragma mark - mutable choose button

-(void)createMenuButton{
    [super createMenuButton];
    //上传照片
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoBtnClicled)];
    _photoImageView.userInteractionEnabled = YES;
    [_photoImageView addGestureRecognizer:tapPhoto];
    //上传视频
    UITapGestureRecognizer *tapMedio = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoBtnClicled)];
    _videoImageView.userInteractionEnabled = YES;
    [_videoImageView addGestureRecognizer:tapMedio];
    //上传文字
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textBtnClicled)];
    _textImageView.userInteractionEnabled = YES;
    [_textImageView addGestureRecognizer:tapText];

}

#pragma mark --------上传图片----------

-(void)photoBtnClicled{
    
    if (![WBUserDefaults userId]) {
        [self alertLogin];
        return;
    }
    
    WBPostIamgeViewController *PIVC = [[WBPostIamgeViewController alloc]init];
    PIVC.topicID = _topicID;
    [self  menuBtnClicled];
    [self.navigationController pushViewController:PIVC animated:YES];
    
}

#pragma mark --------上传视频----------

-(void)videoBtnClicled{
    if (![WBUserDefaults userId]) {
        [self alertLogin];
        return;
    }
    [self menuBtnClicled];
    
    QupaiSDK *sdk = [QupaiSDK shared];
    [sdk setDelegte:(id<QupaiSDKDelegate>)self];
    sdk.thumbnailCompressionQuality = 0.8;
    sdk.tintColor = [UIColor initWithGreen];
    UIViewController *recordController = [sdk createRecordViewControllerWithMinDuration:2 maxDuration:10 bitRate:1500000 videoSize:CGSizeMake(480, 480)];
    [self presentViewController:recordController animated:YES completion:nil];
}

- (void)qupaiSDKCancel:(QupaiSDK *)sdk{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)qupaiSDK:(QupaiSDK *)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    if (videoPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil);
        [self showHUD:@"正在上传视频" isDim:YES];
        NSData  *fileData = [NSData dataWithContentsOfFile:videoPath];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        
        [parameters setObject:[WBUserDefaults userId] forKey:@"userId"];
        [parameters setObject:@"2" forKey:@"newsType"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)_topicID] forKey:@"topicId"];
        
        [MyDownLoadManager postUserInfoUrl:@"http://app.weiqiu.me/tq/setComment" withParameters:parameters fieldData:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:fileData name:@"1234" fileName:@"video1.mov" mimeType:@"video/quicktime"];
            
        } whenProgress:^(NSProgress *FieldDataBlock) {
            
        } andSuccess:^(id representData) {
            [self showHUDComplete:@"上传视频成功"];
            _page = 1;
            [self loadData];
        } andFailure:^(NSString *error) {
            [self showHUDComplete:@"上传视频失败"];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --------上传图文----------

-(void)textBtnClicled{
    if (![WBUserDefaults userId]) {
        [self alertLogin];
        return;
    }
    WBPostArticleViewController *articleViewController = [[WBPostArticleViewController alloc]init];
    articleViewController.navigationItem.title = @"发布长图文";
    articleViewController.topicID = [NSString stringWithFormat:@"%ld",(long)self.topicID];
    [self  menuBtnClicled];
    [self.navigationController pushViewController:articleViewController animated:YES];
}

#pragma mark --------登陆提示----------

-(void)alertLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆后即可进行更多操作！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoadViewController *loginVC = [[LoadViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

//加载数据
-(void) loadData{
    NSString *url = [NSString stringWithFormat:TopicCommentURL,(long)_topicID,(long)_page,PAGESIZE];
    
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *tempArray = [TopicDetailModel mj_objectArrayWithKeyValuesArray:result[@"topicCommentList"]];
            if (_page == 1) {
                [_dataArray removeAllObjects];
                [_rowHeightArray removeAllObjects];
            }
            
            for (TopicDetailModel *model in tempArray) {
                if (model.newsType == 1) {
                    [_rowHeightArray addObject:[NSString stringWithFormat:@"%f",(136.0 + SCREENWIDTH)]];
                } else if (model.newsType == 2) {
                    [_rowHeightArray addObject:[NSString stringWithFormat:@"%f",(110.0 + SCREENWIDTH)]];
                } else {
                    [_rowHeightArray addObject:[NSString stringWithFormat:@"%f",285.0]];
                }
                [_dataArray addObject:model];
            }
            
            NSInteger count = tempArray.count;
            if (count <= PAGESIZE && count != 0) {
                _page++;
            }
            if (_page == 1 && count == 0) {
                [self.view addSubview:_background];
                [(MJRefreshAutoNormalFooter *)_tableView.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
            } else if (_page != 1 && count == 0) {
                [_background removeFromSuperview];
                [(MJRefreshAutoNormalFooter *)_tableView.mj_footer setTitle:@"没有更多了！" forState:MJRefreshStateIdle];
            } else {[_background removeFromSuperview];}
            
            [_tableView reloadData];
            [self hideHUD];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    } andFailure:^(NSString *error) {
        [(MJRefreshAutoNormalFooter *)_tableView.mj_footer setTitle:@"网络状态不佳，请下拉重试" forState:MJRefreshStateIdle];
        [self hideHUD];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"%@------",error);
    }];
}

#pragma mark ---cell delegate----

-(void)unloginAlert{
    [self alertLogin];
}

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
    HVC.userId = [NSString stringWithFormat:@"%ld",(long)((TopicDetailModel *)_dataArray[indexPath.section]).userId ];
    [self.navigationController pushViewController:HVC animated:YES];
}

-(void)showImageViewer:(NSIndexPath *)indexPath{
    TopicDetailModel *model = _dataArray[indexPath.section];
    if (!model.dir) {
        [self showHUDText:@"未获取到图片，请重试"];
        return;
    }
    WBImageViewer *viewer = [[WBImageViewer alloc] initWithDir:model.dir andContent:model.comment];
    [self presentViewController:viewer animated:YES completion:nil];
}

-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath{
    ((TopicDetailModel *)_dataArray[indexPath.section]).getIntegral = ((TopicDetailModel *)_dataArray[indexPath.section]).getIntegral+5;
    NSLog(@"%ld",((TopicDetailModel *)_dataArray[indexPath.section]).getIntegral);
}

-(void)commentClickedPushView:(NSIndexPath *)indexPath{
    
    WBTopicCommentTableViewController *commentView = [[WBTopicCommentTableViewController alloc]init];
    commentView.commentId =((TopicDetailModel *)_dataArray[indexPath.section]).commentId;
    commentView.userId =[NSString stringWithFormat:@"%ld", (long)((TopicDetailModel *)_dataArray[indexPath.section]).userId];
    
    [self.navigationController pushViewController:commentView animated:YES];
    
}

#pragma mark -----------play vedio-------------

-(void)playMedio:(NSIndexPath *)indexPath{
    NSString *url = ((TopicDetailModel *)_dataArray[indexPath.section]).dir;
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

- (void)finishedPlay
{
    [_player stop];
    [_player.view removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
}

#pragma mark --------tableView delegate---------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [_rowHeightArray[indexPath.section] floatValue];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicDetailModel *model = _dataArray[indexPath.section];
    if (model.newsType == 1) {
        static NSString *cellID1 = @"detailCellID1";
        WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell == nil) {
            cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.delegate = self;
        [cell setModel:model];
        return cell;
    } else if (model.newsType == 2) {
        static NSString *cellID2 = @"detailCellID2";
        WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil) {
            cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setModel:model];
        return cell;
    } else {
        static NSString *cellID3 = @"detailCellID3";
        WBTopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (cell == nil) {
            cell = [[WBTopicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        [cell setModel:model];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicDetailModel *model = _dataArray[indexPath.section];
    if (model.newsType == 3) {
        WBArticalViewController *articalVC = [[WBArticalViewController alloc] init];
        articalVC.navigationItem.title = self.navigationItem.title;
        articalVC.nickname = model.tblUser.nickname;
        articalVC.dir = model.tblUser.dir;
        articalVC.timeStr = model.timeStr;
        articalVC.commentId = model.commentId;
        articalVC.userId = model.userId;
        [self.navigationController pushViewController:articalVC animated:YES];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
