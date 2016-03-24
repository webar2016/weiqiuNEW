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

#import "MyDownLoadManager.h"
#import "WBSingleAnswerModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "NSString+string.h"
#import "UILabel+label.h"



#define ANSWERLISTURL @"http://121.40.132.44:92/tq/getAnswers?questionId=%d&p=%d&ps=%d"

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
    if (self.currentPage == 1) {
        [self showHUD:@"正在努力加载..." isDim:NO];
    }
    
    [self loadDataWithPage:self.currentPage];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshTableView{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadDataWithPage:1];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer =[ MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadDataWithPage:self.currentPage];
        
    }];
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
        scoreLabel.text = [NSString stringWithFormat:@"该问题已聚集%.1fk球票",score];
    }else{
        scoreLabel.text = [NSString stringWithFormat:@"该问题已聚集%d球票",(int)score];
    }
    
    //按钮
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - MARGININSIDE - 76, questionSize.height + 36 - 7, 76, 30)];
    joinButton.backgroundColor = [UIColor initWithGreen];
    joinButton.titleLabel.font = MAINFONTSIZE;
    joinButton.layer.cornerRadius = 5;
    if (self.fromFindView) {
        [joinButton setTitle:@"入团回答" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(joinHelpGroup) forControlEvents:UIControlEventTouchUpInside];
    }else if (!self.fromFindView && !self.isMaster) {
        [joinButton setTitle:@"我要回答" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(writeAnswer) forControlEvents:UIControlEventTouchUpInside];
    }else{
        joinButton.backgroundColor = [UIColor initWithRed];
        [joinButton setTitle:@"关闭问题" forState:UIControlStateNormal];
        [joinButton addTarget:self action:@selector(closeQuestion) forControlEvents:UIControlEventTouchUpInside];
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

-(void)loadDataWithPage:(int)page{
    NSString *url = [NSString stringWithFormat:ANSWERLISTURL,(int)self.questionId,page,PAGESIZE];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            NSMutableArray *tempArray = [NSMutableArray array];
            tempArray = [WBSingleAnswerModel mj_objectArrayWithKeyValuesArray:result[@"answers"]];
            if (page == 1) {
                for (WBSingleAnswerModel *temp in tempArray) {
                    int index = 0;
                    if (self.answerList.count) {
                        [self.answerList containsObject:temp] ? [self.answerList insertObject:temp atIndex:index] : self.answerList;
                        index ++;
                    }else{
                        [self.answerList addObject:temp];
                        self.currentPage ++;
                    }
                }
            }else{
                [self.answerList addObjectsFromArray:tempArray];
                self.currentPage ++;
            }
            
            [self.tableView reloadData];
            [self hideHUD];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } andFailure:^(NSString *error) {
        NSLog(@"%@------",error);
    }];
    
}

-(void)joinHelpGroup{
    NSLog(@"%s", __func__);
}

-(void)writeAnswer{
    WBPostArticleViewController *writeAnswerVC = [[WBPostArticleViewController alloc] init];
    [self.navigationController pushViewController:writeAnswerVC animated:YES];
}

-(void)closeQuestion{
    NSLog(@"closeQuestion");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell = [[WBAnswerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withData:self.answerList[indexPath.row]];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.answerList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
    
    [self.navigationController pushViewController:answerDetailController animated:YES];
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
