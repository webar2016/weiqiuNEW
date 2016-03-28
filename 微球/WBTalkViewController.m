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
#import "WBPostArticleViewController.h"
#import "WBQuestionsViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBQuestionsListModel.h"
#import "WBMyGroupModel.h"
#import "AFHTTPSessionManager.h"

#import "UILabel+label.h"

#define QUESTION_NUMBER @"http://121.40.132.44:92/hg/noSolveNum?groupId=%@"
#define QUESTION_IN_GROUP @"http://121.40.132.44:92/tq/getHGQuestion?groupId=%@&p=1&ps=1"

@interface WBTalkViewController () {
    UIView      *_questionView;
    UILabel     *_question;
    UIButton    *_questionButton;
    UIButton    *_lookAll;
}

@property (nonatomic, assign) NSString *groupId;
@property (nonatomic, assign) int questionNumber;
@property (nonatomic, strong) NSMutableArray *model;
@property (nonatomic, assign) NSUInteger firstLoadQuestion;

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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(msgPush:)
                                                 name:@"msgPush"
                                               object:nil];
    
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTipGroup" object:self userInfo:@{@"unReadGroup":[NSString stringWithFormat:@"%@",unReadGroup]}];
    
    self.displayUserNameInCell = YES;
    self.enableContinuousReadUnreadVoice = YES;
    self.groupId = self.targetId;
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [self showHUD:@"正在努力加载..." isDim:NO];
    [self getQuestionTotalNumber];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_groupsetting"] style:UIBarButtonItemStylePlain target:self action:@selector(groupSetting)];
    self.navigationItem.rightBarButtonItem = setting;
    
    self.chatSessionInputBarControl.inputTextView.textColor = [UIColor initWithNormalGray];
}

-(void)msgPush:(NSNotification*)sender{
    if ([sender.userInfo[@"groupId"] isEqualToString:self.targetId]) {
        if ([sender.userInfo[@"msgPush"] isEqualToString: @"1"]) {
            self.isPush = YES;
        } else {
            self.isPush = NO;
        }
    }
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
            NSString *questionBody = [textMsg substringFromIndex:2];
            RCTextMessage *content  = [RCTextMessage messageWithContent:[NSString stringWithFormat:@"我提了一个问题，快来帮我吧！"]];
            [self createWithQuestion:questionBody];
            return content;
        }
    }
    return messageCotent;
}

-(void)createWithQuestion:(NSString *)question{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"userId"] = [WBUserDefaults userId];
    data[@"groupId"] = self.targetId;
    data[@"questionText"] = question;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"http://121.40.132.44:92/hg/ask"];
    [manager POST:url parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"create---success");
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

-(void)getQuestionTotalNumber{
    NSLog(@"%@",self.groupId);
    NSString *url = [NSString stringWithFormat:QUESTION_NUMBER,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        self.questionNumber = [result intValue];
        
        if (self.questionNumber > 0) {
            self.firstLoadQuestion += 1;
            [self loadData];
        }else{
            [self hideHUD];
        }
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:QUESTION_IN_GROUP,self.groupId];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            self.model = [WBQuestionsListModel mj_objectArrayWithKeyValuesArray:result[@"question"]];
        }
        [self hideHUD];
        [self setUpQuestionView];
        
    } andFailure:^(NSString *error) {
        [self hideHUD];
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
    
    
    if (self.isMaster) {
        [_questionButton setTitle:@"查看" forState:UIControlStateNormal];
        [_lookAll setTitle:@"查看所有问题" forState:UIControlStateNormal];
        [_questionButton addTarget:self action:@selector(lookDetail) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [_questionButton setTitle:@"回答" forState:UIControlStateNormal];
        [_lookAll setTitle:[NSString stringWithFormat:@"有%d个问题亟待解决",self.questionNumber] forState:UIControlStateNormal];
        [_questionButton addTarget:self action:@selector(writeAnswer) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
//    CGFloat talkHeight = self.conversationMessageCollectionView.frame.size.height;
//    self.conversationMessageCollectionView.frame = CGRectMake(0, 170, SCREENWIDTH, talkHeight - 105);
//    self.conversationMessageCollectionView.backgroundColor = [UIColor initWithBackgroundGray];
    
}

#pragma mark - 页面跳转

-(void)groupSetting{
    WBGroupSettingViewController *groupSettingVC = [[WBGroupSettingViewController alloc] init];
    groupSettingVC.isMaster = self.isMaster;
    groupSettingVC.groupId = self.groupId;
    groupSettingVC.isPush = self.isPush;
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
    WBPostArticleViewController *writeAnswerVC = [[WBPostArticleViewController alloc] init];
    [self.navigationController pushViewController:writeAnswerVC animated:YES];
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
    [self.hud hide:YES afterDelay:0.3];
}

@end
