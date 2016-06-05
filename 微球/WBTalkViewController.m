//
//  WBTalkViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBTalkViewController.h"
#import "WBGroupSettingViewController.h"
#import "WBAnswerListController.h"
#import "WBAnswerDetailController.h"
#import "WBAnswerQuestionViewController.h"
#import "WBQuestionsViewController.h"
#import "WBHomepageViewController.h"
#import "WBMapViewController.h"
#import "WBChatImageViewer.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBQuestionsListModel.h"
#import "WBCollectionViewModel.h"
#import "WBMyGroupModel.h"
#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

#import "UILabel+label.h"

#define QUESTION_NUMBER @"%@/hg/noSolveNum?groupId=%@"
#define QUESTION_IN_GROUP @"%@/tq/getHGQuestion?groupId=%@&p=1&ps=1"
#define GROUP_DETAIL @"%@/hg/oneHG?groupId=%@"

@interface WBTalkViewController () <CLLocationManagerDelegate> {
    UIView      *_questionView;
    UILabel     *_question;
    UIButton    *_questionButton;
    UIButton    *_lookAll;
    
    BOOL        _isGettingQues;
    NSString    *_currentQuestionId;
    
    NSString    *_locate;
    NSString    *_questionBody;
}

@property (nonatomic, assign) NSString *groupId;
@property (nonatomic, assign) int questionNumber;
@property (nonatomic, strong) NSMutableArray *model;
@property (nonatomic, assign) NSUInteger firstLoadQuestion;
@property (nonatomic, strong) WBCollectionViewModel *groupDetail;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation WBTalkViewController

-(NSMutableArray *)model{
    if (_model) {
        return _model;
    }
    _model = [[NSMutableArray alloc] init];
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTipGroup" object:self userInfo:@{@"unReadGroup":[NSString stringWithFormat:@"%@",unReadGroup]}];
    
    self.displayUserNameInCell = YES;
    self.enableContinuousReadUnreadVoice = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
    self.groupId = self.targetId;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
//    [self showHUDIndicator];
    [self getQuestionTotalNumber];
    
    [self loadGroupDetail];
    
    self.chatSessionInputBarControl.inputTextView.textColor = [UIColor initWithNormalGray];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 消息发送前拦截,创建问题

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    if (!self.isMaster) {
        return messageCotent;
    }
    if ([messageCotent isKindOfClass:[RCTextMessage class]]) {
        NSString *textMsg = ((RCTextMessage *)messageCotent).content;
        if (textMsg.length <= 2) {
            return messageCotent;
        }
        NSString *questionSign = [textMsg substringToIndex:2];
        if ([questionSign isEqualToString:@"?:"] || [questionSign isEqualToString:@"？："] || [questionSign isEqualToString:@"?："] || [questionSign isEqualToString:@"？:"]) {
            _questionBody = [textMsg substringFromIndex:2];
            RCTextMessage *content  = [RCTextMessage messageWithContent:[NSString stringWithFormat:@"我提了一个问题，快来帮我吧！"]];
            
            //获取提问题时的位置，并上传到数据库
            if ([CLLocationManager locationServicesEnabled] &&
                ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
                 || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
                    [self.locationManager startUpdatingLocation];
                } else {
                    [self createWithQuestion:_questionBody];
                }
            
            return content;
        }
    }
    return messageCotent;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    _locate = [NSString stringWithFormat:@"%.5f,%.5f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    [self createWithQuestion:_questionBody];
}

-(void)createWithQuestion:(NSString *)question{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"userId"] = [WBUserDefaults userId];
    data[@"locat"] = _locate;
    data[@"groupId"] = self.targetId;
    data[@"questionText"] = question;
    NSLog(@"%@", data);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@/hg/ask",WEBAR_IP];
    [manager POST:url parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _currentQuestionId = responseObject[@"msg"];
//            NSLog(@"%@",_currentQuestionId);
        }
        [self getQuestionTotalNumber];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"create---failure");
    }];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
        if (cell.messageDirection == 1) {
            ((RCTextMessageCell *)cell).textLabel.textColor = [UIColor whiteColor];
        }else{
            ((RCTextMessageCell *)cell).textLabel.textColor = [UIColor initWithNormalGray];
            if ([((RCTextMessageCell *)cell).textLabel.text isEqualToString: @"我提了一个问题，快来帮我吧！"]) {
                [self getQuestionTotalNumber];
            }
        }
    }
}

#pragma mark - 数据加载

-(void)loadGroupDetail{
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_groupsetting"] style:UIBarButtonItemStylePlain target:self action:@selector(groupSetting)];
    
    UIBarButtonItem *groupMap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(enterGroupMap)];
    
    NSString *url = [NSString stringWithFormat:GROUP_DETAIL,WEBAR_IP,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.groupDetail = [WBCollectionViewModel mj_objectWithKeyValues:result[@"helpGroup"]];
            if ([self.groupDetail.destination isEqualToString:@"南京市"]) {
                self.navigationItem.rightBarButtonItems = @[setting,groupMap];
            } else {
                self.navigationItem.rightBarButtonItems = @[setting,groupMap];
            }
        }
        
    } andFailure:^(NSString *error) {
        self.navigationItem.rightBarButtonItems = @[setting,groupMap];
        NSLog(@"%@------",error);
    }];
}

-(void)getQuestionTotalNumber{
//    NSLog(@"%@",self.groupId);
    if (_isGettingQues) {
        return;
    }
    _isGettingQues = YES;
    NSString *url = [NSString stringWithFormat:QUESTION_NUMBER,WEBAR_IP,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        self.questionNumber = [result intValue];
        
        if (self.questionNumber > 0) {
            self.firstLoadQuestion += 1;
            [self loadData];
        }else{
//            [self hideHUD];
        }
        _isGettingQues = NO;
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
        _isGettingQues = NO;
    }];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:QUESTION_IN_GROUP,WEBAR_IP,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.model = [WBQuestionsListModel mj_objectArrayWithKeyValuesArray:result[@"question"]];
        }
        if (self.model.count > 0) {
            _currentQuestionId = [NSString stringWithFormat:@"%ld",(long)((WBQuestionsListModel *)self.model[0]).questionId];
        }
        
//        [self hideHUD];
        [self setUpQuestionView];
        
    } andFailure:^(NSString *error) {
//        [self hideHUD];
        NSLog(@"%@------",error);
    }];
}

-(void)setUpQuestionView{
    WBQuestionsListModel *question = self.model[0];
    NSString *string = question.questionText;
    if (self.firstLoadQuestion == 1) {
        _question = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH - 65, 60)];
        _question.numberOfLines = 3;
        [_question setFont:MAINFONTSIZE];
        _question.textColor = [UIColor initWithNormalGray];
        _question.text = string;
        [_question setLineSpace:LINESPACE withContent:string];
        
        _questionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        _questionButton.center = CGPointMake(SCREENWIDTH - 27.5, 38.5);
        _questionButton.backgroundColor = [UIColor initWithGreen];
        _questionButton.layer.masksToBounds = YES;
        _questionButton.layer.cornerRadius = 17.5;
        [_questionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _questionButton.titleLabel.font = MAINFONTSIZE;
        
        
        _lookAll = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, 28)];
        [_lookAll setBackgroundImage:[UIImage imageNamed:@"bg-21"] forState:UIControlStateNormal];
        [_lookAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _lookAll.titleLabel.font = MAINFONTSIZE;
        
        [_lookAll addTarget:self action:@selector(lookAllQuestions) forControlEvents:UIControlEventTouchUpInside];
        
        
        _questionView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 108)];
        _questionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        
        [_questionView addSubview:_question];
        [_questionView addSubview:_questionButton];
        [_questionView addSubview:_lookAll];
        
        [self.view addSubview:_questionView];
    } else {
        _question.text = string;
    }
    
    if ([((WBQuestionsListModel *)self.model[0]).isSolve isEqualToString:@"Y"]) {
        _questionButton.hidden = YES;
    }else if (self.isMaster) {
        [_questionButton setTitle:@"查看" forState:UIControlStateNormal];
        [_lookAll setTitle:@"查看所有问题" forState:UIControlStateNormal];
        [_questionButton addTarget:self action:@selector(lookDetail) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [_questionButton setTitle:@"回答" forState:UIControlStateNormal];
        [_lookAll setTitle:[NSString stringWithFormat:@"有%d个问题亟待解决",self.questionNumber] forState:UIControlStateNormal];
        [_questionButton addTarget:self action:@selector(writeAnswer) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark - 页面跳转
//进入地图页面
-(void)enterGroupMap{
    WBMapViewController *MVC = [[WBMapViewController alloc]init];
    MVC.userNameTitle = [WBUserDefaults nickname];
    MVC.titleImage = [WBUserDefaults headIcon];
    if (self.model.count > 0) {
        MVC.question = _question.text;
        MVC.locate = ((WBQuestionsListModel *)self.model[0]).locat;
    }
    
    [self.navigationController pushViewController:MVC animated:YES];
}

-(void)groupSetting{
    WBGroupSettingViewController *groupSettingVC = [[WBGroupSettingViewController alloc] init];
    groupSettingVC.isMaster = self.isMaster;
    groupSettingVC.groupId = self.groupId;
    groupSettingVC.groupDetail = self.groupDetail;
    [self.navigationController pushViewController:groupSettingVC animated:YES];
    
}

-(void)lookDetail{
    WBAnswerListController *answerDetailVC = [[WBAnswerListController alloc] init];
    answerDetailVC.fromFindView = NO;
    answerDetailVC.isMaster = self.isMaster;
    WBQuestionsListModel *data = self.model[0];
    answerDetailVC.questionText = data.questionText;
    answerDetailVC.questionId = data.questionId;
    answerDetailVC.allAnswers = data.allAnswers;
    answerDetailVC.allIntegral = data.allIntegral;
    answerDetailVC.isSolved = data.isSolve;
    answerDetailVC.groupId = data.groupId;
    [self.navigationController pushViewController:answerDetailVC animated:YES];
    
}

-(void)lookAllQuestions{
    WBQuestionsViewController *questionListVC = [[WBQuestionsViewController alloc] init];
    questionListVC.fromFindView = NO;
    questionListVC.isMaster = self.isMaster;
    questionListVC.viewTitle = self.title;
    questionListVC.groupId = [self.groupId intValue];
    [self.navigationController pushViewController:questionListVC animated:YES];
}

-(void)writeAnswer{
    WBAnswerQuestionViewController *writeAnswerVC = [[WBAnswerQuestionViewController alloc] initWithGroupId:self.targetId questionId:_currentQuestionId title:((WBQuestionsListModel *)self.model[0]).questionText];
    [self.navigationController pushViewController:writeAnswerVC animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId{
    WBHomepageViewController *friendPage = [[WBHomepageViewController alloc] init];
    friendPage.userId = userId;
    [self.navigationController pushViewController:friendPage animated:YES];
}

-(void)didTapMessageCell:(RCMessageModel *)model{
    if ([model.content isKindOfClass:[RCImageMessage class]]) {
        WBChatImageViewer *imageViewer = [[WBChatImageViewer alloc] initWithChatModel:model];
        [self presentViewController:imageViewer animated:YES completion:nil];
    } else if ([model.content isKindOfClass:[RCLocationMessage class]]) {
        [self presentLocationViewController:(RCLocationMessage *)model.content];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - MBprogress

-(void)showHUDIndicator{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.activityIndicatorColor = [UIColor blackColor];
}

-(void)hideHUD{
    [self.hud hide:YES afterDelay:0];
}


#pragma mark  location

//开始定位
-(void)startLocation{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10.0f;
    [_locationManager startUpdatingLocation];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [_locationManager stopUpdatingLocation];
     NSLog(@"location ok");
     NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    _location = newLocation;
}




@end
