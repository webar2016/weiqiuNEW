//
//  WBAnswerListController.m
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBAnswerListController.h"
#import "WBAnswerListCell.h"
#import "WBAnswerDetailController.h"
#import "WBPostArticleViewController.h"
#import "LoadViewController.h"

#import "MyDownLoadManager.h"
#import "WBSingleAnswerModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MyDBmanager.h"
#import "WBPositionList.h"

#import "NSString+string.h"
#import "UILabel+label.h"



#define ANSWERLISTURL @"http://app.weiqiu.me/tq/getAnswers?questionId=%d&p=%d&ps=%d"

@interface WBAnswerListController ()

@property (nonatomic, strong) NSMutableArray *answerList;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, assign) int selectedRow;

@end

@implementation WBAnswerListController

-(NSMutableArray *)answerList{
    if (_answerList) {
        return _answerList;
    }
    _answerList = [[NSMutableArray alloc] init];
    return _answerList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld个回答",(long)self.allAnswers];
    
    [self setUpHeaderView];
    
    [self refreshTableView];
    
    self.currentPage = 1;
    [self showHUDIndicator];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshTableView{
    
    MJRefreshAutoNormalFooter *footer = [ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadData];
        
    }];
    
    [footer setTitle:@"加载更多回答" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载回答" forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadData];
        [footer setTitle:@"加载更多回答" forState:MJRefreshStateIdle];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
}

-(void)setUpHeaderView{
    //问题
    CGSize questionSize = [self.questionText adjustSizeWithWidth:SCREENWIDTH - 2 * MARGININSIDE andFont:MAINFONTSIZE];
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:(CGRect){{MARGININSIDE,MARGININSIDE},{questionSize.width,questionSize.height + 14}}];
    questionLabel.text = self.questionText;
    questionLabel.font = MAINFONTSIZE;
    questionLabel.textColor = [UIColor initWithNormalGray];
    questionLabel.numberOfLines = 0;
    [questionLabel setLineSpace:LINESPACE withContent:self.questionText];
    
    //票数
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGININSIDE, questionSize.height + 36, SCREENWIDTH / 2, 14)];
    scoreLabel.font = MAINFONTSIZE;
    scoreLabel.textColor = [UIColor initWithLightGray];
    float score = (float)self.allIntegral;
    if (score >= 1000) {
        score = score / 1000;
        scoreLabel.text = [NSString stringWithFormat:@"该问题已聚集%.1fk球币",score];
    }else{
        scoreLabel.text = [NSString stringWithFormat:@"该问题已聚集%d球币",(int)score];
    }
    
    //按钮
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - MARGININSIDE - 76, questionSize.height + 36 - 7, 76, 30)];
    joinButton.backgroundColor = [UIColor initWithGreen];
    joinButton.titleLabel.font = MAINFONTSIZE;
    joinButton.layer.cornerRadius = 5;
    if ([self.isSolved isEqualToString:@"Y"]) {
        joinButton.backgroundColor = [UIColor initWithNormalGray];
        [joinButton setTitle:@"已关闭" forState:UIControlStateNormal];
    }else if (!self.isMaster) {
        [joinButton setTitle:@"我要回答" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(writeAnswer) forControlEvents:UIControlEventTouchUpInside];
    }else{
        joinButton.backgroundColor = [UIColor initWithRed];
        [joinButton setTitle:@"关闭问题" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(closeQuestion:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //headerView
    CGFloat maxHeight = CGRectGetMaxY(scoreLabel.frame);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, maxHeight + 18)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:questionLabel];
    [headerView addSubview:scoreLabel];
    [headerView addSubview:joinButton];
    self.tableView.tableHeaderView = headerView;

}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:ANSWERLISTURL,(int)self.questionId,self.currentPage,PAGESIZE];
    
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]){
            
            NSArray *tempArray = [WBSingleAnswerModel mj_objectArrayWithKeyValuesArray:result[@"answers"]];
            if (self.currentPage == 1) {
                [self.answerList removeAllObjects];
            }
            [self.answerList addObjectsFromArray:tempArray];
            
            NSInteger count = tempArray.count;
            if (count <= PAGESIZE && count != 0) {
                self.currentPage++;
            }
            if (self.currentPage == 1 && count == 0) {
                [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
            } else if (self.currentPage != 1 && count == 0) {
                [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"没有更多了！" forState:MJRefreshStateIdle];
            }
            
            [self.tableView reloadData];
            [self hideHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } andFailure:^(NSString *error) {
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:@"网络状态不佳，请下拉重试" forState:MJRefreshStateIdle];
        [self hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@------",error);
    }];
    
}

-(void)joinHelpGroup{
    NSLog(@"%s", __func__);
}

-(void)writeAnswer{
    if (![WBUserDefaults userId]) {
        [self alertLogin];
        return;
    }
    
    MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
    WBPositionList *positionList = [[WBPositionList alloc]init];
    NSArray *tempArray =  [[positionList searchCityWithCithName:self.cityStr] objectAtIndex:0];
    if (![manager  isAddedItemsID:[NSString stringWithFormat:@"%@",tempArray[1]]]){
        [self showHUDText:@"你还没有解锁这个城市，请先解锁"];
        return;
    }
    
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://app.weiqiu.me/hg/checkIn?userId=%@&groupId=%@",[WBUserDefaults userId],self.groupId] whenSuccess:^(id representData) {
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString:@"true"]) {
            WBPostArticleViewController *writeAnswerVC = [[WBPostArticleViewController alloc] init];
            writeAnswerVC.groupId = self.groupId;
            writeAnswerVC.questionId = [NSString stringWithFormat:@"%ld",(long)self.questionId];
            writeAnswerVC.isQuestionAnswer = YES;
            [self.navigationController pushViewController:writeAnswerVC animated:YES];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你当前不在这个帮帮团中，加入后才可以回答问题，是否加入？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"加入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://app.weiqiu.me/hg/jion?groupId=%@&userId=%@",self.groupId,[WBUserDefaults userId]] whenSuccess:^(id representData) {
                        
                        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
                        
                        if ( [result isKindOfClass:[NSDictionary class]]) {
                            NSString *error = result[@"error"];
                            if ([error isEqualToString:@"0"]) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"showNewGroup" object:self];
                                WBPostArticleViewController *writeAnswerVC = [[WBPostArticleViewController alloc] init];
                                writeAnswerVC.groupId = self.groupId;
                                writeAnswerVC.questionId = [NSString stringWithFormat:@"%ld",(long)self.questionId];
                                writeAnswerVC.isQuestionAnswer = YES;
                                [self.navigationController pushViewController:writeAnswerVC animated:YES];
                            } else if ([error isEqualToString:@"2"]) {
                                [self showHUDText:@"帮帮团团员已满"];
                            } else {
                                [self showHUDText:@"加入失败，请稍后重试"];
                            }
                        }
                        
                        
                        
                        
                        
                    } andFailure:^(NSString *error) {
                        [self showHUDText:@"网络状态不佳，请稍后再试"];
                    }];
                }];
                action;
            })];
            [alert addAction:({
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
                action;
            })];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } andFailure:^(NSString *error) {
        [self showHUDText:@"网络状态不佳，请稍后再试"];
    }];
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

-(void)closeQuestion:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关闭问题，小伙伴将无法回答，是否确认关闭？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MyDownLoadManager getNsurl:[NSString stringWithFormat:@"http://app.weiqiu.me/hg/closeQuestion?userId=%@&questionId=%ld",[WBUserDefaults userId],(long)self.questionId] whenSuccess:^(id representData) {
                sender.enabled = NO;
                sender.backgroundColor = [UIColor initWithNormalGray];
                [sender setTitle:@"已关闭" forState:UIControlStateNormal];
                [self showHUDText:@"问题关闭成功"];
            } andFailure:^(NSString *error) {
                [self showHUDText:@"问题关闭失败，请检查网络后重试"];
            }];
        }];
        action;
    })];
    [alert addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil];
        action;
    })];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answerList.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"reuseCell";
    WBAnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[WBAnswerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.answerList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WBAnswerListCell getCellHeightWithModel:self.answerList[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WBAnswerDetailController *answerDetailController = [[WBAnswerDetailController alloc] init];
    
    WBSingleAnswerModel *data = self.answerList[indexPath.row];
    answerDetailController.hasPrevPage = YES;
    answerDetailController.questionText = self.questionText;
    answerDetailController.answerId = data.answerId;
    answerDetailController.dir = data.tblUser.dir;
    answerDetailController.nickname = data.tblUser.nickname;
    answerDetailController.timeStr = data.timeStr;
    answerDetailController.getIntegral = data.getIntegral;
    answerDetailController.userId = data.tblUser.userId;
    
    [self.navigationController pushViewController:answerDetailController animated:YES];
}

#pragma mark - MBprogress

-(void)showHUDIndicator{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.activityIndicatorColor = [UIColor blackColor];
}

-(void)showHUDText:(NSString *)title{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.opacity = 0.7;
    self.hud.dimBackground = NO;
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:2.0];
}

-(void)hideHUD{
    [self.hud hide:YES afterDelay:0];
}

@end
