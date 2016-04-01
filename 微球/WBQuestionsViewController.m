//
//  WBQuestionsTableViewController.m
//  微球
//
//  Created by 徐亮 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBQuestionsViewController.h"
#import "WBQuestionTableViewCell.h"
#import "WBAnswerListController.h"
#import "WBAnswerDetailController.h"
#import "WBSearchViewController.h"
#import "WBHomepageViewController.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBQuestionsListModel.h"
#import "MJRefresh.h"

#define QUESTION_IN_FIND @"http://121.40.132.44:92/tq/getQuestion?p=%d&ps=%d"
#define QUESTION_IN_GROUP @"http://121.40.132.44:92/tq/getHGQuestion?groupId=%d&p=%d&ps=%d"

@interface WBQuestionsViewController () <WBQuestionTableViewCellDelegate,UITableViewDelegate> {
    CGFloat _beginScoller;
}

@property (nonatomic, strong) NSMutableArray *questionsList;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, assign) int selectedRow;

//@property (nonatomic, assign) CGFloat scrollPosition;

@end

@implementation WBQuestionsViewController

-(NSMutableArray *)questionsList{
    if (_questionsList) {
        return _questionsList;
    }
    _questionsList = [NSMutableArray array];
    return _questionsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.fromFindView) {
        self.navigationItem.title = self.viewTitle;
    }
    
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor initWithBackgroundGray];
    
    [self refreshTableView];
    
    [self setUpSearchBox];
    
    self.currentPage = 1;
    if (self.currentPage == 1) {
        [self showHUD:@"正在努力加载..." isDim:NO];
    }
    
    [self loadDataWithPage:self.currentPage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                  selector:@selector(showSearchResultView:)
                      name:@"showSearchResultView"
                    object:nil];
}

-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpSearchBox{
    if (!self.fromFindView) {
        return;
    }
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, MARGINOUTSIDE + 25)];
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.02, MARGINOUTSIDE, SCREENWIDTH * 0.96, 25)];
    searchButton.backgroundColor = [UIColor whiteColor];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 5;
    [searchButton addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3.5, 18, 18)];
    searchIcon.image = [UIImage imageNamed:@"icon_search"];
    UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(28, 3.5, 140, 18)];
    placeholder.text = @"搜索问题或相关用户";
    placeholder.textColor = [UIColor initWithNormalGray];
    placeholder.font = MAINFONTSIZE;
    [searchButton addSubview:searchIcon];
    [searchButton addSubview:placeholder];
    [searchView addSubview:searchButton];
    self.tableView.tableHeaderView = searchView;
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

#pragma mark - loadData

-(void)loadDataWithPage:(int)page{
    NSString *url = [[NSString alloc] init];
    
    if (self.fromFindView) {
        url = [NSString stringWithFormat:QUESTION_IN_FIND,page,PAGESIZE];
    }else{
        url = [NSString stringWithFormat:QUESTION_IN_GROUP,self.groupId,page,PAGESIZE];
    }
    
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            NSMutableArray *tempArray = [NSMutableArray array];
            tempArray = [WBQuestionsListModel mj_objectArrayWithKeyValuesArray:result[@"question"]];
            if (tempArray.count > 0) {
                if (page == 1) {
                    self.questionsList = tempArray;
                    self.currentPage ++;
                }else{
                    [self.questionsList addObjectsFromArray:tempArray];
                    self.currentPage ++;
                }
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionsList.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [[NSString alloc] init];
    switch (indexPath.row % 10) {
        case 0:
            cellID = @"reuse0";
            break;
        case 1:
            cellID = @"reuse1";
            break;
        case 2:
            cellID = @"reuse2";
            break;
        case 3:
            cellID = @"reuse3";
            break;
        case 4:
            cellID = @"reuse4";
            break;
        case 5:
            cellID = @"reuse5";
            break;
        case 6:
            cellID = @"reuse6";
            break;
        case 7:
            cellID = @"reuse7";
            break;
        case 8:
            cellID = @"reuse8";
            break;
        case 9:
            cellID = @"reuse9";
            break;
    }
    
    WBQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[WBQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID withData:self.questionsList[indexPath.row]];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.questionsList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - cell click delegate

-(void)questionView:(WBQuestionTableViewCell *)cell{
    self.selectedRow = (int)cell.tag;
    
    WBAnswerListController *answerListController = [[WBAnswerListController alloc] init];
    [answerListController setHidesBottomBarWhenPushed:YES];
    WBQuestionsListModel *data = self.questionsList[self.selectedRow];
    answerListController.fromFindView = self.fromFindView;
    answerListController.isMaster = self.isMaster;
    answerListController.questionText = data.questionText;
    answerListController.questionId = data.questionId;
    answerListController.allAnswers = data.allAnswers;
    answerListController.allIntegral = data.allIntegral;
    answerListController.isSolved = data.isSolve;
    answerListController.groupId = data.groupId;
    answerListController.userId = data.hga.tblUser.userId;
    NSLog(@"%@",self.parentViewController.parentViewController.parentViewController.childViewControllers.lastObject.childViewControllers.lastObject);
    if (self.fromFindView) {
        [self.parentViewController.navigationController pushViewController:answerListController animated:YES];
        return;
    }
    [(UINavigationController *)self.parentViewController pushViewController:answerListController animated:YES];
    
    
}

-(void)answerView:(WBQuestionTableViewCell *)cell{
    self.selectedRow = (int)cell.tag;
    
    WBAnswerDetailController *answerDetailController = [[WBAnswerDetailController alloc] init];
    [answerDetailController setHidesBottomBarWhenPushed:YES];
    WBQuestionsListModel *data = self.questionsList[self.selectedRow];
    answerDetailController.fromFindView = self.fromFindView;
    answerDetailController.isMaster = self.isMaster;
    answerDetailController.hasPrevPage = NO;
    answerDetailController.questionText = data.questionText;
    answerDetailController.answerId = data.hga.answerId;
    answerDetailController.questionId = data.questionId;
    answerDetailController.allAnswers = data.allAnswers;
    answerDetailController.allIntegral = data.allIntegral;
    answerDetailController.dir = data.hga.tblUser.dir;
    answerDetailController.nickname = data.hga.tblUser.nickname;
    answerDetailController.timeStr = data.hga.timeStr;
    answerDetailController.getIntegral = data.hga.getIntegral;
    answerDetailController.userId = data.hga.tblUser.userId;
    if (self.fromFindView) {
        [self.parentViewController.navigationController pushViewController:answerDetailController animated:YES];
        return;
    }
    [(UINavigationController *)self.parentViewController pushViewController:answerDetailController animated:YES];
    
}

-(void)iconView:(WBQuestionTableViewCell *)cell{
    self.selectedRow = (int)cell.tag;
    WBQuestionsListModel *data = self.questionsList[self.selectedRow];
    WBHomepageViewController *homepage = [[WBHomepageViewController alloc] init];
    homepage.friendId = [NSString stringWithFormat:@"%ld",data.hga.tblUser.userId];
    homepage.hidesBottomBarWhenPushed = YES;
    if (self.fromFindView) {
        [self.parentViewController.navigationController pushViewController:homepage animated:YES];
        return;
    }
    [(UINavigationController *)self.parentViewController pushViewController:homepage animated:YES];
}

-(void)showSearchView{
    WBSearchViewController *searchVC = [[WBSearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
}

-(void)showSearchResultView:(NSNotification*)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSearchResultView" object:nil];
    WBAnswerListController *answerListController = [[WBAnswerListController alloc] init];
    [answerListController setHidesBottomBarWhenPushed:YES];
    answerListController.fromFindView = YES;
    answerListController.questionText = sender.userInfo[@"questionText"];
    answerListController.questionId = [sender.userInfo[@"questionId"] integerValue];
    answerListController.allAnswers = [sender.userInfo[@"allAnswers"] integerValue];
    answerListController.allIntegral = [sender.userInfo[@"allIntegral"] integerValue];
    answerListController.userId = [sender.userInfo[@"userId"] integerValue];
    [self.parentViewController.navigationController pushViewController:answerListController animated:YES];
}

#pragma mark -- UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint scrollViewOffset = scrollView.contentOffset;
    _beginScoller = scrollViewOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint scrollViewOffset = scrollView.contentOffset;
    if (scrollViewOffset.y - _beginScoller >= 0) {
        //往下滑
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.tabBarController.tabBar setFrame:CGRectMake(0.0f,SCREENHEIGHT,self.view.frame.size.width,49)];
                         }];
    }else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self.tabBarController.tabBar setFrame:CGRectMake(0.0f,SCREENHEIGHT - 49,self.view.frame.size.width,49)];
                         }];
    }
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
