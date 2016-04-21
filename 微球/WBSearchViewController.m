//
//  WBSearchViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/18.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSearchViewController.h"
#import "WBAnswerListController.h"

#import "WBQuestionTableViewCell.h"
#import "WBUserListTableViewCell.h"

#import "MyDownLoadManager.h"
#import "MJExtension.h"
#import "WBQuestionsListModel.h"
#import "WBUserInfosModel.h"

#define SEARCH_URL @"http://app.weiqiu.me/tq/search?content=%@"

@interface WBSearchViewController () <UITextFieldDelegate,WBQuestionTableViewCellDelegate> {
    UIView      *_headerView;
    UITextField  <UITextInputTraits>   *_searchField;
    UIButton    *_questionButton;
    UIButton    *_userButton;
    
    NSString    *_searchString;
    NSInteger   _currentPage;
    
    BOOL        _keyboardIsHide;
}

@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, assign) int selectedRow;

@end

@implementation WBSearchViewController

-(NSMutableArray *)questionsArray{
    if (_questionsArray) {
        return _questionsArray;
    }
    _questionsArray = [NSMutableArray array];
    return _questionsArray;
}

-(NSMutableArray *)usersArray{
    if (_usersArray) {
        return _usersArray;
    }
    _usersArray = [NSMutableArray array];
    return _usersArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor initWithBackgroundGray];
    _currentPage = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setUpHeaderView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 104)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(25, 31, SCREENWIDTH - 75, 20)];
    _searchField.placeholder = @"搜索问题或相关用户";
    _searchField.textColor = [UIColor initWithNormalGray];
    _searchField.font = MAINFONTSIZE;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.delegate = self;
    _searchField.clearsOnBeginEditing = YES;
    if (!_keyboardIsHide) {
        [_searchField becomeFirstResponder];
    }
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 55, 20, 55, 42)];
    cancelButton.titleLabel.font = MAINFONTSIZE;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backLastView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 62, SCREENWIDTH, 42)];
    selectView.image = [UIImage imageNamed:@"bg-9"];
    
    _questionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 62, SCREENWIDTH / 2, 42)];
    _questionButton.tag = 1;
    _questionButton.titleLabel.font = MAINFONTSIZE;
    [_questionButton setTitle:@"问题" forState:UIControlStateNormal];
    [_questionButton setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
    [_questionButton addTarget:self action:@selector(changeResult:) forControlEvents:UIControlEventTouchUpInside];
    
    _userButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2, 62, SCREENWIDTH / 2, 42)];
    _userButton.tag = 2;
    _userButton.titleLabel.font = MAINFONTSIZE;
    [_userButton setTitle:@"用户" forState:UIControlStateNormal];
    [_userButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
    [_userButton addTarget:self action:@selector(changeResult:) forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView addSubview:selectView];
    [_headerView addSubview:_questionButton];
    [_headerView addSubview:_userButton];
    [_headerView addSubview:_searchField];
    [_headerView addSubview:cancelButton];
}

#pragma mark - tableview delegate datasource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 104.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentPage == 1) {
        if (self.questionsArray.count == 0) {
            return 1;
        }
        return self.questionsArray.count;
    } else {
        if (self.usersArray.count == 0) {
            return 1;
        }
        return self.usersArray.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentPage == 2) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchResultView" object:self userInfo:@{@"searchPearch":@YES,@"userId":[NSString stringWithFormat:@"%ld",(long)((WBUserInfosModel *)self.usersArray[indexPath.row]).userId]}];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentPage == 1) {
        if (self.questionsArray.count == 0) {
            return 40;
        }
        return [WBQuestionTableViewCell getCellHeightWithModel:self.questionsArray[indexPath.row]];
    } else {
        if (self.usersArray.count == 0) {
            return 40;
        }
        return 75;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentPage == 1) {
        if (self.questionsArray.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"无搜索结果";
            cell.textLabel.textColor = [UIColor initWithNormalGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *cellID = @"reuse";
        
        WBQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[WBQuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.questionsArray[indexPath.row];
        return cell;
        
    } else {
        if (self.usersArray.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"无搜索结果";
            cell.textLabel.textColor = [UIColor initWithNormalGray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor initWithBackgroundGray];
        static NSString *cellID = @"reuse";
        WBUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[WBUserListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.model = self.usersArray[indexPath.row];
        return cell;
        
    }
}

#pragma mark - search

-(void)searchContent{
    NSString *url = [NSString stringWithFormat:SEARCH_URL,_searchString];
    [MyDownLoadManager getNsurl:url whenSuccess:^(id representData) {
        id result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]){
            
            self.questionsArray = [WBQuestionsListModel mj_objectArrayWithKeyValuesArray:result[@"question"]];
            self.usersArray = [WBUserInfosModel mj_objectArrayWithKeyValuesArray:result[@"users"]];
            
            [self.tableView reloadData];
        }
    } andFailure:^(NSString *error) {
        NSLog(@"error---%@",error);
    }];
}

#pragma mark - oprations
-(void)backLastView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeResult:(UIButton *)sender{
    if (_currentPage == sender.tag) {
        return;
    }
    _currentPage = sender.tag;
    if (_currentPage == 1) {
        [_questionButton setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
        [_userButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
        [self.tableView reloadData];
    } else {
        [_questionButton setTitleColor:[UIColor initWithNormalGray] forState:UIControlStateNormal];
        [_userButton setTitleColor:[UIColor initWithGreen] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    _searchString = [_searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (_searchString.length == 0) {
        return NO;
    }
    [_searchField resignFirstResponder];
    _keyboardIsHide = YES;
    [self searchContent];
    return YES;
}

#pragma mark - cell click delegate

-(void)questionView:(WBQuestionTableViewCell *)cell{
    self.selectedRow = (int)cell.tag;
    WBQuestionsListModel *data = self.questionsArray[self.selectedRow];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"questionText"] = data.questionText;
    dic[@"questionId"] = [NSString stringWithFormat:@"%ld",(long)data.questionId];
    dic[@"allAnswers"] = [NSString stringWithFormat:@"%ld",(long)data.allAnswers];
    dic[@"allIntegral"] = [NSString stringWithFormat:@"%ld",(long)data.allIntegral];
    dic[@"suerId"] = [NSString stringWithFormat:@"%ld",(long)data.hga.tblUser.userId];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchResultView" object:self userInfo:dic];
    }];
}

-(void)iconView:(WBQuestionTableViewCell *)cell{
    NSLog(@"进入个人主页");
}

@end
