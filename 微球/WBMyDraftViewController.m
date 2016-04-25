//
//  WBMyDraftViewController.m
//  微球
//
//  Created by 徐亮 on 16/4/18.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMyDraftViewController.h"
#import "WBDraftManager.h"
#import "WBDraftSave.h"
#import "WBPostArticleViewController.h"
#import "WBAnswerQuestionViewController.h"
#import "NSString+string.h"

@interface WBMyDraftViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_draftArray;
    UIImageView *_background;
}

@end

@implementation WBMyDraftViewController

- (instancetype)init{
    if (self = [super init]) {
        self .view.backgroundColor = [UIColor initWithBackgroundGray];
        self.navigationItem.title = @"我的草稿";
        
        _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
        _background.center = CGPointMake(SCREENWIDTH / 2, 170);
        
        [self setUpTableView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getDraft];
}

- (void)setUpTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview: _tableView];
}

- (void)getDraft{
    _draftArray = (NSMutableArray *)[[WBDraftManager openDraft] allDrafts];
    [_tableView reloadData];
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = _draftArray.count;
    if (count == 0) {
        [self.view addSubview:_background];
    } else {
        [_background removeFromSuperview];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        WBDraftSave *draft = _draftArray[indexPath.row];
        if ([draft.type isEqualToString:@"1"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"【问题】%@",draft.title];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"【话题】%@",draft.title];
        }
        cell.textLabel.textColor = [UIColor initWithLightGray];
        cell.textLabel.font = MAINFONTSIZE;
        cell.detailTextLabel.text = [draft.content replaceImageSign];
        cell.detailTextLabel.textColor = [UIColor initWithNormalGray];
        cell.detailTextLabel.font = FONTSIZE12;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WBDraftSave *draft = _draftArray[indexPath.row];
    if ([draft.type isEqualToString:@"1"]) {
        WBAnswerQuestionViewController *writeVC = [[WBAnswerQuestionViewController alloc] initWithGroupId:draft.aim questionId:draft.contentId title:draft.title];
        writeVC.isModified = YES;
        writeVC.draft = draft;
        [self.navigationController pushViewController:writeVC animated:YES];
    } else {
        WBPostArticleViewController *writeVC = [[WBPostArticleViewController alloc] initWithTopicId:draft.contentId title:draft.title];
        writeVC.isModified = YES;
        writeVC.draft = draft;
        [self.navigationController pushViewController:writeVC animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
