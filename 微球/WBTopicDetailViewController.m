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


#import "WBTopicCommentTableViewController.h"
#import "UIImageView+WebCache.h"
#import "WBTopicDetailTableViewCell.h"
#import "WBTopicDetailTableViewCell2.h"
#import "WBTopicDetailTableViewCell3.h"
#import "WBTopicXibTableViewCell.h"


#import "WBPostIamgeViewController.h"
#import "WBPostArticleViewController.h"
#import "WBPostVideoViewController.h"
#import "WBArticalViewController.h"

#define TopicCommentURL @"http://121.40.132.44:92/tq/getTopicComment?topicId=%ld&&userId=%@"

@interface WBTopicDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TransformValue,TransformValue2,TransformValue3,TransformXibValue>
{
    
    UITableView *_tableView;
    
    
    NSMutableArray *_dataArray;
    NSMutableArray *_labelHeightArray;
    
    UIImageView *_background;
    
    NSInteger _page;
    
    UIView *_backgroundView;
    //悬浮按钮
    UIImageView *_imageViewMenu;
    //photo
    UIImageView *_photoImageView;
    //段视频按钮
    UIImageView *_videoImageView;
    //text
    UIImageView *_textImageView;
    
}

@end

@implementation WBTopicDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataArray = [NSMutableArray array];
    //缓冲标志
    _labelHeightArray = [NSMutableArray array];
    _page = 1;
    [self createNavi];
    [self createUI];
    [self showHUD:@"正在努力加载" isDim:NO];
    [self loadData];
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    _background.center = CGPointMake(SCREENWIDTH / 2, 170);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //NSLog(@"进入刷新状态后会自动调用这个block1");
        _page=1;
        [self loadData];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    _tableView.mj_header = header;
    
    _tableView.mj_footer =[ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //  NSLog(@"进入刷新状态后会自动调用这个block2");
        _page++;
        [self loadData];
        
    }];
}

-(void) createNavi{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height-64)];
    _tableView.backgroundColor = [UIColor initWithBackgroundGray];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self createMenuButton];
    
    
    
    
    // WBPostMenuButton *buttonView = [[WBPostMenuButton alloc]initWithFrame:self.view.frame PointX:100 PointY:400 superView:self.view];
    // [self.view addSubview:buttonView];
    
}

//创建悬浮按钮

-(void)createMenuButton{
    //点击悬浮按钮后的透明度
    _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    _backgroundView.alpha = 0;
    _backgroundView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_backgroundView];
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *BGTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
    [_backgroundView addGestureRecognizer:BGTap];
    
    
    //旋转菜单按钮
    _imageViewMenu= [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, self.view.frame.size.height-150, 37, 37)];
    
    _imageViewMenu.image = [UIImage imageNamed:@"btn_cancel.png"];
    _imageViewMenu.transform = CGAffineTransformMakeRotation(M_PI/4);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuBtnClicled)];
    _imageViewMenu.userInteractionEnabled = YES;
    [_imageViewMenu addGestureRecognizer:tap];
    [self.view addSubview:_imageViewMenu];
    //上传照片
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80-30+15, self.view.frame.size.height-150, 64  , 30)];
    _photoImageView.image = [UIImage imageNamed:@"btn_photo.png"];
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoBtnClicled)];
    _photoImageView.userInteractionEnabled = YES;
    [_photoImageView addGestureRecognizer:tapPhoto];
    _photoImageView.alpha = 0;
    [self.view addSubview:_photoImageView];
    //上传视频
    _videoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80-30, self.view.frame.size.height-150, 79  , 30)];
    _videoImageView.image = [UIImage imageNamed:@"icon_video.png"];
    UITapGestureRecognizer *tapMedio = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoBtnClicled)];
    _videoImageView.userInteractionEnabled = YES;
    [_videoImageView addGestureRecognizer:tapMedio];
    _videoImageView.alpha = 0;
    [self.view addSubview:_videoImageView];
    
    //上传文字
    _textImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-80-30, self.view.frame.size.height-150, 79  , 30)];
    _textImageView.image = [UIImage imageNamed:@"btn_ariticle.png"];
    UITapGestureRecognizer *tapText = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textBtnClicled)];
    _textImageView.userInteractionEnabled = YES;
    [_textImageView addGestureRecognizer:tapText];
    _textImageView.alpha = 0;
    [self.view addSubview:_textImageView];
    
    
    
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
    WBPostVideoViewController *VVC = [[WBPostVideoViewController alloc]init];
    VVC.topicID = _topicID;
    [self menuBtnClicled];
    [self.navigationController pushViewController:VVC animated:YES];
}
#pragma mark --------上传图文----------
-(void)textBtnClicled{
    if (![WBUserDefaults userId]) {
        [self alertLogin];
        return;
    }
    WBPostArticleViewController *articleViewController = [[WBPostArticleViewController alloc]init];
    articleViewController.topicID = [NSString stringWithFormat:@"%ld",(long)self.topicID];
    [self  menuBtnClicled];
    [self.navigationController pushViewController:articleViewController animated:YES];
}

-(void)alertLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆后即可发布啦！" message:nil preferredStyle:UIAlertControllerStyleAlert];
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

//菜单栏按钮动画效果
-(void)menuBtnClicled{
    if (_backgroundView.alpha == 0) {
        _photoImageView.alpha = 1;
        _videoImageView.alpha = 1;
        _textImageView.alpha  = 1;
        _backgroundView.alpha = 0.5;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _imageViewMenu.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
        }];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame1 = _photoImageView.frame;
            frame1.origin.y -=70;
            _photoImageView.frame = frame1;
            CGRect frame2 = _videoImageView.frame;
            frame2.origin.y -=140;
            _videoImageView.frame = frame2;
            CGRect frame3 = _textImageView.frame;
            frame3.origin.y -=210;
            _textImageView.frame = frame3;
        } completion:^(BOOL finished) {
        }];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _backgroundView.alpha = 0;
            _imageViewMenu.transform = CGAffineTransformMakeRotation(M_PI/4);
            CGRect frame1 = _photoImageView.frame;
            frame1.origin.y +=70;
            _photoImageView.frame = frame1;
            CGRect frame2 = _videoImageView.frame;
            frame2.origin.y +=140;
            _videoImageView.frame = frame2;
            CGRect frame3 = _textImageView.frame;
            frame3.origin.y +=210;
            _textImageView.frame = frame3;
        } completion:^(BOOL finished) {
            _photoImageView.alpha = 0;
            _videoImageView.alpha = 0;
            _textImageView.alpha  = 0;
        }];
    }
}





//加载数据
-(void) loadData{
    NSString *url = [NSString stringWithFormat:TopicCommentURL,(long)_topicID,[WBUserDefaults userId]]; //TopicCommentURL
    NSLog(@"url %@" ,url);
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if (_page == 1) {
            [_dataArray removeAllObjects];
            
            [_labelHeightArray removeAllObjects];
        }
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrayList = [NSMutableArray arrayWithArray:result[@"topicCommentList"]];
            NSMutableArray *arrayTemp = [NSMutableArray array];
            arrayTemp = [TopicDetailModel mj_objectArrayWithKeyValuesArray:arrayList];
            //  NSLog(@"%d",arrayTemp.count);
            for (NSInteger i=0; i<arrayTemp.count; i++) {
                // NSLog(@"comment = %@",((TopicDetailModel *)_dataArray[i]).comment) ;
                //  NSLog(@"dir = %@",((TopicDetailModel *)_dataArray[i]).dir) ;
                if (((TopicDetailModel *)arrayTemp[i]).newsType == 1) {
                    [_dataArray addObject:arrayTemp[i]];
                    [_labelHeightArray addObject:[NSString stringWithFormat:@"%f",[self calculateLabelHeight:((TopicDetailModel *)arrayTemp[i]).comment]]];
                }else if(((TopicDetailModel *)arrayTemp[i]).newsType == 2){
                    [_dataArray addObject:arrayTemp[i]];
                    [_labelHeightArray addObject:[NSString stringWithFormat:@"%f",[self calculateLabelHeight:((TopicDetailModel *)arrayTemp[i]).comment]]];
                }else{
                    NSArray *labelComponents = [((TopicDetailModel *)arrayTemp[i]).comment componentsSeparatedByString:IMAGE];
                    NSArray *imageComponents = [((TopicDetailModel *)arrayTemp[i]).dir componentsSeparatedByString:@";"];
                    if (labelComponents[0]==nil) {
                        ((TopicDetailModel *)arrayTemp[i]).comment = labelComponents[1];
                    }else{
                        ((TopicDetailModel *)arrayTemp[i]).comment = labelComponents[0];
                    }
                    
                    //  ((TopicDetailModel *)arrayTemp[i]).dir= nil;
                    ((TopicDetailModel *)arrayTemp[i]).dir = imageComponents[0];
                    // NSLog(@"dir = %@",((TopicDetailModel *)arrayTemp[i]).dir);
                    [_dataArray addObject:arrayTemp[i]];
                    [_labelHeightArray addObject:[NSString stringWithFormat:@"%f",[self calculateLabelHeight:((TopicDetailModel *)arrayTemp[i]).comment]]];
                    
                }
                
            }
            [_tableView reloadData];
            //[self performSelector:@selector(hideHUD) withObject:nil afterDelay:5];
            if (_page == 1) {
                [self hideHUD];
                [_tableView.mj_header endRefreshing];
                if (_dataArray.count == 0) {
                    [self.view addSubview:_background];
                }
            }else{
                
                [_tableView.mj_footer endRefreshing];
            }
            
        }
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

//计算文字高度
-(CGFloat)calculateLabelHeight:(NSString *)str{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(SCREENWIDTH-20, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.height;
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
    HVC.userId = [NSString stringWithFormat:@"%ld",(long)((TopicDetailModel *)_dataArray[indexPath.row]).userId ];
    [self.navigationController pushViewController:HVC animated:YES];


}


-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath{
  
    [self loadData];
    
}

-(void)commentClickedPushView:(NSIndexPath *)indexPath{
    
    WBTopicCommentTableViewController *commentView = [[WBTopicCommentTableViewController alloc]init];
    commentView.commentId =((TopicDetailModel *)_dataArray[indexPath.row]).commentId;
    commentView.userId =[NSString stringWithFormat:@"%ld", ((TopicDetailModel *)_dataArray[indexPath.row]).userId];
    
    [self.navigationController pushViewController:commentView animated:YES];
    
}

-(void)playMedio:(NSIndexPath *)indexPath{
    
    
    NSString *url = ((TopicDetailModel *)_dataArray[indexPath.row]).dir;
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

#pragma mark --------tableView delegate---------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (((TopicDetailModel *)_dataArray[indexPath.row]).newsType==3) {
        
        return 175+[_labelHeightArray[indexPath.row] floatValue]+120+20;
    }else if (((TopicDetailModel *)_dataArray[indexPath.row]).newsType==1){
        return   [((TopicDetailModel *)_dataArray[indexPath.row]).imgRate floatValue]*SCREENWIDTH+[_labelHeightArray[indexPath.row] floatValue]+132;
    }else{
        return [((TopicDetailModel *)_dataArray[indexPath.row]).imgRate floatValue]*SCREENWIDTH+[_labelHeightArray[indexPath.row] floatValue]+132;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *cellId = @"TopDetailCellID";
//    
//    WBTopicXibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    
//    if (nil == cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"WBTopicXibTableViewCell" owner:nil options:nil] firstObject];
//        
//    }
//    //显示数据
//    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    TopicDetailModel *model = _dataArray[indexPath.row];
//    [cell configModel:model indexPath:indexPath];
//    return cell;
    
    if (((TopicDetailModel *)_dataArray[indexPath.row]).newsType == 1) {
        static NSString *topCellID = @"detailCellID";
        WBTopicDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        if (cell == nil)
        {    cell = [[WBTopicDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID ];
            
        }
        TopicDetailModel *model = _dataArray[indexPath.row];
        //  cell.backgroundColor = [UIColor initWithBackgroundGray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model  labelHeight:[_labelHeightArray[indexPath.row] floatValue]];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(((TopicDetailModel *)_dataArray[indexPath.row]).newsType == 2){
        static NSString *topCellID2 = @"detailCellID2";
        WBTopicDetailTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:topCellID2];
        if (cell == nil)
        {    cell = [[WBTopicDetailTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellID2 ];
            
        }
        TopicDetailModel *model = _dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model  labelHeight:[_labelHeightArray[indexPath.row] floatValue]];
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
        TopicDetailModel *model = _dataArray[indexPath.row];
        //  cell.backgroundColor = [UIColor initWithBackgroundGray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model  labelHeight:[_labelHeightArray[indexPath.row] floatValue]];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![WBUserDefaults userId]) {
        [self alertLogin];
        return;
    }
    TopicDetailModel *model = _dataArray[indexPath.row];
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
    WBTopicCommentTableViewController *commentView = [[WBTopicCommentTableViewController alloc]init];
    commentView.commentId = ((TopicDetailModel *)_dataArray[indexPath.row]).commentId;
    [self.navigationController pushViewController:commentView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self hideHUD];
}

-(void)hideHUD
{
    [self.hud hide:YES afterDelay:0];
}


@end
