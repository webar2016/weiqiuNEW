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
    _draftArray = (NSMutableArray *)[[WBDraftManager openDraft] allDraftsWithUserId:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]];
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
        }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return   UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    WBDraftSave *draft = _draftArray[indexPath.row];
//    NSLog(@"%@---%@---%@",draft.title,draft.type,draft.contentId);
    BOOL isSuccess = [[WBDraftManager openDraft] deleteDraftWithType:draft.type contentId:draft.contentId userId:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]];
    if (isSuccess) {
        [_draftArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"draft"];
        NSString *currentDraft = [NSString stringWithFormat:@"%@-%@-%@", draft.userId,draft.type,draft.contentId];
        NSString *draftPath = [path stringByAppendingPathComponent:currentDraft];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:draftPath]){
            [[NSFileManager defaultManager]  removeItemAtPath:draftPath error:nil];
        }
    } else {
        [self showHUDText:@"删除失败，请重试"];
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
